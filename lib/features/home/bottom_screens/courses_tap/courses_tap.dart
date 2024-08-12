import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesTap extends StatelessWidget {
  const CoursesTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
      ),
    );
  }
}
