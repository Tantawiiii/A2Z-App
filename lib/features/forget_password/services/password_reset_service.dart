import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/networking/api_constants.dart';

class PasswordResetService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> sendPasswordResetRequest(String loginOrEmail) async {
    const String resetPasswordEndPoints = ApiConstants.apiRequestPasswordRest;

    try {
      final response = await _dio.post(
        resetPasswordEndPoints,
        data: {'loginOrEmail': loginOrEmail}, // Assuming you need to pass the login or email
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Send Success OTP: ${response.data}');
        }
        return {
          'succeeded': true,
          'data': response.data,
        };
      } else {
        if (kDebugMode) {
          print('Failed with status code: ${response.statusCode}');
        }
        // Parse error message from response if available
        final errorMessage = response.data['errors']?.join(', ') ?? 'Unknown error';
        return {
          'succeeded': false,
          'error': 'Failed with status code: ${response.statusCode}, Error: $errorMessage',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return {
        'succeeded': false,
        'error': 'Failed to send password reset request: $e',
      };
    }
  }
}
