import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../services/categories_graphql_services.dart';

class HomeTapViewModel {
  final CategoriesGraphQLService _categoriesService;

  HomeTapViewModel()
      : _categoriesService = CategoriesGraphQLService(DioClientGraphql());

  List<Map<String, dynamic>>? _categories;
  List<Map<String, dynamic>>? get categories => _categories;

  set categories(List<Map<String, dynamic>>? categories) {
    _categories = categories;
  }

  Future<void> fetchCategoriesByGrade(String grade) async {
    try {
      final fetchedCategories = await _categoriesService.fetchCategories(grade);
      categories = fetchedCategories ?? [];
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
