import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:a2z_app/features/forget_password/services/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'a2z_app.dart';
import 'core/routing/app_router.dart';
import 'core/networking/clients/get_grades_graphql_client.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  GraphQLClientInstance.initializeClient();
  WidgetsFlutterBinding.ensureInitialized();

  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(ApiConstants.apiBaseUrlGraphQl);

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  );

  runApp(ChangeNotifierProvider(
    create: (context) => AppStateProvider(),
    child: A2ZApp(
      appRouter: AppRouter(),
      client: client,
    ),
  ));
}
