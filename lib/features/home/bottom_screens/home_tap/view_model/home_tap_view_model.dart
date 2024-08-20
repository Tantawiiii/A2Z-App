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
      _categories = await _categoriesService.fetchCategories(grade);
    } catch (e) {
      // Handle exceptions if needed
      throw Exception('Failed to load categories: $e');
    }
  }
}
