import 'package:a2z_app/core/networking/api_constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClientInstance {


  static late GraphQLClient client;

  static void initializeClient() {
    final HttpLink httpLink = HttpLink(
      ApiConstants.apiBaseUrlGraphQl, // Your GraphQL endpoint
    );

    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }
}