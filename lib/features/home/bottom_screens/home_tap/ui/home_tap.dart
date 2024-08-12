import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/home/bottom_screens/home_tap/services/banners_servise.dart';
import 'package:a2z_app/features/home/bottom_screens/home_tap/widgets/build_banner_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/networking/clients/dio_client.dart';
import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/StringsTexts.dart';
import '../../profile_tap/services/graphql_getprofile_service.dart';
import '../view_model/home_tap_view_model.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  late GetProfileGraphQLService _graphQLService;
  Map<String, dynamic>? _profileData;

  late HomeTapViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final dioClientGrapQl = DioClientGraphql();
    _graphQLService = GetProfileGraphQLService(dioClientGrapQl);

    // Fetch profile and banners
    _fetchProfile();
    _viewModel = HomeTapViewModel();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _graphQLService.fetchProfile(context);
      setState(() {
        _profileData = data?['me'];
      });
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.w),
        child: ListView(
          children: [
            _profileData == null
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.cyan,
                    ),
                  )
                : Text(
                    StringTextsNames.txtWelcome + _profileData!['userName'],
                    style: TextStyles.font20BlueBold,
                  ),
            verticalSpace(6),
            RichText(
              text: TextSpan(
                text: StringTextsNames.txtHowAre,
                style: TextStyles.font13GrayNormal,
                children: <TextSpan>[
                  TextSpan(
                    text: StringTextsNames.txtReady,
                    style: TextStyles.font13BlueSemiBold,
                  ),
                ],
              ),
            ),
            verticalSpace(20),
            BuildBannersView(banners: _viewModel.banners),
          ],
        ),
      ),
    );
  }

}
