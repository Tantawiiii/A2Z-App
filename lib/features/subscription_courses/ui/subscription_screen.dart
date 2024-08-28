import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/networking/local/token_storage.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/widgets/build_button.dart';
import '../../../core/widgets/build_text_form_field.dart';
import '../service/subscription_service.dart';
import '../widgets/bottom_sheet_subscribe_failed.dart';
import '../widgets/bottom_sheet_subscribe_success.dart';


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key, required this.courseId});

  final String courseId;

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionService subscriptionService =
  SubscriptionService(Dio()); // Use Dio directly

  final TextEditingController codeController = TextEditingController();

  void _subscribe() async {
    String code = codeController.text;

    try {
      String? token = await TokenStorage().getToken();
      if (token != null) {
        // Pass the token to the subscription service
        await subscriptionService.subscribeByCode(widget.courseId, code, token);
        // Show success bottom sheet
        showModalBottomSheet(
          context: context,
          builder: (context) => const BottomSheetSubscribeSuccess(),
        );
      } else {
        // Handle case when token is null
        throw Exception('No token found. Please log in again.');
      }
    } catch (e) {
      // Show error bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (context) => const BottomSheetSubscribeFailed(),
      );
      
      print("error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringTextsNames.txtSubscribeAppBar,
          style: TextStyles.font18BlueSemiBold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            verticalSpace(12),
            Text(
              StringTextsNames.txtSubscribeDes,
              style: TextStyles.font14DarkBlueMedium,
            ),
            verticalSpace(50),
            BuildTextFormField(
              hintText: 'Subscription Code',
              controller: codeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringTextsNames.txtValidateSubscriptionCode;
                }
                return null;
              },
            ),
            verticalSpace(50),
            BuildButton(
              textButton: StringTextsNames.txtSubscribe,
              textStyle: TextStyles.font16WhiteMedium,
              onPressed: _subscribe,
            ),
          ],
        ),
      ),
    );
  }
}