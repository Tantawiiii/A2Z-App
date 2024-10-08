import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/language/language.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
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

  Future<void> login(
      BuildContext context, String username, String password) async {
    final String url = ApiConstants.apiLogin;
    final dio = _dioClient.dio;

 //   print('Login URL: $url');
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
        print("Token saved:");

        // Login successful, navigate to Home screen
        context.pushNamedAndRemoveUntil(Routes.homeScreen,
            predicate: (route) => false);
        print("Token saved: 2");
        buildSuccessToast(context, Language.instance.txtLoggedA2z());
      } else {
        // Show error message
        buildFailedToast(context,Language.instance.txtLoginFailed() );

        if (kDebugMode) {
          print(
              'Login failed: ${response.data['error_description'] ?? 'Unknown error'}');
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        buildFailedToast(context, Language.instance.txtLoginError());

        if (kDebugMode) {
          print(
              'Error response: ${e.response?.statusCode} ${e.response?.statusMessage}');
        }
      } else {
        buildFailedToast(context, Language.instance.txtLoginError());

        if (kDebugMode) {
          print('Error: ${e.message}');
        }
      }
    }
  }
}
