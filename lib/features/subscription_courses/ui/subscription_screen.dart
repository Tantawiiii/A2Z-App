import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/widgets/build_text_form_field.dart';
import 'package:a2z_app/features/subscription_courses/widgets/bottom_sheet_subscribe_success.dart';
import 'package:flutter/material.dart';

import '../../../core/networking/clients/dio_client.dart';
import '../../../core/routing/routers.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/widgets/build_button.dart';
import '../service/subscription_service.dart';
import '../widgets/bottom_sheet_subscribe_failed.dart';


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionService subscriptionService = SubscriptionService(DioClient());

  final TextEditingController courseIdController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  void _subscribe() async {
    String courseId = courseIdController.text;
    String code = codeController.text;
    await subscriptionService.subscribeByCode(courseId, code);
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
            // TODO: WILL REMOVE this in the future when call Course and take id
            // TODO: when click on the Course or take courses ids from the Cart
            BuildTextFormField(hintText:'Course ID' , controller:courseIdController ,),
            verticalSpace(16),
            BuildTextFormField(hintText:'Subscription Code' , controller:codeController ,),
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
