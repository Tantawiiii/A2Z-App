import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  final GraphQLClient _client;

  GraphQLService(this._client);

  Future<Map<String, dynamic>> requestRegistration({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String username,
    required String password,
    required String grade,
    required String profilePhoto,
  }) async {
    const String mutation = '''
    mutation RequestRegistration(\$firstName: String!,  \$profilePhoto: String!,\$lastName: String!, \$phoneNumber: String!, \$email: String!, \$username: String!, \$password: String!, \$grade: String!) {
      requestRegistration(
        command: {
          storeId: "A2Z",
          contact: {
            firstName: \$firstName,
            lastName: \$lastName,
            phoneNumber: \$phoneNumber,
            dynamicProperties: [
              {
                name: "grade",
                value: \$grade
              },        
              { 
                name: "ProfilePhoto", 
                value: \$profilePhoto 
                }
            ]
          },
          account: {
            username: \$username,
            email: \$email,
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
        account {
          id
        }
      }
    }
    ''';

    final options = MutationOptions(
      document: gql(mutation),
      variables: {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'username': username,
        'password': password,
        'grade': grade,
        'ProfilePhoto': profilePhoto,
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!;
  }
}
