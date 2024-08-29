import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../core/networking/local/token_storage.dart';

class SubscriptionService {
  final Dio dio;

  SubscriptionService(this.dio);

  Future<void> subscribeByCode(String courseId, String code) async {

    String? token = await TokenStorage().getToken();
    try {
      final response = await dio.post(
        'http://centera2z.com/api/Subscriptions/SubscripeByCode',
        data: {
          'courseId': courseId,
          'code': code,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['success']) {
        // Handle successful subscription
      } else {
        // Handle subscription failure
        print(response.data);
        throw Exception(response.data['errorMessage']);
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print(e.toString());
      rethrow;
    }
  }
}
