import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forensicsRepositoryProvider = Provider<ForensicsRepository>((ref) {
  return ForensicsRepository('http://localhost:3000/api');
});

class ForensicsRepository {
  final String baseUrl;
  ForensicsRepository(this.baseUrl);

  Future<Map<String, dynamic>> analyzeImage(Uint8List bytes, String fileName) async {
    final uri = Uri.parse('$baseUrl/forensics/analyze-vision');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: fileName,
      contentType: MediaType('image', 'jpeg'), // Generic fallback
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to communicate with Master Eye Orchestrator: $e');
    }
  }
}
