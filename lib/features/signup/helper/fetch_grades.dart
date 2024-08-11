// lib/fetch_categories.dart

import 'package:graphql_flutter/graphql_flutter.dart';

Future<List<String>> fetchGrades(GraphQLClient client) async {
  const String fetchGradesQuery = '''
    query ChildCategories {
      childCategories(storeId: "A2Z", maxLevel: 1) {
        childCategories {
          name
        }
      }
    }
  ''';

  final QueryResult result = await client.query(
    QueryOptions(
      document: gql(fetchGradesQuery),
    ),
  );

  if (result.hasException) {
    print(result.exception.toString());
    return [];
  }

  final List<dynamic> categoriesData = result.data?['childCategories']['childCategories'];
  return categoriesData.map((category) => category['name'].toString()).toList();
}
