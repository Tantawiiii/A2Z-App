import 'dart:async';

import 'package:a2z_app/core/language/language.dart';
import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../a2z_app.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/images_paths.dart';
import '../../courses/ui/course_details_screen.dart';
import '../../subscription_courses/ui/subscription_screen.dart';
import '../service/product_service.dart';
import '../widget/product_item_tile.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;

  const ProductListScreen({super.key, required this.categoryId});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _fetchProducts();


    // start checker internet connection
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
            default:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });

  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ProductService.fetchProducts(widget.categoryId);
      setState(() {
        _products = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkSubscription(String productId) async {
    try {
      final success = await ProductService.checkSubscription(productId);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoursesDetailsScreen(productId: productId),
          ),
        );
      } else {
        _showNoSubscriptionDialog(productId);
      }
    } catch (e) {
      print('Error checking subscription: $e');
      _showNoSubscriptionDialog(productId);
    }
  }

  void _showNoSubscriptionDialog(String courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImagesPaths.imgNoSubscribe, fit: BoxFit.cover,),
              SizedBox(height: 10.h),
              Text(
                Language.instance.txtEmptySubscription(),
                style: TextStyles.font14DarkBlueBold,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              child:  Text(Language.instance.txtCancel()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(Language.instance.txtSubscribe(),
                  style: TextStyles.font14BlueSemiBold),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionScreen(courseId: courseId),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
        appBar: AppBar(
          title: Text(
            Language.instance.txtCourses(),
            style: TextStyles.font18DarkBlueMedium,
          ),
          backgroundColor: Colors.white,
        ),
        body: _isLoading
            ? _buildShimmerLoader()
            : _products.isNotEmpty
                ? ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return GestureDetector(
                        onTap: () => _checkSubscription(product['id']),
                        child: ProductItemTile(product: product),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      children: [
                        Image.asset(
                          ImagesPaths.imgEmptyCourses,
                          width: 250.w,
                        ),
                        verticalSpace(20.h),
                        Text(
                          Language.instance.txtNoProductsAval(),
                          style: TextStyles.font13GrayNormal,
                        ),
                      ],
                    ),
                  ),
      )
      : const NoInternetScreen(),
    );
  }

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
