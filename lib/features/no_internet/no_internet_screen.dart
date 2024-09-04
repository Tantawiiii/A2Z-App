import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/language/StringsTexts.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../a2z_app.dart';
import '../../core/language/language.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'asset/anim/no_internet.json',
              repeat: true,
            ),
            verticalSpace(24),
            Text(
             Language.instance.txtNoInternet(),
              style: TextStyles.font22RedBold,
            ),
            verticalSpace(20),
             Text(
              Language.instance.txtPleaseCheckInternet(),
              style: TextStyles.font15DarkBlueMedium,
               textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
