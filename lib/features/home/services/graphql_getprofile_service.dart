import 'package:dio/dio.dart';
import '../../../core/networking/clients/dio_client.dart';
import '../../../core/networking/local/token_storage.dart';

class GetProfileGraphQLService {
  final Dio dio;
  final TokenStorage _tokenStorage = TokenStorage();

  GetProfileGraphQLService(DioClient dioClient) : dio = dioClient.dio;

  Future<Map<String, dynamic>?> fetchProfile() async {
    const String fetchProfileQuery = """
      query Me {
        me {
          email
          userName
          userType
          photoUrl
        }
      }
    """;

    final token = await _tokenStorage.getToken();

    final options = Options(
      headers: {
        if (token != null) 'x-auth-token': token,
      },
    );

    final response = await dio.post(
      '/',
      data: {'query': fetchProfileQuery},
      options: options,
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
