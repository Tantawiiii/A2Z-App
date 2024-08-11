import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/networking/clients/dio_client_graphql.dart';

class GetProfileGraphQLService {
  final DioClientGraphql dioClient;
  final String _accessTokenKey = 'accessToken'; // Make sure this matches your stored key

  GetProfileGraphQLService(this.dioClient);

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    print('Retrieved token: $token'); // Debug print
    return token;
  }

  Future<Map<String, dynamic>?> fetchProfile() async {
    final token = await getToken();
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
