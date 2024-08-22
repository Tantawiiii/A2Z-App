import 'package:a2z_app/core/networking/const/api_constants.dart';

import '../../../core/networking/clients/dio_client.dart';
import '../widgets/bottom_sheet_subscribe_failed.dart';
import '../widgets/bottom_sheet_subscribe_success.dart';

class SubscriptionService {
  final DioClient dioClient;

  SubscriptionService(this.dioClient);

  Future<Object> subscribeByCode(String courseId, String code) async {
    try {

      // Set the authorization token
      await dioClient.setAuthorizationToken();

      final response = await dioClient.dio.post(
        ApiConstants.apiSubscriptionByCode,
        data: {
          'courseId': courseId,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        const BottomSheetSubscribeSuccess();
        return true;

      } else {
        const BottomSheetSubscribeFailed();

        return false;
      }
    } catch (e) {
      print('Subscription failed: $e');
      const BottomSheetSubscribeFailed();
      return false;
    }
  }
}
