import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OpenRouterService {
  final String _baseUrl = 'https://openrouter.ai/api/v1';

  Future<String?> getChatCompletion({
    required String userMessage,
    required String systemPrompt,
    List<Map<String, dynamic>> history = const [],
  }) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENROUTER_API_KEY is not set in .env');
    }

    // Construct messages list
    final List<Map<String, String>> messages = [];

    // Add system prompt
    messages.add({'role': 'system', 'content': systemPrompt});

    // Add history (limit to last 10 messages to save tokens)
    final int startIndex = history.length > 10 ? history.length - 10 : 0;
    final limitedHistory = history.sublist(startIndex);

    for (var msg in limitedHistory) {
      final role = msg['sender_type'] == 'user' ? 'user' : 'assistant';
      final content = msg['content']?.toString() ?? '';
      if (content.isNotEmpty) {
        messages.add({'role': role, 'content': content});
      }
    }

    messages.add({'role': 'user', 'content': userMessage});

    try {
      debugPrint("DEBUG: Sending request to OpenRouter (Primary)...");
      final response = await http
          .post(
            Uri.parse('$_baseUrl/chat/completions'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
              'HTTP-Referer': 'https://kraveai.com',
              'X-Title': 'Kraveai',
            },
            body: jsonEncode({
              'model': 'nousresearch/hermes-3-llama-3.1-405b',
              'messages': messages,
            }),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("DEBUG: OpenRouter Response Code: ${response.statusCode}");
      debugPrint("DEBUG: OpenRouter Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null &&
            data['choices'] != null &&
            data['choices'].isNotEmpty) {
          final content = data['choices'][0]['message']['content'];
          if (content != null && content.toString().isNotEmpty) {
            return content;
          } else {
            debugPrint("DEBUG: OpenRouter returned null/empty content.");
          }
        }
      } else {
        debugPrint(
          'Primary Model Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Primary Model Exception: $e');
    }

    // Fallback Model
    debugPrint("Switching to fallback model...");
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/chat/completions'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
              'HTTP-Referer': 'https://kraveai.com',
              'X-Title': 'Kraveai',
            },
            body: jsonEncode({
              'model': 'cognitivecomputations/dolphin-mixtral-8x22b',
              'messages': messages,
            }),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("DEBUG: Fallback Response Code: ${response.statusCode}");

      if (response.statusCode != 200) {
        debugPrint(
          'Fallback Model Error: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to fetch response from OpenRouter (Both models failed)',
        );
      }

      final data = jsonDecode(response.body);
      if (data != null &&
          data['choices'] != null &&
          data['choices'].isNotEmpty) {
        final content = data['choices'][0]['message']['content'];
        return content;
      }
    } catch (e) {
      debugPrint('Fallback Model Exception: $e');
      rethrow;
    }

    return null;
  }
}
