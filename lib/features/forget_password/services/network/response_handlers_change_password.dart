import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:flutter/material.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';

import '../../ui/widgets/modal_bottom_sheet.dart';

void handlePasswordChangeResponse(
    BuildContext context, int statusCode, String? statusMessage) {
  if (statusCode == 200) {
    _showBottomSheet(context);
  } else {
    buildFailedToast(context, 'Failed to change password: $statusMessage');
  }
}

void _showBottomSheet(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const BottomSheetDialog();
    },
  );

  // This code executes after the bottom sheet is dismissed
  // a delay before navigating to the LoginScreen
   Future.delayed(const Duration(milliseconds: 3500),(){
     context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate:  (route) => false);

   });
}
