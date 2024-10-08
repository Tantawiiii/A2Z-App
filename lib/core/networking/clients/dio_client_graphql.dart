import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DioClientGraphql {
  final Dio _dio = Dio();

  DioClientGraphql() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.apiBaseUrlGraphQl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  GraphQLClient getGraphQLClient({Map<String, String>? headers}) {
    final HttpLink httpLink = HttpLink(
      ApiConstants.apiBaseUrlGraphQl,
      defaultHeaders: headers ?? {},
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
