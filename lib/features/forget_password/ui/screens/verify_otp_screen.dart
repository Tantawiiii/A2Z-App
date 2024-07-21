

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
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsTexts.txtVerifyOtp,
                  style: TextStyles.font20BlueBold,
                ),
                verticalSpace(8),
                Text(
                  StringsTexts.txtVerifyOtpDes,
                  style: TextStyles.font13GrayNormal,
                ),
                verticalSpace(36),
                const BuildOtpForm(),
                verticalSpace(100),

                BuildButton(
                  textButton: "Confirm",
                  textStyle: TextStyles.font16WhiteMedium,
                  onPressed: () {

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
