// widgets/course_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/text_style.dart';
import '../ui/course_details_screen.dart';

class CourseList extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  const CourseList({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: courses.map((course) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(courseId: course['id']),
              ),
            );
          },
          child: Container(
            height: 160.h,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.shade200,
                  Colors.lightBlueAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                course['imgSrc'] != null
                    ? Image.network(
                  course['imgSrc'],
                  width: 140.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 90.w);
                  },
                )
                    : Icon(Icons.image_not_supported, size: 90.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    course['name'] ?? 'Unnamed Course',
                    style: TextStyles.font15DarkBlueMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
