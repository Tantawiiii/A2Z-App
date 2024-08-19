
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/networking/local/token_storage.dart';

abstract class BaseGraphQLService {
  final DioClientGraphql dioClient;
  final TokenStorage _tokenStorage = TokenStorage();

  BaseGraphQLService(this.dioClient);

  Future<GraphQLClient> _getGraphQLClient() async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      await _tokenStorage.clearToken();
      // context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
      // buildSuccessToast(context, "Successfully logged out");
      throw Exception('Token not found');
    }

    return dioClient.getGraphQLClient(headers: {
      'Authorization': 'Bearer $token',
    });
  }

  Future<Map<String, dynamic>> performQuery(String query, {Map<String, dynamic>? variables}) async {
    final client = await _getGraphQLClient();

    final options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!;
  }
}
