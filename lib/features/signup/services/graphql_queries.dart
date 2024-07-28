class GraphQLQueries {
  static const String requestRegistration = '''
  mutation RequestRegistration {
    requestRegistration(
      command: {
        storeId: "A2Z"
        contact: {
          firstName: "\$firstName"
          lastName: "\$lastName"
          phoneNumber: "\$phoneNumber"
          dynamicProperties: [
            {
              name: "grade",
              value: "\$grade"
            }
          ]
        }
        account: {
          email: "\$email"
          username: "\$username"
          password: "\$password"
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
}
