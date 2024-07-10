import 'package:a2z_app/a2z_app.dart';
import 'package:a2z_app/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(
     A2ZApp(appRouter: AppRouter(),),
  );
}
