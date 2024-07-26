import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/StringsTexts.dart';
import '../../../../core/widgets/build_button.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import '../../services/password_reset_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
          child: ListView(
            children: [
              Text(
                StringsTexts.txtForgetPasswordTitle,
                style: TextStyles.font24BlueBold,
              ),
              verticalSpace(8),
              Text(
                StringsTexts.txtForgetPasswordDes,
                style: TextStyles.font13GrayNormal,
              ),
              verticalSpace(42),
              BuildTextFormField(
                controller: phoneNumberController,
                hintText: StringsTexts.txtHintValidPhoneNum,
                validator: (value) {},
              ),
              verticalSpace(160),
              BuildButton(
                textButton: StringsTexts.txtPasswordReset,
                textStyle: TextStyles.font16WhiteMedium,
                onPressed: () {
                  final loginOrEmail = phoneNumberController.text;

                  if (loginOrEmail.isNotEmpty) {
                    _passwordResetService.requestPasswordReset(
                        context, loginOrEmail);
                  } else {
                    ToastService.showToast(
                      context,
                      isClosable: true,
                      backgroundColor: ColorsCode.lighterGray,
                      length: ToastLength.short,
                      expandedHeight: 80,
                      message: "please enter your valid Data.",
                      messageStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      slideCurve: Curves.elasticInOut,
                      positionCurve: Curves.bounceOut,
                      dismissDirection: DismissDirection.none,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
