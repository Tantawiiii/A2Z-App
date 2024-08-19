
import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../profile_tap/services/graphql_getprofile_service.dart';

class HomeTapViewModel {
  final ProfileGraphQLService _graphQLService;
  HomeTapViewModel()
      : _graphQLService = ProfileGraphQLService(DioClientGraphql());

  List<Map<String, dynamic>>? _categories;
  List<Map<String, dynamic>>? get categories => _categories;

  set categories(List<Map<String, dynamic>>? categories) {
    _categories = categories;
  }


}
