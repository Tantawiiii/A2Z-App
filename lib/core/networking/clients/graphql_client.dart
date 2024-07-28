import 'package:dio/dio.dart';

class GraphQLClient {
  final Dio _dio;

  GraphQLClient({Dio? dio})
      : _dio = dio ??
      Dio(BaseOptions(
        baseUrl: 'http://a2zplatform.com/graphql',
        headers: {
          'Content-Type': 'application/json',
        },
      ));

  Dio get dio => _dio;
}
