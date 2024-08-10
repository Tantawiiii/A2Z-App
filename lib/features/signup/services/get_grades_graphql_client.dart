
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient getGraphQLClient() {
  final HttpLink httpLink = HttpLink('http://edu.a2zplatform.com/graphql');

  return GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );
}
