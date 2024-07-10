
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            "SplashScreen",
            style: TextStyle(
              fontSize: 55.sp,
            ),
          ),
        ),
      ),
    );
  }
}
