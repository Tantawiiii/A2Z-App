import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/language/StringsTexts.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          ImagesPaths.animNoInternet,
          repeat: true,
        ),
        verticalSpace(20),
        const Text(
         StringTextsNames.txtNoInternet,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        verticalSpace(20),
        const Text(
          StringTextsNames.txtPleaseCheckInternet,
          style: TextStyle(fontSize: 16),
        ),
        verticalSpace(20),
        ElevatedButton(
          onPressed: () {
           //    // Navigate back to the main content or refresh the current screen
           //    Navigator.of(context).pop(); // Example: go back to the previous screen
          },
          child: const Text(StringTextsNames.txtRetry),
        ),
      ],
    );
  }
}
