import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';

class GetAllCourses extends StatefulWidget {
  const GetAllCourses({super.key});

  @override
  State<GetAllCourses> createState() => _GetAllCoursesState();
}

class _GetAllCoursesState extends State<GetAllCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.w),
        child: ListView(
          children: [
            Text(
              StringTextsNames.txtAllCourses,
              style: TextStyles.font24BlueBold,
            ),
            verticalSpace(8),
          ],
        ),
      ),

    );
  }
}
