import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:flutter/material.dart';

import '../../../../../core/networking/clients/base_graphql_servises.dart';
import '../../../../../core/routing/routers.dart';

class ProfileGraphQLService extends BaseGraphQLService {

  ProfileGraphQLService(super.dioClient);

  Future<Map<String, dynamic>?> fetchProfile(BuildContext context) async {
    const String query = r'''
    query Me {
      me {
        email
        userName
        userType
        photoUrl
        phoneNumber
        contact {
            name
            firstName
            lastName
            fullName
            dynamicProperties {
              name
              value
            }
          }
      }
    }
    ''';

    try {
      final result = await performQuery(query);
      return result['me'];
    } catch (e) {
      context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
