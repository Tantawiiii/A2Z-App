import 'dart:async';

import 'package:a2z_app/core/widgets/build_toast.dart';
import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import '../../../../a2z_app.dart';
import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/language/language.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/widgets/build_button.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import '../../services/network/password_reset_service.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController phoneNumberController = TextEditingController();
  final PasswordResetService _passwordResetService = PasswordResetService();
  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // start checker internet connection
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
            default:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
            child: ListView(
              children: [
                Text(
                  Language.instance.txtForgetPasswordTitle(),
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  Language.instance.txtForgetPasswordDes(),
                  style: TextStyles.font13GrayNormal,
                ),
                verticalSpace(42),
                BuildTextFormField(
                  controller: phoneNumberController,
                  hintText: Language.instance.txtHintValidPhoneNum(),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !AppRegex.isPhoneNumberValid(value)) {
                      return Language.instance.txtHintValidPhoneNum;
                    }
                  },
                ),
                verticalSpace(160),
                BuildButton(
                  textButton: Language.instance.txtPasswordReset(),
                  textStyle: TextStyles.font18WhiteSemiBold,
                  onPressed: () {
                    final loginOrEmail = phoneNumberController.text;

                    if (loginOrEmail.isNotEmpty) {
                      _passwordResetService.requestPasswordReset(
                          context, loginOrEmail);

                      // Update state with the new data
                      Provider.of<AppStateProvider>(context, listen: false)
                          .setData(loginOrEmail);
                    } else {
                      buildSuccessToast(context, Language.instance.txtValidData());
                    }
                  },
                )
              ],
            ),
          ),
        ),
      )
      : const NoInternetScreen(),
    );
  }
}
