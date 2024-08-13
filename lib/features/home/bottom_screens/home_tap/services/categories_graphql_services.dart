import '../../../../../core/networking/clients/base_graphql_servises.dart';

class CategoriesGraphQLService extends BaseGraphQLService {
  CategoriesGraphQLService(super.dioClient);

  Future<List<Map<String, dynamic>>?> fetchCategories(String grade) async {
    const String query = r'''
    query Categories($grade: String!) {
      categories(query: $grade, storeId: "A2Z") {
        totalCount
        items {
          imgSrc
          childCategories {
            imgSrc
            name
          }
        }
      }
    }
    ''';

    try {
      final result = await performQuery(query, variables: {'grade': grade});
      return (result['categories']['items'] as List?)
          ?.map((item) => {
        'imgSrc': item['imgSrc'],
        'name': item['childCategories'] != null && item['childCategories'].isNotEmpty
            ? item['childCategories'][0]['name']
            : '',
      })
          ?.toList();


    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
