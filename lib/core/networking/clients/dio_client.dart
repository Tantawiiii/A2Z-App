import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const/api_constants.dart';

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

  // Method to set the authorization token
  Future<void> setAuthorizationToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
        'access_token');

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}
