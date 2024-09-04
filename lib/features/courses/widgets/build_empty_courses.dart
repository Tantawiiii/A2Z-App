import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/images_paths.dart';

class BuildEmptyCourses extends StatelessWidget {
  const BuildEmptyCourses({super.key, required this.txtNot});

  final String txtNot;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagesPaths.imgEmptyCourses,
            width: 280.w,
          ),
          verticalSpace(20.h),
          Text(
            txtNot,
            style: TextStyles.font15DarkBlueMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

