import 'package:graphql_flutter/graphql_flutter.dart';

class CategoriesService {
  final String query = """
  query Categories(\$grade: String!) {
    categories(query: \$grade, storeId: "A2Z") {
      totalCount
      items {
        childCategories {
          childCategories {
            id
            imgSrc
            code
            name
          }
          name
        }
      }
    }
  }
  """;

  Future<List<Map<String, dynamic>>> fetchCategories(
      GraphQLClient client, String grade) async {
    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {
          'grade': grade,
        },
      ),
    );
    if (result.hasException || result.isLoading) {
      return [];
    }
    final dynamic categories =
        result.data?['categories']?['items'] ?? [];
    return _extractCategories(categories);
  }

  List<Map<String, dynamic>> _extractCategories(dynamic categories) {
    final List<Map<String, dynamic>> extractedCategories = [];
    if (categories is List) {
      for (var category in categories) {
        if (category is Map<String, dynamic> &&
            category['childCategories'] is List) {
          for (var subCategory in category['childCategories']) {
            if (subCategory is Map<String, dynamic> &&
                subCategory['childCategories'] is List) {
              for (var childCategory in subCategory['childCategories']) {
                if (childCategory is Map<String, dynamic>) {
                  extractedCategories.add({
                    'id': childCategory['id'],
                    'imgSrc': childCategory['imgSrc'],
                    'name': childCategory['name'],
                    'parentName': subCategory['name'],  // Store the parent name
                  });
                }
              }
            }
          }
        }
      }
    }
    return extractedCategories;
  }
}
