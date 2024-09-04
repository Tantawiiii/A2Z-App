import 'dart:async';

import 'package:a2z_app/features/getstarted/widgets/teacher_image_text_widget.dart';
import 'package:a2z_app/features/getstarted/widgets/getstarted_button.dart';
import 'package:a2z_app/features/no_internet/no_internet_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../a2z_app.dart';
import '../../core/language/language.dart';
import '../../core/theming/text_style.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _visible = false;


  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;


  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Initialize slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ),);

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
      _animationController.forward();
    });

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
    _animationController.dispose();
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: 30.0.h, bottom: 30.h),
            child: ListView(
              children: [
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const TeacherImageTextWidget(),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          Language.instance.txtOnBoardingDescription(),
                          style: isArabic
                              ? TextStyles.font15DarkBlueMedium
                              : TextStyles.font13GrayNormal,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: const GetStartedButton(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
      : const NoInternetScreen(),
    );
  }
}
