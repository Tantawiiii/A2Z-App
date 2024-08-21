

import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/widgets/build_button.dart';
import 'package:flutter/material.dart';

class CartTap extends StatelessWidget {
  const CartTap({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BuildButton(
              textButton: StringTextsNames.txtCheckOut,
              textStyle: TextStyles.font16WhiteMedium,
              onPressed: (){},
          ),
        ),
      ),
    );
  }
}
