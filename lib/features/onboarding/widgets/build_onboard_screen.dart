import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildOnboardingScreen extends StatelessWidget {
  const BuildOnboardingScreen(
      {super.key,

      required this.svgBodyPath,
      required this.titleBoard,
      required this.desBoard});

  final String svgBodyPath, titleBoard, desBoard;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Image.asset(imageHeaderPath),
        //verticalSpace(10.h),
        SvgPicture.asset(
          svgBodyPath,
          width: 280.w,
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
