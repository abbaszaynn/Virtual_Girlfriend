import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BytezImageService {
  final String _apiKey = "58d729c252dbcacd0239cedf7b1c3a56";
  final String _modelId = "hakurei/waifu-diffusion";
  final String _baseUrl = 'https://api.bytez.com/models/v2';

  Future<String?> generateImage(String prompt) async {
    try {
      debugPrint("DEBUG: Sending Image Gen request to Bytez ($_modelId)...");
      debugPrint("DEBUG: Prompt: $prompt");

      final response = await http
          .post(
            Uri.parse('$_baseUrl/$_modelId'),
            headers: {
              'Authorization': 'Key $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'input': prompt}),
          )
          .timeout(const Duration(seconds: 60));

      debugPrint("DEBUG: Bytez Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("DEBUG: Bytez Image Full Response: $data");

        if (data != null && data['output'] != null) {
          final output = data['output'];
          // Expecting a URL or Base64.
          // If it's a list (common in some APIs), take the first item.
          if (output is List && output.isNotEmpty) {
            return output.first.toString();
          } else if (output is String) {
            return output;
          }
        }
      } else {
        debugPrint(
          'Bytez Image Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Bytez Image Service Exception: $e');
    }

    return null;
  }
}
