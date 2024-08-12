import 'dart:convert';
import 'package:a2z_app/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/networking/clients/dio_client.dart';
import '../../../../../core/widgets/build_toast.dart';
import '../../../../forget_password/services/network/response_handlers_change_password.dart';


final DioClient dioClient = DioClient();

Future<void> changePassword({
  required BuildContext context,
  required String username,
  required String oldPassword,
  required String newPassword,
}) async {
  final String url = ApiConstants.apiChangePassword;

  try {
    final response = await dioClient.dio.post(
      url,
      data: jsonEncode({
        'userName': username,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    handlePasswordChangeResponse(
        context, response.statusCode ?? 0, response.statusMessage);
  } on DioException catch (e) {
    if (e.response != null) {
      buildFailedToast(context,
          'Error response: ${e.response?.statusCode} ${e.response
              ?.statusMessage}');
    } else {
      buildFailedToast(context, 'Error: ${e.message}');
    }
  }
}

