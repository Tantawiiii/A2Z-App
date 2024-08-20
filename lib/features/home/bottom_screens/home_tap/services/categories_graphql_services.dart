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
      return (result['categories']['items'] as List?)
          ?.map((item) => {
        'imgSrc': item['childCategories']?[0]['imgSrc'] ?? '',
        'name': item['childCategories']?[0]['name'] ?? '',
        'id': item['childCategories']?[0]['id'] ?? '',
        'level': item['childCategories']?[0]['level'] ?? '',
      })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
