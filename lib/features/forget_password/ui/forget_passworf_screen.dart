

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/app_regex.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/widgets/build_button.dart';
import '../../../core/widgets/build_text_form_field.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});


  @override
  Widget build(BuildContext context) {

    final TextEditingController phoneNumberController =  TextEditingController();
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 35.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsTexts.txtForgetPasswordTitle,
                  style: TextStyles.font20BlueBold,
                ),
                verticalSpace(8),
                Text(
                  StringsTexts.txtForgetPasswordDes,
                  style: TextStyles.font13GrayNormal,
                ),
                verticalSpace(36),

                BuildTextFormField(
                  controller: phoneNumberController,
                  hintText: "Enter a Valid Phone number",
                  validator: (value) {

                  },
                ),

                verticalSpace(100),

                BuildButton(
                  textButton: "Password Reset",
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
