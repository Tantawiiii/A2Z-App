


import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:flutter/material.dart';

import '../../../../../core/networking/local/token_storage.dart';
import '../../../../../core/routing/routers.dart';
import '../../../../../core/widgets/build_toast.dart';


class LogOutServices {

  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> logout(BuildContext context) async {
    await _tokenStorage.clearToken();
    context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
    buildSuccessToast(context, "Successfully logged out");
  }


}
