import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BuildOnboardingScreen extends StatelessWidget {
  const BuildOnboardingScreen(
      {super.key,
      required this.imageHeaderPath,
      required this.lottiePath,
      required this.titleBoard,
      required this.desBoard});

  final String imageHeaderPath, lottiePath, titleBoard, desBoard;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Image.asset(imageHeaderPath),
        //verticalSpace(10.h),
        Lottie.asset(
          lottiePath,
          width: 300.w,
          repeat: true,
        ),
        verticalSpace(40.h),
        Text(
          titleBoard,
          style: TextStyles.font24BlueBold,
          textAlign: TextAlign.center,
        ),
        verticalSpace(20.h),
        Text(
          desBoard,
          style: TextStyles.font13GrayNormal,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
