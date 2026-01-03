import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart'
    as http; // GetConnect doesn't handle binary bytes easily
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class ElevenLabsService {
  final String _baseUrl = 'https://api.elevenlabs.io/v1';

  Future<File?> generateAudio({
    required String text,
    required String voiceId,
  }) async {
    final rawKey = dotenv.env['ELEVENLABS_API_KEY'];
    final apiKey = rawKey?.trim();

    debugPrint("DEBUG: Raw Key from .env: '$rawKey'");
    if (apiKey != null) {
      debugPrint("DEBUG: Trimmed Key Length: ${apiKey.length}");
      debugPrint("DEBUG: Key starts with: ${apiKey.substring(0, 4)}...");
      debugPrint(
        "DEBUG: Key ends with: ...${apiKey.substring(apiKey.length - 4)}",
      );
    } else {
      debugPrint("DEBUG: Key is NULL");
    }

    if (apiKey == null || apiKey.isEmpty) {
      debugPrint("❌ ElevenLabs Error: API Key missing");
      return null;
    }

    try {
      final url = Uri.parse('$_baseUrl/text-to-speech/$voiceId');
      final response = await http.post(
        url,
        headers: {
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        body:
            '{"text": "$text", "model_id": "eleven_monolingual_v1", "voice_settings": {"stability": 0.5, "similarity_boost": 0.5}}',
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
        );
        await file.writeAsBytes(bytes);
        debugPrint("✅ Audio generated: ${file.path}");
        return file;
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
