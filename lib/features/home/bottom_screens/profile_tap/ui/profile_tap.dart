import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/clients/dio_client_graphql.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/networking/clients/dio_client.dart';
import '../services/graphql_getprofile_service.dart';
import '../services/logout_services.dart';
import '../widgets/build_profile_options.dart';


class ProfileTap extends StatefulWidget {
  const ProfileTap({super.key});

  @override
  State<ProfileTap> createState() => _ProfileTapState();
}

class _ProfileTapState extends State<ProfileTap> {

  late GetProfileGraphQLService _graphQLService;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    final dioClient = DioClientGraphql();
    _graphQLService = GetProfileGraphQLService(dioClient);
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _graphQLService.fetchProfile();
      setState(() {
        _profileData = data?['me'];
      });
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }


  @override
  Widget build(BuildContext context) {

    // logout the user setup
    final LogOutServices _logout_services =  LogOutServices();

    return Scaffold(
      backgroundColor: Colors.white,
      body:
      _profileData == null
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan,))
      :
      ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        scrollDirection: Axis.vertical,
        children: [
          verticalSpace(50.h),
          CircleAvatar(
            radius: 80,
            backgroundImage: _profileData!['photoUrl'] != null &&
                _profileData!['photoUrl'].contains('http')
                ? NetworkImage(_profileData!['photoUrl'])
                : const AssetImage('asset/images/teacher.png') as ImageProvider,
          ),
          verticalSpace(10.h),
          Text(
            _profileData!['userName'] ?? 'Username',
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
              _logout_services.logout(context);
              print('Logout Tapped');
            },
          ),
        ],
      ),
    );
  }
}
