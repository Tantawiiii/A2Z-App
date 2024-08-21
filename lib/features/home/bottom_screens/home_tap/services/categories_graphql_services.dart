import '../../../../../core/networking/clients/base_graphql_servises.dart';

class CategoriesGraphQLService extends BaseGraphQLService {

  CategoriesGraphQLService(super.dioClient);

  Future<List<Map<String, dynamic>>?> fetchCategories(String grade) async {
    const String query = r'''
    query Categories($grade: String!) {
      categories(query: $grade, storeId: "A2Z") {
        totalCount
        items {
          childCategories {
            imgSrc
            name
            id
            level
          }
        }
      }
    }
    ''';

    try {
      final result = await performQuery(query, variables: {'grade': grade});

      // Flattening childCategories list from items
      final categories = (result['categories']['items'] as List?)
          ?.expand((item) => item['childCategories'] as List)
          .map((childCategory) => {
        'imgSrc': childCategory['imgSrc'] ?? '',
        'name': childCategory['name'] ?? '',
        'id': childCategory['id'] ?? '',
        'level': childCategory['level'] ?? '',
      })
          .toList();

      return categories;
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
