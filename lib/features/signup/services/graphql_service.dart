import 'package:dio/dio.dart';

class GraphQLService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://a2zplatform.com/graphql',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> requestRegistration({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String username,
    required String password,
    required String grade,
  }) async {
    const String query = '''
    mutation RequestRegistration(\$firstName: String!, \$lastName: String!, \$phoneNumber: String!, \$email: String!, \$username: String!, \$password: String!, \$grade: String!) {
      requestRegistration(
        command: {
          storeId: "A2Z"
          contact: {
            firstName: \$firstName
            lastName: \$lastName
            phoneNumber: \$phoneNumber
            dynamicProperties: [
              {
                name: "grade",
                value: \$grade
              }
            ]
          }
          account: {
            email: \$email
            username: \$username
            password: \$password
          }
        }
      ) {
        result {
          succeeded
          requireEmailVerification
          oTP
          errors {
            code
            description
            parameter
          }
        }
      }
    }
    ''';

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

    return response.data;
  }
}
