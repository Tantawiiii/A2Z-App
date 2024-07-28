import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/features/forget_password/services/network/password_reset_service.dart';
import 'package:a2z_app/features/forget_password/ui/screens/forget_passworf_screen.dart';
import 'package:a2z_app/features/forget_password/ui/screens/verify_otp_screen.dart';
import 'package:a2z_app/features/getstarted/get_started_screen.dart';
import 'package:a2z_app/features/signup/ui/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../features/login/ui/screens/login_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';

class AppRouter {
  late final PasswordResetService passwordResetService;

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.getStartedScreen:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.signupScreen:
        return MaterialPageRoute(builder: (_) =>  SignupScreen());
      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgetPassword());
      case Routes.verifyOtpScreen:
        return MaterialPageRoute(builder: (_) => const VerifyOtpScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
