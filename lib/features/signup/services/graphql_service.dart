import 'package:dio/dio.dart';
import '../../../../core/networking/clients/graphql_client.dart';
import 'graphql_queries.dart';

class GraphQLService {
  final Dio _dio;

  GraphQLService({GraphQLClient? client})
      : _dio = (client ?? GraphQLClient()).dio;

  Future<Map<String, dynamic>> requestRegistration({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String username,
    required String password,
    required String grade,
  }) async {
    const String query = GraphQLQueries.requestRegistration;

    final response = await _dio.post('', data: {
      'query': query,
      'variables': {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'username': username,
        'password': password,
        'grade': grade,
      },
    });

    print("Rejester: ${response.data}");
    return response.data;
  }
}
