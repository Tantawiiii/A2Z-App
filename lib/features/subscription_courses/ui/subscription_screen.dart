import 'dart:async';

import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../a2z_app.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/language/language.dart';
import '../../../core/theming/text_style.dart';
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
  final SubscriptionService subscriptionService = SubscriptionService(Dio());

  final TextEditingController codeController = TextEditingController();

  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // start checker internet connection
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
            default:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  void _subscribe() async {
    String code = codeController.text;
    try {
        await subscriptionService.subscribeByCode(widget.courseId, code);
        // Show success bottom sheet
        showModalBottomSheet(
          context: context,
          builder: (context) => const BottomSheetSubscribeSuccess(),
        );
    } catch (e) {
      // Show error bottom sheet
      print("error1: ${e.toString()}");
      showModalBottomSheet(
        context: context,
        builder: (context) => const BottomSheetSubscribeFailed(),
      );
      print("error2: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
        appBar: AppBar(
          title: Text(
            Language.instance.txtSubscribeAppBar(),
            style: TextStyles.font15DarkBlueMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              verticalSpace(12),
              Text(
                Language.instance.txtSubscribeDes(),
                style: TextStyles.font14DarkBlueMedium,
              ),
              verticalSpace(50),
              BuildTextFormField(
                hintText: Language.instance.txtSubscriptionCode(),
                controller: codeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Language.instance.txtValidateSubscriptionCode;
                  }
                  return null;
                },
              ),
              verticalSpace(50),
              BuildButton(
                textButton: Language.instance.txtSubscribe(),
                textStyle: TextStyles.font18WhiteSemiBold,
                onPressed: _subscribe,
              ),
            ],
          ),
        ),
      )
      : const NoInternetScreen(),
    );
  }
}