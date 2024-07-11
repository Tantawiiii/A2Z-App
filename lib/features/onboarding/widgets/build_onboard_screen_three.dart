import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/utils/images_paths.dart';

class BuildOnboardingScreen3 extends StatelessWidget {
  const BuildOnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(ImagesPaths.imgHeaderOnBoarding3),
        Lottie.asset(
          'asset/anim/Animation.json',
          width: 250.w,
          repeat: true,
        ),
        verticalSpace(24.h),
        Padding(
          padding:  EdgeInsets.only(left: 30.h,right: 30.h),
          child: Text(
            StringsTexts.titleOnBoard3,
            style: TextStyles.font24BlueBold,
            textAlign: TextAlign.center,
          ),
        ),
        verticalSpace(16.h),
        Padding(
          padding:  EdgeInsets.only(left: 15.h,right: 15.h),
          child: Text(
            StringsTexts.desOnBoard3,
            style: TextStyles.font13BlueSemiBold,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
