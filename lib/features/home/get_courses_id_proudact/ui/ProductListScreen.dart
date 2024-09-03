import 'package:a2z_app/core/language/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/images_paths.dart';
import '../../../subscription_courses/ui/subscription_screen.dart';
import '../../courses/ui/course_details_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchProducts();
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
        _showNoSubscriptionDialog(productId); // Pass productId here
      }
    } catch (e) {
      print('Error checking subscription: $e');
      _showNoSubscriptionDialog(productId); // Pass productId here
    }
  }

  void _showNoSubscriptionDialog(String courseId) { // Add parameter here
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
                Language.instance.txtSubscribe(),
                style: TextStyles.font14DarkBlueBold,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Subscribe',
                  style: TextStyles.font14BlueSemiBold),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Pass courseId to SubscriptionScreen
                    builder: (context) => SubscriptionScreen(courseId: courseId),
                  ),

                );
                print("courseId: "+courseId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
