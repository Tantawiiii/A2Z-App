import 'package:graphql_flutter/graphql_flutter.dart';

Future<List<String>> fetchCategories(GraphQLClient client) async {
  final String fetchCategoriesQuery = '''
    query ChildCategories(\$storeId: String!, \$maxLevel: Int!) {
      childCategories(storeId: \$storeId, maxLevel: \$maxLevel) {
        childCategories {
          name
        }
      }
    }
  ''';

  final QueryResult result = await client.query(
    QueryOptions(
      document: gql(fetchCategoriesQuery),
      variables: {
        'storeId': "A2Z",
        'maxLevel': 1,
      },
    ),
  );

  if (result.hasException) {
    print(result.exception.toString());
    return [];
  }

  final List<dynamic> categoriesData = result.data?['childCategories']['childCategories'];
  return categoriesData.map((category) => category['name'].toString()).toList();
}
