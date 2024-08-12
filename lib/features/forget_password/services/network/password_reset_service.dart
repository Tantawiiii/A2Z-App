import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
import '../../../../core/networking/clients/dio_client.dart';
import 'response_handlers_forgetPassword.dart';

class PasswordResetService {
  final DioClient _dioClient = DioClient();

  Future<void> requestPasswordReset(BuildContext context, String loginOrEmail) async {
    Dio dio = _dioClient.dio;

    try {
      final response = await dio.post(
        ApiConstants.apiRequestPasswordRest(loginOrEmail),
      );

      if (response.statusCode == 200) {
        handleSuccessResponse(context, response.data);
      } else {
        handleFailedRequest(context);
      }
    } catch (e) {
      handleError(context, e);
    }
  }
}
