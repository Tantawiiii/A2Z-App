// screens/get_all_courses_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/StringsTexts.dart';
import '../service/course_service.dart';
import '../widgets/course_list.dart';
import '../widgets/shimmer_loading.dart';

class GetAllCoursesScreen extends StatefulWidget {
  const GetAllCoursesScreen({super.key});

  @override
  State<GetAllCoursesScreen> createState() => _GetAllCoursesScreenState();
}

class _GetAllCoursesScreenState extends State<GetAllCoursesScreen> {
  final CourseService _courseService = CourseService();
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final fetchedCourses = await _courseService.fetchCourses();
      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 40.w),
        child: ListView(
          children: [
            Text(
              StringTextsNames.txtAllCourses,
              style: TextStyles.font20BlueBold,
            ),
            verticalSpace(40),
            if (isLoading)
              const ShimmerLoading()
            else
              CourseList(courses: courses),
          ],
        ),
      ),
    );
  }
}
