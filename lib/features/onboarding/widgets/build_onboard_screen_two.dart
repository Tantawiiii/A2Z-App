import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/utils/images_paths.dart';

class BuildOnboardingScreen2 extends StatelessWidget {
  const BuildOnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(ImagesPaths.imgHeaderOnBoarding2),
        verticalSpace(10.h),
        Lottie.asset(
          ImagesPaths.animBodyOnBoarding2,
          width: 300.w,
          repeat: true,
        ),
        verticalSpace(40.h),
        Padding(
          padding:  EdgeInsets.only(left: 15.h,right: 15.h),
          child: Text(
            StringsTexts.titleOnBoard2,
            style: TextStyles.font28BlueBold,
            textAlign: TextAlign.center,
          ),
        ),
        verticalSpace(10.h),
        Padding(
          padding:  EdgeInsets.only(left: 15.h,right: 15.h),
          child: Text(
            StringsTexts.desOnBoard2,
            style: TextStyles.font13BlueSemiBold,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
