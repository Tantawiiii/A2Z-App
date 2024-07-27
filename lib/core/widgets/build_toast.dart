import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../utils/colors_code.dart';

void buildSuccessToast(BuildContext context, String message) {

  ToastService.showToast(
    context,
    isClosable: true,
    backgroundColor: ColorsCode.lighterGray,
    length: ToastLength.medium,
    expandedHeight: 80,
    message: message,
    messageStyle: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    slideCurve: Curves.elasticInOut,
    positionCurve: Curves.bounceOut,
    dismissDirection: DismissDirection.none,
  );
}

void buildFailedToast(BuildContext context, String message) {

  ToastService.showToast(
    context,
   // isClosable: true,
    backgroundColor: ColorsCode.fillRed,
    length: ToastLength.short,
    expandedHeight: 80,
    message: message,
    messageStyle: const TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),

    slideCurve: Curves.elasticInOut,
    positionCurve: Curves.bounceOut,
    dismissDirection: DismissDirection.none,
  );
}


