import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/forget_password/services/network/change_password_by_otp.dart';
import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/font_weight_helper.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/StringsTexts.dart';
import '../../../../core/widgets/build_button.dart';
import '../../../../core/widgets/build_text_form_field.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController otpController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    String phoneNum = Provider.of<AppStateProvider>(context).phoneNumber;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
          child: ListView(
            children: [
              Text(
                StringTextsNames.txtVerifyOtp,
                style: TextStyles.font24BlueBold,
              ),
              verticalSpace(8),
              Text(
                StringTextsNames.txtVerifyOtpDes,
                style: TextStyles.font13GrayNormal,
              ),
              verticalSpace(42),
              BuildTextFormField(
                controller: phoneNumberController,
                hintText: phoneNum,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeightHelper.medium,
                  color: ColorsCode.darkBlue,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !AppRegex.isPhoneNumberValid(value)) {
                    return 'Please enter a valid phone number';
                  }
                },
              ),
              verticalSpace(8),
              BuildTextFormField(
                controller: otpController,
                hintText: StringTextsNames.txtOtpEnterData,
                validator: (value) {
                  if (value!.isEmpty && value == "null") {
                    return "Please enter a OTP Code";
                  }
                },
              ),
              verticalSpace(8),
              BuildTextFormField(
                controller: newPasswordController,
                hintText: StringTextsNames.txtNewPassword,
                validator: (value) {
                  if (value!.isEmpty && value == "null") {
                    return "Please enter a new password";
                  }
                },
              ),
              verticalSpace(160),
              BuildButton(
                textButton: StringTextsNames.txtConfirmBtn,
                textStyle: TextStyles.font16WhiteMedium,
                onPressed: () {
                  changePasswordByOTP(
                    context,
                    phoneNum,
                    otpController.text,
                    newPasswordController.text,
                  );


                },
              ),
            ],
          ),
        ),
      ),
    );
  }



}
