import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion/motion.dart';

import '../utils/colors_code.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonWidth,
    this.buttonHeight,
    required this.textButton,
    required this.textStyle,
    required this.onPressed,
  });

  final double? borderRadius;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String textButton;
  final TextStyle textStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      child: Motion(
        child: TextButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              backgroundColor ?? ColorsCode.mainBlue,
            ),
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(
                horizontal: horizontalPadding?.w ?? 12.w,
                vertical: verticalPadding?.h ?? 14.h,
              ),
            ),
            fixedSize: WidgetStateProperty.all(
              Size(
                buttonWidth?.w ?? double.maxFinite,
                buttonHeight ?? 50.h,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            textButton,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
