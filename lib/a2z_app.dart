import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routers.dart';
import 'core/utils/colors_code.dart';

class A2ZApp extends StatelessWidget {
  const A2ZApp({super.key, required this.appRouter, required this.client});
  final AppRouter appRouter;
  final GraphQLClient client;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:  const Size(375,812),
      child: GraphQLProvider(
        client: ValueNotifier(client),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: ColorsCode.mainBlue,
              scaffoldBackgroundColor: ColorsCode.white
          ),
          initialRoute: Routes.splashScreen,
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );

  }
}
