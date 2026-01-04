import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'elevenlabs_service_stub.dart'
    if (dart.library.html) 'elevenlabs_service_web.dart'
    if (dart.library.io) 'elevenlabs_service_mobile.dart';

class ElevenLabsService {
  final String _baseUrl = 'https://api.elevenlabs.io/v1';

  /// Returns audio URL (Blob URL for web, file path for mobile/desktop)
  Future<String?> generateAudio({
    required String text,
    required String voiceId,
  }) async {
    final rawKey = dotenv.env['ELEVENLABS_API_KEY'];
    final apiKey = rawKey?.trim();

    if (apiKey == null || apiKey.isEmpty) {
      debugPrint("❌ ElevenLabs Error: API Key missing");
      return null;
    }

    try {
      // Sanitize text: remove control characters that cause JSON issues
      final sanitizedText = text.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');

      final url = Uri.parse('$_baseUrl/text-to-speech/$voiceId');
      final response = await http.post(
        url,
        headers: {
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        body: jsonEncode({
          'text': sanitizedText,
          'model_id': 'eleven_turbo_v2_5',
          'voice_settings': {'stability': 0.5, 'similarity_boost': 0.5},
        }),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Use platform-specific implementation
        final audioUrl = await createAudioUrl(bytes);
        debugPrint("✅ Audio generated: $audioUrl");
        return audioUrl;
      } else {
        debugPrint(
          "❌ ElevenLabs Error: ${response.statusCode} - ${response.body}",
        );
        return null;
      }
    } catch (e) {
      debugPrint("❌ ElevenLabs Exception: $e");
      return null;
    }
  }
}
