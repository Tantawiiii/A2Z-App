

import 'package:dio/dio.dart';

import 'api_constants.dart';

class DioExceptions {
  static const int _timeoutDuration =10000;

  Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(milliseconds: _timeoutDuration),
        receiveTimeout: const Duration(milliseconds: _timeoutDuration),
      ),
    );
  }

}