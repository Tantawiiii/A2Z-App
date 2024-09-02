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
  String currentLang = "";

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
          top: 8,
          left: 8,
          child: Container(
            width: 125,
            height: 40,
            child: LiteRollingSwitch(
              value: true,
              textOn: 'English',
              textOff: 'Arabic',
              colorOn: ColorsCode.mainBlue,
              colorOff: ColorsCode.darkBlue,
              iconOn: Icons.done,
              iconOff: Icons.remove_circle_outline,
              textSize: 14.0,
              onChanged: (bool state) {
                print('Current State of SWITCH IS: $state');

                setState(() {
                  if (state) {
                    changeLanguage("en");
                  } else {
                    changeLanguage("ar");
                  }
                });
              },
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
            ),
          ),
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

  changeLanguage(lang) async {
    if (A2ZApp.getLocal(context).languageCode == 'ar') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("language", "EN");

      Language.instance.setLanguage("EN");
      currentLang = "EN";
      setState(() {});
      Locale newLocale = const Locale('en');
      A2ZApp.setLocale(context, newLocale);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("language", "AR");

      Language.instance.setLanguage("AR");
      currentLang = "AR";
      setState(() {});
      Locale newLocale = const Locale('ar');
      A2ZApp.setLocale(context, newLocale);
    }

    // setState(() {
    //   //EasyLoading.showSuccess("Changed");
    //   Phoenix.rebirth(context);
    // });
  }
}
