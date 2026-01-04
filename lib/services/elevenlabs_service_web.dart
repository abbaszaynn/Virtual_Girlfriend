import 'dart:html' as html;

/// Web implementation - creates Blob URL from audio bytes
Future<String> createAudioUrl(List<int> bytes) async {
  final blob = html.Blob([bytes], 'audio/mpeg');
  final url = html.Url.createObjectUrlFromBlob(blob);
  return url;
}
