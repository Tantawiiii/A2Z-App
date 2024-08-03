import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/build_profile_options.dart';

class ProfileTap extends StatelessWidget {
  const ProfileTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        scrollDirection: Axis.vertical,
        children: [
          verticalSpace(50.h),
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(
                'asset/images/teacher.png'), // Replace with your profile image asset
          ),
          verticalSpace(10.h),
          Text(
            StringTextsNames.txtAhmedRamadan,
            textAlign: TextAlign.center,
            style: TextStyles.font20BlueBold,
          ),
          Text(
            StringTextsNames.txtStudent,
            textAlign: TextAlign.center,
            style: TextStyles.font13DarkBlueRegular,
          ),
          verticalSpace(40.h),
          BuildProfileOptions(
            icon: Icons.lock_outline,
            text: StringTextsNames.txtChangePass,
            color: ColorsCode.gray,
            onTap: () {
              print('Change Password Tapped');
            },
          ),
          BuildProfileOptions(
            icon: Icons.school,
            text: StringTextsNames.txtExams,
            color: ColorsCode.gray,
            onTap: () {
              // Handle on tap
              print('My Exams Tapped');
            },
          ),
          BuildProfileOptions(
            icon: Icons.help_outline,
            text: StringTextsNames.txtFaq,
            color: ColorsCode.gray,
            onTap: () {
              print('FAQ Tapped');
            },
          ),
          BuildProfileOptions(
            icon: Icons.info_outline,
            text: StringTextsNames.txtAboutUs,
            color: ColorsCode.gray,
            onTap: () {
              print('About Us Tapped');
            },
          ),
          BuildProfileOptions(
            icon: Icons.exit_to_app,
            text: StringTextsNames.txtLogOut,
            color: Colors.red,
            onTap: () {
              print('Logout Tapped');
            },
          ),
        ],
      ),
    );
  }
}
