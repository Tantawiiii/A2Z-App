import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theming/text_style.dart';
import '../../../core/utils/colors_code.dart';

class TeacherImageTextWidget extends StatelessWidget {
  const TeacherImageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
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
              StringsTexts.txtOnBoardingHeadLine,
              textAlign: TextAlign.center,
              style: TextStyles.font24BlueBold.copyWith(
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
