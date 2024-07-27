import 'package:a2z_app/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/networking/dio_client.dart';
import '../../../../core/widgets/build_toast.dart';
import 'response_handlers_change_password.dart';

final DioClient _dioClient = DioClient();

Future<void> changePasswordByOTP(BuildContext context, String phoneNumber,
    String otp, String newPassword) async {
  final dio = _dioClient.createDio();
  final url = ApiConstants.apiChangePasswordByOTP;

  try {
    final response = await dio.post(
      url,
      data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'newPassword': newPassword,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    handlePasswordChangeResponse(
        context, response.statusCode ?? 0, response.statusMessage);
  } on DioError catch (e) {
    // Handle DioError exceptions
    if (e.response != null) {
      buildFailedToast(context,
          'Error response: ${e.response?.statusCode} ${e.response?.statusMessage}');
    } else {
      buildFailedToast(context, 'Error: ${e.message}');
    }
  }
}
