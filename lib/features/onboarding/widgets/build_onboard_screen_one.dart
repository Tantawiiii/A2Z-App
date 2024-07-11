import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/StringsTexts.dart';

class BuildOnboardingScreen1 extends StatelessWidget {
  const BuildOnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(ImagesPaths.imgHeaderOnBoarding1),
        verticalSpace(10.h),
        Lottie.asset(
          ImagesPaths.animBodyOnBoarding1,
          width: 250.w,
          repeat: true,
        ),
        verticalSpace(20.h),
        Padding(
          padding:  EdgeInsets.only(left: 15.h,right: 15.h),
          child: Text(
            StringsTexts.titleOnBoard1,
            style: TextStyles.font28BlueBold,
            textAlign: TextAlign.center,
          ),
        ),
        verticalSpace(10.h),
        Padding(
          padding:  EdgeInsets.only(left: 15.h,right: 15.h),
          child: Text(
            StringsTexts.desOnBoard1,
            style: TextStyles.font13BlueSemiBold,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
