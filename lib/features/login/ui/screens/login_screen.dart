import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/build_button.dart';
import '../widgets/build_dont_have_acc_text.dart';
import '../widgets/build_email_and_password.dart';
import '../widgets/build_icons_social_media.dart';
import '../widgets/build_sigin_with_media_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // to fix white part top of the Keyboard window opening
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 35.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsTexts.txtWelcomeBack,
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  StringsTexts.txtDescriptionLogin,
                  style: TextStyles.font14GrayNormal,
                ),
                verticalSpace(36),
                Column(
                  children: [
                    const BuildEmailAndPassword(),
                    verticalSpace(24),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        StringsTexts.txtForgetPassword,
                        style: TextStyles.font13BlueNormal,
                      ),
                    ),
                    verticalSpace(40),
                    BuildButton(
                      textButton: StringsTexts.txtLogin,
                      textStyle: TextStyles.font16WhiteMedium,
                      onPressed: () {},
                    ),
                    verticalSpace(46),
                    const BuildOrSignInMediaAccounts(),
                    verticalSpace(46),
                    // TODO: HERE we Build Row media Login Icons
                    const BuildIconsSocialMedia(),
                    verticalSpace(32),
                    const DontHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
