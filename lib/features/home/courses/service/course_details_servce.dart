

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/networking/clients/get_grades_graphql_client.dart';


class CourseDetailsService {
  static const String _courseDetailQuery = r'''
    query Product($id: String!) {
      product(id: $id, storeId: "A2Z") {
        id
        name
        imgSrc
        videos {
          totalCount
          items {
            name
            description
            uploadDate
            thumbnailUrl
            contentUrl
          }
        }
        images {
          name
          url
        }
        descriptions {
          content
          languageCode
        }
        properties {
          name
          value
        }
        assets {
          name
          url
        }
        associations {
          items {
            product {
              id
              name
              imgSrc
            }
          }
        }
      }
    }
  ''';

  Future<Map<String, dynamic>> fetchCourseDetail(String id) async {
    try {
      final QueryResult result = await GraphQLClientInstance.client.query(
        QueryOptions(
          document: gql(_courseDetailQuery),
          variables: {'id': id},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      } else {
        return result.data?['product'] ?? {};
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
