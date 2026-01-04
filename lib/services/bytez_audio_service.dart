import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class BytezAudioService {
  final String _apiKey = "58d729c252dbcacd0239cedf7b1c3a56";
  final String _modelId = "suno/bark";
  final String _baseUrl = 'https://api.bytez.com/models/v2';

  Future<File?> generateAudio(String text) async {
    try {
      debugPrint("DEBUG: Sending Audio Gen request to Bytez ($_modelId)...");

      final response = await http
          .post(
            Uri.parse('$_baseUrl/$_modelId'),
            headers: {
              'Authorization': 'Key $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'input': text}),
          )
          .timeout(const Duration(seconds: 90)); // Optimized for TTS generation

      debugPrint("DEBUG: Bytez Audio Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("DEBUG: Bytez Audio Response Data: $data");

        if (data != null && data['output'] != null) {
          final output = data['output'];

          Uint8List? audioBytes;

          // Handle Base64 String
          if (output is String) {
            // Check if it's a URL or Base64
            if (output.startsWith('http')) {
              // Is URL, download it
              debugPrint("DEBUG: Downloading audio from URL: $output");
              final download = await http.get(Uri.parse(output));
              if (download.statusCode == 200) {
                audioBytes = download.bodyBytes;
              }
            } else {
              // Assume Base64
              try {
                audioBytes = base64Decode(output);
                debugPrint(
                  "DEBUG: Decoded base64 audio, size: ${audioBytes.length} bytes",
                );
              } catch (e) {
                debugPrint("Failed to decode base64 audio: $e");
              }
            }
          }
          // Handle Raw Byte List
          else if (output is List) {
            audioBytes = Uint8List.fromList(output.cast<int>());
            debugPrint(
              "DEBUG: Converted audio list to bytes, size: ${audioBytes.length} bytes",
            );
          }

          if (audioBytes != null) {
            final tempDir = await getTemporaryDirectory();
            final file = await File(
              '${tempDir.path}/bytez_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
            ).create();
            await file.writeAsBytes(audioBytes);
            debugPrint("DEBUG: Audio saved to ${file.path}");
            return file;
          } else {
            debugPrint("DEBUG: audioBytes is null, no audio data received");
          }
        } else {
          debugPrint("DEBUG: No 'output' field in response data");
        }
      } else {
        debugPrint(
          'Bytez Audio Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Bytez Audio Service Exception: $e');
      rethrow; // Re-throw to let caller handle gracefully
    }

    return null;
  }
}
