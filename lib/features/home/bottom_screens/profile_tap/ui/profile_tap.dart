import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/clients/dio_client_graphql.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        final dynamicProperties = data['contact']['dynamicProperties'] as List<dynamic>;

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: _profileData == null
          ? ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        scrollDirection: Axis.vertical,
        children: [
          verticalSpace(50.h),
          CircleAvatar(
            radius: 80,
            backgroundImage: _profileData!['profilePhoto'] != null &&
                _profileData!['profilePhoto'].toString().isNotEmpty
                ? FileImage(File(_profileData!['profilePhoto'])) // Use FileImage for local files
                : (_profileData!['photoUrl'] != null && _profileData!['photoUrl'].contains('http')
                ? NetworkImage(_profileData!['photoUrl'])
                : const AssetImage('asset/images/teacher.png') as ImageProvider),
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
            text: StringTextsNames.txtChangePass,
            color: ColorsCode.gray,
            onTap: () {
              print('Change Password Tapped');
              context.pushNamed(Routes.changePasswordScreen);
            },
          ),
          BuildProfileOptions(
            icon: Icons.school,
            text: StringTextsNames.txtExams,
            color: ColorsCode.gray,
            onTap: () {
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
              _logout_services.logout(context);
              print('Logout Tapped');
            },
          ),
        ],
      ),
    );
  }
}
