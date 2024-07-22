

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/StringsTexts.dart';
import '../../../../core/widgets/build_button.dart';
import '../widgets/build_otp_form.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
          child: ListView(
            children: [
              Text(
                StringsTexts.txtVerifyOtp,
                style: TextStyles.font24BlueBold,
              ),
              verticalSpace(8),
              Text(
                StringsTexts.txtVerifyOtpDes,
                style: TextStyles.font13GrayNormal,
              ),
              verticalSpace(42),
              const BuildOtpForm(),
              verticalSpace(160),
              BuildButton(
                textButton: StringsTexts.txtConfirmBtn,
                textStyle: TextStyles.font16WhiteMedium,
                onPressed: () {

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
