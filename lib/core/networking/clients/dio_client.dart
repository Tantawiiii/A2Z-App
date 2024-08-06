import 'package:dio/dio.dart';
import '../api_constants.dart';

class DioClient {
  static const int _timeoutDuration = 30000;
  final Dio _dio;

  DioClient() : _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(milliseconds: _timeoutDuration),
      receiveTimeout: const Duration(milliseconds: _timeoutDuration),
    ),
  );

  Dio get dio => _dio;
}
