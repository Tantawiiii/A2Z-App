import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/networking/local/token_storage.dart';



class GetProfileGraphQLService {
  final DioClientGraphql dioClient;

  GetProfileGraphQLService(this.dioClient);


  // Initialize TokenStorage
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, dynamic>?> fetchProfile(BuildContext context) async {
    final token =await _tokenStorage.getToken();
    if (token == null) {

      context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate:  (route) => false);
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
