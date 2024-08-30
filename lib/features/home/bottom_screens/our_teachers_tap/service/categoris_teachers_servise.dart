import 'package:graphql_flutter/graphql_flutter.dart';

class CategoriesService {
  final String query = """
    query ChildCategories {
      childCategories(storeId: "A2Z", maxLevel: 3) {
        childCategories {
          name
          childCategories {
            childCategories {
              id
              imgSrc
              name
              level
              parent {
                name
              }
            }
          }
        }
      }
    }
  """;

  Future<List<Map<String, dynamic>>> fetchCategories(
      GraphQLClient client) async {
    final result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    if (result.hasException || result.isLoading) {
      return [];
    }
    final dynamic rootCategories =
        result.data?['childCategories']?['childCategories'] ?? [];
    return _extractCategories(rootCategories);
  }

  List<Map<String, dynamic>> _extractCategories(dynamic rootCategories) {
    final List<Map<String, dynamic>> extractedCategories = [];
    if (rootCategories is List) {
      for (var category in rootCategories) {
        if (category is Map<String, dynamic> &&
            category['childCategories'] is List) {
          for (var subCategory in category['childCategories']) {
            if (subCategory is Map<String, dynamic> &&
                subCategory['childCategories'] is List) {
              extractedCategories.addAll(List<Map<String, dynamic>>.from(
                  subCategory['childCategories']));
            }
          }
        }
      }
    }
    return extractedCategories;
  }
}