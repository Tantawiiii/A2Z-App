import 'package:a2z_app/core/language/StringsTexts.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../a2z_app.dart';
import '../../../core/language/language.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/utils/colors_code.dart';

class TeacherImageTextWidget extends StatefulWidget {
  const TeacherImageTextWidget({super.key});

  @override
  State<TeacherImageTextWidget> createState() => _TeacherImageTextWidgetState();
}

class _TeacherImageTextWidgetState extends State<TeacherImageTextWidget> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SvgPicture.asset(ImagesPaths.logoIconBack),
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  ColorsCode.white,
                  ColorsCode.white.withOpacity(0.0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.10, 0.5]),
          ),
          child: Image.asset(ImagesPaths.imgTeacher),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Text(
            Language.instance.txtOnBoardingHeadLine(),
            textAlign: TextAlign.center,
            style: TextStyles.font24BlueBold.copyWith(
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }


}
