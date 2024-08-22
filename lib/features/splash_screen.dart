
import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:flutter/material.dart';

import '../core/networking/local/token_storage.dart';
import '../core/routing/routers.dart';
import '../core/utils/colors_code.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final tokenStorage = TokenStorage();
    final token = await tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      // Token exists, navigate to home
      context.pushNamedAndRemoveUntil(Routes.homeScreen, predicate:  (route) => false);
    } else {
      // No token, navigate to onboarding
      context.pushNamedAndRemoveUntil(Routes.onBoardingScreen, predicate:  (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorsCode.white,
      body: Center(
        child: CircularProgressIndicator(
          color: ColorsCode.mainBlue,
        ),
      ),
    );
  }
}
