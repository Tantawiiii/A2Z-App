import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'a2z_app.dart';
import 'core/routing/app_router.dart';
import 'core/networking/clients/get_grades_graphql_client.dart';

String language = "EN";
late Locale _locale;

void main() async {
  await ScreenUtil.ensureScreenSize();
  GraphQLClientInstance.initializeClient();

  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(ApiConstants.apiBaseUrlGraphQl);

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  );
  SharedPreferences.getInstance().then((value) {
    if (value.getString("language") == null) {
      language = "EN";
      _locale = const Locale("EN");
    } else {
      language = value.getString("language") as String;
      _locale = Locale(value.getString("language")!.toLowerCase());
    }

    runApp(
      ChangeNotifierProvider(
        create: (context) => AppStateProvider(),
        child: A2ZApp(
          appRouter: AppRouter(),
          client: client,
        ),
      ),
    );
  });
}
