import 'dart:async';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
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

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final dioClientGraphQl = DioClientGraphql();
    _profileService = ProfileGraphQLService(dioClientGraphQl);
    _categoriesService = CategoriesGraphQLService(dioClientGraphQl);

    _scrollController = ScrollController();
    _startAutoScroll();

    // Fetch profile and banners
    _fetchProfile();
    fetchBanner();
    _viewModel = HomeTapViewModel();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                : RichText(
                    text: TextSpan(
                      text: '${StringTextsNames.txtWelcome}\n',
                      style: TextStyles.font13GrayNormal,
                      children: <TextSpan>[
                        TextSpan(
                          text: (_profileData?['userName'] ?? ""),
                          style: TextStyles.font18BlueSemiBold,
                        ),
                      ],
                    ),
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
                      controller: _scrollController,
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
            _viewModel.categories == null
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.blue[200]!,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio:
                            1.0, // Adjust the aspect ratio as needed
                      ),
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildShimmerCategoryPlaceholder();
                      },
                    ),
                  )
                : _viewModel.categories!.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: BuildEmptyCourses(
                          txtNot: StringTextsNames.txtNoCategories,
                        ),
                      )
                    : SizedBox(
                        height: 600,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.0, // Adjust as needed
                          ),
                          itemCount: _viewModel.categories!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category = _viewModel.categories![index];
                            return _buildCategoryWidget(category);
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }

  // Auto-scroll Banners
  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double scrollIncrement = 300.0;

        double targetScroll = currentScroll + scrollIncrement;
        // Scroll back to the start
        if (targetScroll >= maxScroll) {
          targetScroll = 0;
        }

        _scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  // Fetch Banners
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

      // Check if `contact` or `dynamicProperties` is null
      final dynamicProperties = _profileData?['contact']?['dynamicProperties'];
      if (dynamicProperties != null) {
        final grade = dynamicProperties.firstWhere(
            (prop) => prop['name'] == 'grade',
            orElse: () => null)?['value'];

        if (grade != null) {
          _viewModel.categories =
              await _categoriesService.fetchCategories(grade);
          setState(() {});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load profile: $e');
      }
    }
  }
}

Widget _buildCategoryWidget(Map<String, dynamic>? category) {
  final hasChildCategories = category != null &&
      category['name'] != null &&
      category['name'].isNotEmpty;

  if (!hasChildCategories) {
    // If the category data is missing, return a placeholder
    return _buildShimmerCategoryPlaceholder();
  }
  return Container(
    width: 200,
    height: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: ColorsCode.backCatHome,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.network(
                category['imgSrc'] ?? 'https://via.placeholder.com/150',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

// Shimmer placeholder widget for categories
Widget _buildShimmerCategoryPlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.blue[200]!,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[300],
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 80,
            color: Colors.grey[300],
          ),
        ],
      ),
    ),
  );
}
