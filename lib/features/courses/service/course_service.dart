
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/networking/clients/get_grades_graphql_client.dart';

class CourseService {
  static const String _query = r'''
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

  Future<List<Map<String, dynamic>>> fetchCourses() async {
    try {
      final QueryResult result = await GraphQLClientInstance.client.query(
        QueryOptions(document: gql(_query)),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      } else {
        final List<dynamic> items = result.data?['products']['items'] ?? [];
        return items.map((item) => {
          'id': item['id'],
          'name': item['name'],
          'imgSrc': item['imgSrc'],
        }).toList();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
