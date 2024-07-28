import 'package:a2z_app/core/widgets/build_toast.dart';
import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/StringsTexts.dart';
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
                StringTextsNames.txtForgetPasswordTitle,
                style: TextStyles.font24BlueBold,
              ),
              verticalSpace(8),
              Text(
                StringTextsNames.txtForgetPasswordDes,
                style: TextStyles.font13GrayNormal,
              ),
              verticalSpace(42),
              BuildTextFormField(
                controller: phoneNumberController,
                hintText: StringTextsNames.txtHintValidPhoneNum,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !AppRegex.isPhoneNumberValid(value)) {
                    return 'Please enter a valid phone number';
                  }
                },
              ),
              verticalSpace(160),
              BuildButton(
                textButton: StringTextsNames.txtPasswordReset,
                textStyle: TextStyles.font16WhiteMedium,
                onPressed: () {
                  final loginOrEmail = phoneNumberController.text;

                  if (loginOrEmail.isNotEmpty) {
                    _passwordResetService.requestPasswordReset(
                        context, loginOrEmail);

                    // Update state with the new data
                    Provider.of<AppStateProvider>(context, listen: false)
                        .setData(loginOrEmail);
                  } else {
                    buildSuccessToast(context, "please enter your valid Data.");
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
