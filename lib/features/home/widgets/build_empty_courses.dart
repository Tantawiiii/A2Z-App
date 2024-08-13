import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/routing/routers.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/utils/images_paths.dart';

class BuildEmptyCourses extends StatelessWidget {
  const BuildEmptyCourses({super.key});

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
            StringTextsNames.txtNoCourses,
            style: TextStyles.font15DarkBlueMedium,
          ),
          verticalSpace(8.h),

          Bounce(
            onTap: () {
              context.pushNamed(Routes.getAllCoursesScreen);
            },
            child:  Text(
              StringTextsNames.txtSubNow,
              style:TextStyles.font13BlueSemiBold,
            ),
          ),

        ],
      ),
    );
  }
}

