import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/networking/const/api_constants.dart';
import '../../core/utils/images_paths.dart';
import '../home/courses/ui/course_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;

  const ProductListScreen({Key? key, required this.categoryId})
      : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.apiBaseUrlGraphQl,
        data: {
          'query': '''
          query Products {
            products(
              storeId: "A2Z"
              filter: "category.subtree:f45c955e-f00e-4c99-96d3-b20bd8b48986/${widget.categoryId}"
            ) {
              items {
                id
                name
                imgSrc
              }
            }
          }
          '''
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['products']['items'];
        setState(() {
          _products = data;
          _isLoading = false; // Stop loading
        });
      } else {
        print('Failed to load products');
        setState(() {
          _isLoading = false; // Stop loading on error
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
      ),
      body: _isLoading // Check loading state

          ? _buildShimmerLoader()
          : _products.isNotEmpty
              ? ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the details screen and pass the product ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(productId: product['id']),
                          ),
                        );
                      },
                      child: Container(
                        height: 120.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: ColorsCode.lightBlue,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            product['imgSrc'] != null
                                ? Image.network(
                                    product['imgSrc'],
                                    height: 100.h,
                                    width: 100.w,
                                  )
                                : SvgPicture.asset(
                                    ImagesPaths.logoImage,
                                    height: 90.h,
                                    width: 90.w,
                                  ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Text(
                                product['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text('No products available.')),
    );
  }

  // Shimmer Loader Widget
  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
    );
  }
}
