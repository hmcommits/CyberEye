import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forensicsRepositoryProvider = Provider<ForensicsRepository>((ref) {
  return ForensicsRepository(Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))); // Adjust base URL for production
});

class ForensicsRepository {
  final Dio _dio;
  ForensicsRepository(this._dio);

  Future<Map<String, dynamic>> analyzeImage(Uint8List bytes, String fileName) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    try {
      final response = await _dio.post('/forensics/analyze', data: formData);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to communicate with Master Eye Orchestrator: $e');
    }
  }
}
