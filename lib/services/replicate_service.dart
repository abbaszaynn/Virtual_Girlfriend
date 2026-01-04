import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ReplicateService {
  // Using Supabase Edge Function as proxy to bypass CORS on web
  // Replace YOUR_PROJECT_REF with your actual Supabase project reference
  // Format: https://YOUR_PROJECT_REF.supabase.co/functions/v1/
  String get _proxyUrl {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      debugPrint("❌ SUPABASE_URL not found in .env");
      return '';
    }
    // Extract project ref from URL (e.g., https://abcxyz.supabase.co)
    return '$supabaseUrl/functions/v1/replicate_proxy';
  }

  String get _pollUrl {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      return '';
    }
    return '$supabaseUrl/functions/v1/replicate_poll';
  }

  Future<String?> generateImage(String prompt) async {
    if (_proxyUrl.isEmpty) {
      debugPrint("❌ Supabase URL not configured");
      return null;
    }

    try {
      debugPrint(
        "DEBUG: Generating image via Supabase proxy for prompt: $prompt",
      );

      // 1. Start Prediction via proxy
      final response = await http
          .post(
            Uri.parse(_proxyUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String status = data['status'];

        // If 'wait' header worked and it's done:
        if (status == 'succeeded') {
          final output = data['output'];
          if (output != null && output is List && output.isNotEmpty) {
            final imageUrl = output[0];
            debugPrint("✅ Image Ready: $imageUrl");
            return imageUrl;
          }
        }

        // If 'starting' or 'processing', we need to poll
        final getUrl = data['urls']?['get'];
        if (getUrl != null) {
          return await _pollForResult(getUrl);
        } else {
          debugPrint("❌ No polling URL returned from proxy");
          return null;
        }
      } else {
        debugPrint("❌ Proxy Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } on http.ClientException catch (e) {
      debugPrint("❌ HTTP ClientException: $e");
      return null;
    } on TimeoutException catch (e) {
      debugPrint("❌ Request Timeout: $e");
      return null;
    } catch (e, stackTrace) {
      debugPrint("❌ Exception: $e");
      debugPrint("Stack trace: $stackTrace");
      return null;
    }
  }

  Future<String?> _pollForResult(String predictionUrl) async {
    if (_pollUrl.isEmpty) {
      debugPrint("❌ Poll URL not configured");
      return null;
    }

    int attempts = 0;
    while (attempts < 30) {
      // Max 30 attempts (~1 min)
      await Future.delayed(const Duration(seconds: 2));
      attempts++;

      try {
        final response = await http.post(
          Uri.parse(_pollUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'predictionUrl': predictionUrl}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final status = data['status'];
          debugPrint("DEBUG: Image status: $status (Attempt $attempts)");

          if (status == 'succeeded') {
            final output = data['output'];
            if (output != null && output is List && output.isNotEmpty) {
              final imageUrl = output[0];
              debugPrint("✅ Image Generated Successfully: $imageUrl");
              return imageUrl;
            }
          } else if (status == 'failed' || status == 'canceled') {
            debugPrint("❌ Image Generation Failed/Canceled");
            return null;
          }
        }
      } catch (e) {
        debugPrint("Polling Error: $e");
      }
    }
    debugPrint("❌ Image Generation Timed Out");
    return null;
  }
}
