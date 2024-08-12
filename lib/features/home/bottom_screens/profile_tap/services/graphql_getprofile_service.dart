import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/networking/local/token_storage.dart';



class GetProfileGraphQLService {
  final DioClientGraphql dioClient;

  GetProfileGraphQLService(this.dioClient);


  // Initialize TokenStorage
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, dynamic>?> fetchProfile() async {
    final token =await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final client = dioClient.getGraphQLClient(headers: {
      'Authorization': 'Bearer $token',
    });

    const String query = r'''
    query Me {
      me {
        email
        userName
        userType
        photoUrl
        phoneNumber
      }
    }
    ''';

    final options = QueryOptions(
      document: gql(query),
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data;
  }
}
