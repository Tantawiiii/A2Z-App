import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:motion/motion.dart';

import '../../../core/language/language.dart';
import '../../../core/routing/routers.dart';
import '../../../core/utils/colors_code.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      child: Motion(
        child: TextButton(
          onPressed: () {
            context.pushNamed(Routes.loginScreen);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(ColorsCode.mainBlue),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: WidgetStateProperty.all(const Size(double.infinity, 52)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(
            Language.instance.txGetStartedButton(),
            style: TextStyles.font16WhiteMedium,
          ),
        ),
      ),
    );
  }
}
