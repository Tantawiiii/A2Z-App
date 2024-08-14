import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/networking/clients/get_grades_graphql_client.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';

class GetAllCourses extends StatefulWidget {
  const GetAllCourses({super.key});

  @override
  State<GetAllCourses> createState() => _GetAllCoursesState();
}

class _GetAllCoursesState extends State<GetAllCourses> {
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    const String query = r'''
    query Products {
      products(storeId: "A2Z") {
        items {
          id
          name
          imgSrc
        }
      }
    }
    ''';

    try {
      final QueryResult result = await GraphQLClientInstance.client.query(
        QueryOptions(document: gql(query)),
      );

      if (result.hasException) {
        print(result.exception.toString());
      } else {
        final List<dynamic> items = result.data?['products']['items'] ?? [];
        setState(() {
          courses = items.map((item) => {
            'id': item['id'],
            'name': item['name'],
            'imgSrc': item['imgSrc'],
          }).toList();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.w),
        child: ListView(
          children: [
            Text(
              StringTextsNames.txtAllCourses,
              style: TextStyles.font20BlueBold,
            ),
            verticalSpace(8),
            ...courses.map((course) => ListTile(
              title: Text(course['name']),
              leading: course['imgSrc'] != null
                  ? Image.network(course['imgSrc'])
                  : Icon(Icons.image_not_supported),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
