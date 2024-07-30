import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routers.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringTextsNames.txtWelcomeBack,
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  StringTextsNames.txtDescriptionLogin,
                  style: TextStyles.font14GrayNormal,
                ),
                verticalSpace(36),
                Column(
                  children: [
                    const BuildEmailAndPassword(),
                    verticalSpace(24),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        child: Text(
                          StringTextsNames.txtForgetPassword,
                          style: TextStyles.font13BlueNormal),
                          onTap: () {
                              context.pushNamed(Routes.forgetPasswordScreen);
                            },
                      ),
                    ),
                    verticalSpace(40),
                    BuildButton(
                      textButton: StringTextsNames.txtLogin,
                      textStyle: TextStyles.font16WhiteMedium,
                      onPressed: () {
                        context.pushNamed(Routes.homeScreen);
                      },
                    ),
                    verticalSpace(46),
                    const BuildOrSignInMediaAccounts(),
                    verticalSpace(46),
                    const BuildIconsSocialMedia(),
                    verticalSpace(32),
                    const DontHaveAccountText(),
                    verticalSpace(50),
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
