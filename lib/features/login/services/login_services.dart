import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/networking/api_constants.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../core/networking/clients/dio_client.dart';
import '../../../core/networking/local/token_storage.dart';
import '../../../core/widgets/build_toast.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  // Initialize TokenStorage
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> login(BuildContext context, String username, String password) async {
    final String url = ApiConstants.apiLogin;
    final dio = _dioClient.createDio();
    try {
      final response = await dio.post(
        url,
        data: {
          'grant_type': 'password',
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
          },
        ),
      );

      if (response.data.containsKey('access_token')) {
        // Save the token using TokenStorage
        await _tokenStorage.saveToken(response.data['access_token']);

        // Login successful, navigate to Home screen
        context.pushNamedAndRemoveUntil(Routes.homeScreen, predicate: (route) => false);
        buildSuccessToast(context, "Successfully logged in A2Z");
      } else {
        // Show error message
        buildFailedToast(context, 'Login failed');

        if (kDebugMode) {
          print('Login failed: ${response.data['error_description'] ?? 'Unknown error'}');
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        buildFailedToast(context,
            'Error response: ${e.response?.statusCode} ${e.response?.statusMessage}');

        if (kDebugMode) {
          print('Error response: ${e.response?.statusCode} ${e.response?.statusMessage}');
        }
      } else {
        buildFailedToast(context, 'Error: ${e.message}');

        if (kDebugMode) {
          print('Error: ${e.message}');
        }
      }
    }
  }
}
