import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routers.dart';
import 'core/utils/colors_code.dart';

late Locale _locale;

class A2ZApp extends StatefulWidget {
  const A2ZApp({super.key, required this.appRouter, required this.client});
  final AppRouter appRouter;
  final GraphQLClient client;

  @override
  State<A2ZApp> createState() => _A2ZAppState();

  static void setLocale(BuildContext context, Locale newLocale) async {
    _A2ZAppState? state = context.findAncestorStateOfType<_A2ZAppState>();
    state!.changeLanguage(newLocale);
  }
  static Locale getLocal(BuildContext context) {
    _A2ZAppState? state = context.findAncestorStateOfType<_A2ZAppState>();
    return state!.getLocal();
  }
}

class _A2ZAppState extends State<A2ZApp> {

  @override
  void initState() {
    super.initState();
    _locale = const Locale('en'); // Initialize _locale with a default value
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Locale getLocal() {
    return _locale;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: GraphQLProvider(
        client: ValueNotifier(widget.client),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: ColorsCode.mainBlue,
              scaffoldBackgroundColor: ColorsCode.white),
          initialRoute: Routes.splashScreen,
          onGenerateRoute: widget.appRouter.generateRoute,
          locale: _locale, // Pass the locale to the MaterialApp
        ),
      ),
    );
  }
}
