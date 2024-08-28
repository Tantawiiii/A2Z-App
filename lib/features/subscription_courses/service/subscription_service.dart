import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:dio/dio.dart';

class SubscriptionService {
  final Dio dio;

  SubscriptionService(this.dio);

  Future<void> subscribeByCode(String courseId, String code, String token) async {
    try {
      final response = await dio.post(
        ApiConstants.apiSubscriptionByCode,
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
        throw Exception(response.data['errorMessage']);
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      rethrow;
    }
  }
}
