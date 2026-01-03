import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ReplicateService {
  // Using a fast, high-quality realistic model
  // Model: stability-ai/sdxl (Official)
  // Version: 39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b
  static const String modelVersion =
      "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b";
  final String _baseUrl = 'https://api.replicate.com/v1/predictions';

  Future<String?> generateImage(String prompt) async {
    final apiKey = dotenv.env['REPLICATE_API_KEY']?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint("❌ Replicate Error: API Key missing");
      return null;
    }

    try {
      debugPrint("DEBUG: Generating image for prompt: $prompt");

      // 1. Start Prediction
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Token $apiKey',
          'Content-Type': 'application/json',
          'Prefer':
              'wait', // Wait slightly to try and get result immediately, but usually it takes longer
        },
        body: jsonEncode({
          "version": modelVersion,
          "input": {
            "prompt":
                "A realistic photo of a beautiful young woman, $prompt, high quality, 8k, photorealistic",
            "negative_prompt":
                "cartoon, illustration, anime, ugly, deformed, low quality, pixelated, blur",
            "width": 768,
            "height": 1024, // Portrait for mobile
          },
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
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
        final getUrl = data['urls']['get'];
        return await _pollForResult(getUrl, apiKey);
      } else {
        debugPrint(
          "❌ Replicate Error: ${response.statusCode} - ${response.body}",
        );
        return null;
      }
    } catch (e) {
      debugPrint("❌ Replicate Exception: $e");
      return null;
    }
  }

  Future<String?> _pollForResult(String url, String apiKey) async {
    int attempts = 0;
    while (attempts < 30) {
      // Max 30 attempts (~1 min)
      await Future.delayed(const Duration(seconds: 2));
      attempts++;

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Token $apiKey',
            'Content-Type': 'application/json',
          },
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
