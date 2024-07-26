import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/networking/api_constants.dart';

class PasswordResetService {
  static const int _timeoutDuration =10000;

  Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        headers: {'Content-Type': 'application/json'},
        //connectTimeout: const Duration(milliseconds: _timeoutDuration),
      //  receiveTimeout: const Duration(milliseconds: _timeoutDuration),
      ),
    );
  }

  Future<void> requestPasswordReset(BuildContext context, String loginOrEmail) async {
    Dio dio = _createDio();

    try {
      final response = await dio.post(
        ApiConstants.apiRequestPasswordRest(loginOrEmail),
      );

      if (response.statusCode == 200 && response.data['succeeded'] == true) {
        print("OTP >>> "+response.data);
        context.pushNamed(Routes.verifyOtpScreen);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP request successful. Please check your email.'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        print(response.data);
        if (response.data['errors'] != null && response.data['errors'].contains('User is not exist')) {
          _showErrorSnackBar(context, 'User does not exist. Please check your phone number.');
        } else {
          _showErrorSnackBar(context, 'Failed to request password reset. Please try again.');
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, 'An error occurred: ${e.toString()}');
      print(e.toString());
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),backgroundColor: Colors.red),
    );
  }
}
