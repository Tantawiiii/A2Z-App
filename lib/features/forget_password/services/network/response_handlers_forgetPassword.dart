import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:flutter/material.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';
import 'package:a2z_app/core/routing/routers.dart';

void handleSuccessResponse(BuildContext context, dynamic data) {
  if (data is String) {
    handlePlainTextResponse(context, data);
  } else if (data is Map) {
    handleJsonResponse(context, data as Map<String, dynamic>);
  } else {
    buildFailedToast(context, 'Unexpected response format.');
  }
}

void handlePlainTextResponse(BuildContext context, String data) {
  if (data == "User does not exist") {
    buildFailedToast(context, 'User does not exist. Please check your phone number.');
  } else {
    print("OTP >>> $data");
    context.pushNamed(Routes.verifyOtpScreen);
    buildSuccessToast(context, "OTP $data successful. Please check your email. ");
  }
}

void handleJsonResponse(BuildContext context, Map<String, dynamic> data) {
  print("Response data: $data");
  print("Data type: ${data.runtimeType}");

  List<dynamic> errors = [];
  if (data['errors'] != null && data['errors'] is List) {
    errors = data['errors'];
  }

  if (data['succeeded'] == false) {
    buildFailedToast(context, 'User does not exist. Please check your phone number.');
  } else {
    print("OTP >>> $data");
    context.pushNamed(Routes.verifyOtpScreen);
    buildSuccessToast(context, "OTP request successful. Please check your email.");
  }
}

void handleFailedRequest(BuildContext context) {
  buildFailedToast(context, 'Failed to request password reset. Please try again.');
}

void handleError(BuildContext context, dynamic e) {
  buildFailedToast(context, 'An error occurred: ${e.toString()}');
  print(e.toString());
}
