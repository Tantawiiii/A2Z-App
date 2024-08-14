
import 'package:a2z_app/features/home/widgets/build_empty_courses.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/StringsTexts.dart';

class CoursesTap extends StatelessWidget {
  const CoursesTap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: BuildEmptyCourses(txtNot: StringTextsNames.txtNoCourses,),
    );
  }
}
