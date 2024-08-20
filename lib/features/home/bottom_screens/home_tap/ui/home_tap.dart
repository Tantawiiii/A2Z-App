
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
  late HomeTapViewModel _viewModel;

  Map<String, dynamic>? _profileData;
  List<String> _banners = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final dioClientGraphQl = DioClientGraphql();
    _profileService = ProfileGraphQLService(dioClientGraphQl);
    _viewModel = HomeTapViewModel();

    _scrollController = ScrollController();
    _startAutoScroll();

    // Fetch profile and banners
    _fetchProfile();
    fetchBanner();
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
            if (_viewModel.categories == null)
              Text(
                StringTextsNames.txtCategories,
                style: TextStyles.font14BlueSemiBold,
              ),
            verticalSpace(14),
            _viewModel.categories == null
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.blue[200]!,
              child: SizedBox(
                height: 400,
                width: 250,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildShimmerCategoryPlaceholder();
                  },
                ),
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
              height: 600.h,
              width: 250.w,
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: _viewModel.categories!.length,
                itemBuilder: (BuildContext context, int index) {
                  final category =
                  _viewModel.categories![index];
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

  // Fetch profile data and categories
  Future<void> _fetchProfile() async {
    try {
      final data = await _profileService.fetchProfile(context);
      setState(() {
        _profileData = data;
      });

      final dynamicProperties =
      _profileData?['contact']?['dynamicProperties'];
      if (dynamicProperties != null) {
        final grade = dynamicProperties.firstWhere(
                (prop) => prop['name'] == 'grade',
            orElse: () => null)?['value'];

        if (grade != null) {
          await _viewModel.fetchCategoriesByGrade(grade);
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
  // Check if childCategories exist and have at least one item
  final hasChildCategories = category != null &&
      category['childCategories'] != null &&
      category['childCategories'].isNotEmpty;

  if (!hasChildCategories) {
    // If the category data is missing or empty, return a placeholder
    return _buildShimmerCategoryPlaceholder();
  }

  // Extract the first child category's image, name, and ID
  final childCategory = category['childCategories'][0];
  final imgSrc = childCategory['imgSrc'] ?? 'https://via.placeholder.com/150';
  final name = childCategory['name'] ?? '';
  final id = childCategory['id'] ?? '';

  return Container(
    width: 250,
    height: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: ColorsCode.backCatHome,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
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
                imgSrc,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
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
      width: 200,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[300],
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded( // Wrap the Column's content with Expanded
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
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
