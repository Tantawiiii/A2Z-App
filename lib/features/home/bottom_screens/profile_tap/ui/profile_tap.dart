import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/clients/dio_client_graphql.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../a2z_app.dart';
import '../../../../../core/language/language.dart';
import '../services/graphql_getprofile_service.dart';
import '../services/logout_services.dart';
import '../widgets/build_profile_options.dart';

class ProfileTap extends StatefulWidget {
  const ProfileTap({super.key});

  @override
  State<ProfileTap> createState() => _ProfileTapState();
}

class _ProfileTapState extends State<ProfileTap> {
  late ProfileGraphQLService _profileService;
  String currentLang = "";
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    final dioClientGrapQl = DioClientGraphql();
    _profileService = ProfileGraphQLService(dioClientGrapQl);
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _profileService.fetchProfile(context);

      if (data != null) {
        // Extract the 'dynamicProperties' list
        final dynamicProperties =
        data['contact']['dynamicProperties'] as List<dynamic>;

        // Find the 'ProfilePhoto' property
        final profilePhotoProperty = dynamicProperties.firstWhere(
              (property) => property['name'] == 'ProfilePhoto',
          orElse: () => null,
        );

        // Add the 'ProfilePhoto' to the profile data
        if (profilePhotoProperty != null) {
          data['profilePhoto'] = profilePhotoProperty['value'];
        }
      }

      setState(() {
        _profileData = data;
      });
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final LogOutServices _logout_services = LogOutServices();
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _profileData == null
                ? ListView(
              padding: const EdgeInsets.symmetric(
                  vertical: 30, horizontal: 15),
              children: [
                verticalSpace(50.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.blue[200]!,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                verticalSpace(10.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.blue[200]!,
                  child: Container(
                    height: 20.h,
                    color: Colors.grey[300],
                  ),
                ),
                verticalSpace(5.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.blue[200]!,
                  child: Container(
                    height: 20.h,
                    width: 150.w,
                    color: Colors.grey[300],
                  ),
                ),
                verticalSpace(40.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.blue[200]!,
                  child: Column(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: 50.h,
                          color: Colors.grey[300],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            )
                : ListView(
              padding: const EdgeInsets.symmetric(
                  vertical: 30, horizontal: 15),
              scrollDirection: Axis.vertical,
              children: [
                verticalSpace(80.h),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: _profileData!['profilePhoto'] !=
                      null &&
                      _profileData!['profilePhoto']
                          .toString()
                          .isNotEmpty
                      ? _getImageProvider(_profileData!['profilePhoto'])
                      : (_profileData!['photoUrl'] != null &&
                      _profileData!['photoUrl'].contains('http')
                      ? NetworkImage(_profileData!['photoUrl'])
                      : const AssetImage('asset/images/teacher.png')
                  as ImageProvider),
                ),
                verticalSpace(10.h),
                Text(
                  (_profileData!['contact']['fullName'] ??
                      _profileData!['userName']),
                  textAlign: TextAlign.center,
                  style: TextStyles.font20BlueBold,
                ),
                Text(
                  _profileData!['email'] ?? 'email',
                  textAlign: TextAlign.center,
                  style: TextStyles.font13DarkBlueRegular,
                ),
                verticalSpace(40.h),
                BuildProfileOptions(
                  icon: Icons.lock_outline,
                  text: Language.instance.txtChangePass(),
                  color: ColorsCode.gray,
                  onTap: () {
                    print('Change Password Tapped');
                    context.pushNamed(Routes.changePasswordScreen);
                  },
                ),
                BuildProfileOptions(
                  icon: Icons.school,
                  text: Language.instance.txtExams(),
                  color: ColorsCode.gray,
                  onTap: () {
                    print('My Exams Tapped');

                    context.pushNamed(Routes.examScreen);
                  },
                ),
                BuildProfileOptions(
                  icon: Icons.info_outline,
                  text: Language.instance.txtAboutUs(),
                  color: ColorsCode.gray,
                  onTap: () {
                    print('About Us Tapped');
                    context.pushNamed(Routes.aboutUsScreen);
                  },
                ),
                BuildProfileOptions(
                  icon: Icons.exit_to_app,
                  text: Language.instance.txtLogOut(),
                  color: Colors.red,
                  onTap: () {
                    _logout_services.logout(context);
                    print('Logout Tapped');
                  },
                ),
                verticalSpace(100),
              ],
            ),
            // Positioned LiteRollingSwitch widget
            Positioned(
              top: 50.h,
              right: isArabic ? 8.w : null,
              left: isArabic ? null : 8.w,
              child: SizedBox(
                width: 130,
                height: 40,
                child: LiteRollingSwitch(
                  value: false,
                  textOn: 'English',
                  textOff: 'Arabic',
                  colorOn: ColorsCode.mainBlue,
                  colorOff: ColorsCode.darkBlue,
                  iconOn: Icons.done,
                  iconOff: Icons.remove_circle_outline,
                  textSize: 14.0,
                  width: 55,
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
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    } else {
      // Return a default image if the file doesn't exist.
      return const AssetImage('asset/images/teacher.png');
    }
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

    setState(() {});
  }
}
