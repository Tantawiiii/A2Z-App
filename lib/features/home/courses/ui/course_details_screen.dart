import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:a2z_app/features/home/courses/service/course_details_servce.dart';
import '../../../../core/theming/text_style.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CourseDetailsService _courseService = CourseDetailsService();
  Map<String, dynamic>? courseDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetail();
  }

  Future<void> _fetchCourseDetail() async {
    try {
      final fetchedDetail = await _courseService.fetchCourseDetail(widget.courseId);
      setState(() {
        courseDetail = fetchedDetail;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: List.generate(10, (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Container(
            color: Colors.white,
            height: 200.h,
            width: double.infinity,
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseDetail?['name'] ?? 'Course Detail'),
      ),
      body: isLoading
          ? _buildShimmerEffect()
          : Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            if (courseDetail?['imgSrc'] != null)
              Image.network(
                courseDetail!['imgSrc'],
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.h),
            // Videos
            if (courseDetail?['videos'] != null && courseDetail!['videos']['totalCount'] > 0)
              ...courseDetail!['videos']['items'].map<Widget>((video) {
                String videoUrl = video['contentUrl'];
                String videoId = extractYouTubeVideoId(videoUrl);
                String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

                return ListTile(
                  leading: video['contentUrl'] != null
                      ? SizedBox(
                    width: 100.w,
                    height: 200.h,
                    child: Image.network(
                      courseDetail!['imgSrc'],
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.video_library),
                  title: Text(video['name'] ?? 'Unnamed Video'),
                  subtitle: Text(video['description'] ?? ''),
                );
              }).toList(),

            SizedBox(height: 16.h),

            // Images
            if (courseDetail?['images'] != null)
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: courseDetail!['images'].map<Widget>((image) {
                  return Image.network(
                    image['url'],
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),

            SizedBox(height: 16.h),

            // Descriptions
            if (courseDetail?['descriptions'] != null)
              ...courseDetail!['descriptions'].map<Widget>((description) {
                return Text(
                  description['content'] ?? '',
                  style: TextStyles.font15DarkBlueMedium,
                );
              }).toList(),

            SizedBox(height: 16.h),

            // Properties
            if (courseDetail?['properties'] != null)
              ...courseDetail!['properties'].map<Widget>((property) {
                return ListTile(
                  title: Text(property['name'] ?? ''),
                  subtitle: Text(property['value'] ?? ''),
                );
              }).toList(),

            SizedBox(height: 16.h),


            SizedBox(height: 16.h),

            // Associations
            if (courseDetail?['associations'] != null)
              ...courseDetail!['associations']['items'].map<Widget>((association) {
                return ListTile(
                  leading: association['product']['imgSrc'] != null
                      ? Image.network(
                    association['product']['imgSrc'],
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.image_not_supported),
                  title: Text(association['product']['name'] ?? 'Unnamed Product'),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  String extractYouTubeVideoId(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['v'] ?? '';
  }
}
