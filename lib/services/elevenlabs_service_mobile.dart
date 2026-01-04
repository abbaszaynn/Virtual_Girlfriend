import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Mobile/Desktop implementation - saves audio bytes to temporary file
Future<String> createAudioUrl(List<int> bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File(
    '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  );
  await file.writeAsBytes(bytes);
  return file.path;
}
