import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:bounce/bounce.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/StringsTexts.dart';
import '../../../widgets/build_empty_courses.dart';
import '../../profile_tap/services/graphql_getprofile_service.dart';
import '../services/categories_graphql_services.dart';
import '../view_model/home_tap_view_model.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  late ProfileGraphQLService _profileService;
  late CategoriesGraphQLService _categoriesService;

  Map<String, dynamic>? _profileData;

  late HomeTapViewModel _viewModel;
  List<String> _banners = [];



  @override
  void initState() {
    super.initState();
    final dioClientGrapQl = DioClientGraphql();
    _profileService = ProfileGraphQLService(dioClientGrapQl);
    _categoriesService = CategoriesGraphQLService(dioClientGrapQl);

    // Fetch profile and banners
    _fetchProfile();
    fetchBanner();
    _viewModel = HomeTapViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.w),
        child: ListView(
          children: [
            _profileData == null
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.cyan,
                    ),
                  )
                : Text(
                    StringTextsNames.txtWelcome + (_profileData!['userName'] ?? ""),
                    style: TextStyles.font20BlueBold,
                  ),
            verticalSpace(8),
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
            _banners.isNotEmpty
                ? SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _banners.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image.network(
                            _banners[index],
                            fit: BoxFit.cover,
                            width: 300,
                            height: 150,
                          ),
                        );
                      },
                    ),
                  )
                : Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.blue[200]!,
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // Placeholder item count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 300,
                              height: 150,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            verticalSpace(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  StringTextsNames.txtCategories,
                  style: TextStyles.font14BlueSemiBold,
                ),
                Bounce(
                  onTap: () {
                    // Go to all Courses without Filtration
                  },
                  child: Text(
                    StringTextsNames.txtShowAll,
                    style: TextStyles.font10GrayNormal,
                  ),
                ),
              ],
            ),
            verticalSpace(24),

            // Display shimmer effect if categories are being loaded
            if (_viewModel.categories == null)
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.blue[200]!,
                child: Column(
                  children: List.generate(
                    3,
                    (index) => _buildShimmerCategoryPlaceholder(),
                  ),
                ),
              )
            // Show empty courses widget if there are no categories available
            else if (_viewModel.categories!.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: BuildEmptyCourses(txtNot: StringTextsNames.txtNoCategories,),
              )
            // Display the actual categories if available
            else
              for (final category in _viewModel.categories!)
                _buildCategoryWidget(category),
          ],
        ),
      ),
    );
  }

  // fetch Banners
  Future<void> fetchBanner() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.apiGetBanners,
        queryParameters: {
          'BannarArea': 'Home',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _banners = data.cast<String>();
        });
      } else {
        if (kDebugMode) {
          print('Failed to load banners');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  // Fetch Data Profile
  Future<void> _fetchProfile() async {
    try {
      final data = await _profileService.fetchProfile(context);
      setState(() {
        _profileData = data;
      });

      // Extract grade from dynamicProperties
      final grade = _profileData?['contact']?['dynamicProperties']
          ?.firstWhere((prop) => prop['name'] == 'grade')['value'];

      if (grade != null) {
        _viewModel.categories = await _categoriesService.fetchCategories(grade);
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load profile: $e');
      }
    }
  }
}

Widget _buildCategoryWidget(Map<String, dynamic>? category) {
  // Check if the category is null or if the name is empty
  final hasChildCategories = category != null &&
      category['name'] != null &&
      category['name'].isNotEmpty;

  if (!hasChildCategories) {
    // Show shimmer effect while loading or if no categories are available
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.blue[200]!,
      child: const Padding(
        padding: EdgeInsets.all(24.0),
        child: BuildEmptyCourses(txtNot: StringTextsNames.txtNoCategories,),
      ),
    );
  }

  // Return the category widget if data is available
  return Row(
    children: [
      Image.network(
        category['imgSrc'] ??
            'https://via.placeholder.com/150', // Provide a default image URL
      ),
      horizontalSpace(8),
      Text(
        category['name']!,
        style: TextStyles.font18BlueSemiBold,
      ),
    ],
  );
}

// Shimmer placeholder widget for categories
Widget _buildShimmerCategoryPlaceholder() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
          width: 150,
          height: 100,
          color: Colors.grey[300],
        ),
        horizontalSpace(8),
        Expanded(
          child: Container(
            height: 20,
            color: Colors.grey[300],
          ),
        ),
      ],
    ),
  );
}
