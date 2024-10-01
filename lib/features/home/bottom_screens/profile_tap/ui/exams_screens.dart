import 'dart:async';

import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../../a2z_app.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/language/language.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/images_paths.dart';

class ExamsScreens extends StatefulWidget {
  const ExamsScreens({super.key});

  @override
  State<ExamsScreens> createState() => _ExamsScreensState();
}

class _ExamsScreensState extends State<ExamsScreens> {

  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState

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
    super.initState();
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
            Language.instance.txtExams(),
            style: TextStyles.font15DarkBlueMedium,
          ),
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagesPaths.imgEmptyExam,
                width: 290.w,
              ),
              verticalSpace(12),
              Text(
                Language.instance.txtEmptyExams(),
                style: TextStyles.font14BlueSemiBold,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
      : const NoInternetScreen(),
    );
  }
}
