import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/forget_password/services/network/change_password_by_otp.dart';
import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../a2z_app.dart';
import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/font_weight_helper.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/language/language.dart';
import '../../../../core/theming/text_style.dart';
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

    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
            child: ListView(
              children: [
                Text(
                  Language.instance.txtVerifyOtp(),
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  Language.instance.txtVerifyOtpDes(),
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
                      return Language.instance.txtValidPhoneNumber;
                    }
                  },
                ),
                verticalSpace(8),
                BuildTextFormField(
                  controller: otpController,
                  hintText: Language.instance.txtOtpEnterData(),
                  validator: (value) {
                    if (value!.isEmpty && value == "null") {
                      return Language.instance.txtEnterOTPCode;
                    }
                  },
                ),
                verticalSpace(8),
                BuildTextFormField(
                  controller: newPasswordController,
                  hintText: Language.instance.txtNewPassword(),
                  validator: (value) {
                    if (value!.isEmpty && value == "null") {
                      return Language.instance.txtEnterNewPass;
                    }
                  },
                ),
                verticalSpace(160),
                BuildButton(
                  textButton: Language.instance.txtConfirmBtn(),
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
      ),
    );
  }



}
