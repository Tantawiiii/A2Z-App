import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'a2z_app.dart';
import 'core/routing/app_router.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(ChangeNotifierProvider(
    create: (context) => AppStateProvider(),
    child: A2ZApp(
      appRouter: AppRouter(),
    ),
  ));
}
