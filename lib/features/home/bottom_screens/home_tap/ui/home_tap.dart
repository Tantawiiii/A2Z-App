import 'dart:async';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../a2z_app.dart';
import '../../../../../core/language/language.dart';
import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/images_paths.dart';
import '../../../../get_courses_id_proudact/ui/ProductListScreen.dart';
import '../../profile_tap/services/graphql_getprofile_service.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  late ProfileGraphQLService _profileService;
  Map<String, dynamic>? _profileData;
  List<String> _banners = [];
  final List<dynamic> _categories = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final dioClientGraphQl = DioClientGraphql();
    _profileService = ProfileGraphQLService(dioClientGraphQl);
    _scrollController = ScrollController();
    _startAutoScroll();

    // Fetch profile and banners
    _fetchProfile();
    _fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.w),
          child: ListView(
            shrinkWrap: true,
            children: [
              _profileData == null
                  ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 150,
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
                  : RichText(
                text: TextSpan(
                  text: '${Language.instance.txtWelcome()}\n',
                  style: TextStyles.font15DarkBlueMedium,
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
                  text: Language.instance.txtHowAre(),
                  style: TextStyles.font15DarkBlueMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: Language.instance.txtReady(),
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
                      child: CachedNetworkImage(
                        imageUrl: _banners[index],
                        fit: BoxFit.cover,
                        width: 300,
                        height: 150,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300,
                            height: 150,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          ImagesPaths.logoImage,
                        ),
                      ),
                    );
                  },
                ),
              )
                  : _buildShimmerBannerPlaceholder(),

              verticalSpace(24),
              Text(
                Language.instance.txtCategories(),
                style: TextStyles.font14BlueSemiBold,
              ),
              verticalSpace(14),
              _categories.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2.5,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final categoryId = category['id']; // Get the category ID

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the ProductListScreen with the category ID
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductListScreen(categoryId: categoryId),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 160.h,
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    category['imgSrc'] != null
                                        ? Image.network(
                                            category['imgSrc'],
                                            fit: BoxFit.cover,
                                            height: 130,
                                            width: double.infinity,
                                          )
                                        : SvgPicture.asset(
                                            ImagesPaths.logoImage,
                                            height: 110.h,
                                            width: 90.w,
                                          ),
                                    verticalSpace(12.0),
                                    Text(
                                      category['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyles.font13BlueSemiBold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        children: [
                          Image.asset(
                            ImagesPaths.imgEmptyCourses,
                            width: 280.w,
                          ),
                          verticalSpace(20.h),
                          Text(
                            Language.instance.txtNoCategoriesAval(),
                            style: TextStyles.font13GrayNormal,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _profileService.fetchProfile(context);
      if (!mounted) return; // Check if widget is still in the tree
      setState(() {
        _profileData = data;
      });

      final dynamicProperties = _profileData?['contact']?['dynamicProperties'];
      if (dynamicProperties != null) {
        final grade = dynamicProperties.firstWhere(
                (prop) => prop['name'] == 'grade',
            orElse: () => null)?['value'];

        if (grade != null) {
          await _fetchCategories(grade);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load profile: $e');
      }
    }
  }

  Future<void> _fetchCategories(String grade) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.apiBaseUrlGraphQl,
        data: {
          "query": """
          query Categories {
            categories(query: "$grade", storeId: "A2Z") {
              items {
                childCategories {
                  imgSrc
                  name
                  id
                  level
                }
              }
            }
          }
        """
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (!mounted) return; // Check if widget is still in the tree
      if (response.statusCode == 200) {
        final List<dynamic> categories =
        response.data['data']['categories']['items'][0]['childCategories'];
        setState(() {
          _categories.clear();
          _categories.addAll(categories);
        });
      } else {
        if (kDebugMode) {
          print('Failed to load categories');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.apiGetBanners,
        queryParameters: {'BannarArea': 'Home'},
      );

      if (!mounted) return; // Check if widget is still in the tree
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


  // Auto-scroll Banners
  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double scrollIncrement = 300.0;

        double targetScroll = currentScroll + scrollIncrement;
        if (targetScroll >= maxScroll) {
          targetScroll = 0; // Scroll back to the start
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

  // Shimmer placeholder widget for banners
  Widget _buildShimmerBannerPlaceholder() {
    return Shimmer.fromColors(
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
    );
  }
}
