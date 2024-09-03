import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/language/StringsTexts.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../a2z_app.dart';
import '../../core/language/language.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              ImagesPaths.animNoInternet,
              repeat: true,
            ),
            verticalSpace(20),
            Text(
             Language.instance.txtNoInternet(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            verticalSpace(20),
             Text(
              Language.instance.txtPleaseCheckInternet(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
