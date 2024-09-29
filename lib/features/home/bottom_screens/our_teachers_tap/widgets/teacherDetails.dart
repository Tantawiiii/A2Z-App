import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/language/language.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/images_paths.dart';
import '../../../../courses/ui/course_details_screen.dart';
import '../../../../get_courses_id_proudact/service/product_service.dart';
import '../../../../subscription_courses/ui/subscription_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final String? imageSrc;
  final String parentName;
  final String heroTag;

  const CategoryDetailsScreen({
    Key? key,
    required this.categoryName,
    required this.categoryId,
    this.imageSrc,
    required this.parentName,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
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
              Image.asset(
                ImagesPaths.imgNoSubscribe,
                fit: BoxFit.cover,
              ),
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
              child: Text(Language.instance.txtCancel()),
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
                    builder: (context) =>
                        SubscriptionScreen(courseId: courseId),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(_getProductsQuery(widget.categoryId)),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return _buildShimmerEffect();
          }

          if (result.data == null || result.data!['products'] == null) {
            return Center(child: Text('No products found.'));
          }

          final products = result.data!['products']['items'] as List;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: widget.imageSrc != null
                      ? Image.network(widget.imageSrc!,
                      fit: BoxFit.cover, height: 340.h)
                      : Image.asset(ImagesPaths.logoImage, height: 250),
                ),
                verticalSpace(16),
                Center(
                  child: Text(
                    widget.parentName,
                    style: TextStyles.font20BlueBold,
                  ),
                ),
                verticalSpace(16),
                _buildProductList(products),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? Colors.grey,
            highlightColor: Colors.grey[100] ?? Colors.white,
            child: Container(
              color: Colors.white,
              height: 300.h,
              width: double.infinity,
            ),
          ),
          verticalSpace(16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? Colors.grey,
            highlightColor: Colors.grey[100] ?? Colors.white,
            child: Container(
              color: Colors.white,
              height: 24.h,
              width: 150.w,
            ),
          ),
          verticalSpace(16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Dummy count for shimmer effect
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? Colors.grey,
                    highlightColor: Colors.grey[100] ?? Colors.white,
                    child: Container(
                      color: Colors.white,
                      width: 90.w,
                      height: 90.h,
                    ),
                  ),
                  title: Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? Colors.grey,
                    highlightColor: Colors.grey[100] ?? Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 16.h,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getProductsQuery(String categoryId) {
    return """
      query Products {
        products(
          storeId: "A2Z"
          filter: "category.subtree:912b6897-e648-4a97-ae94-f4e7f7097958/$categoryId"
        ) {
          items {
            id
            name
            imgSrc
          }
        }
      }
    """;
  }

  Widget _buildProductList(List products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Courses",
          style: TextStyles.font14BlueSemiBold,
        ),
        verticalSpace(8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 2,
              color: ColorsCode.lighterGray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: ColorsCode.backBottomNav,
                child: ListTile(
                  leading: product['imgSrc'] != null
                      ? Image.network(product['imgSrc'], width: 90, height: 90)
                      : Image.asset(
                    ImagesPaths.logoImage,
                    height: 90,
                    width: 90,
                  ),
                  title: Text(product['name']),
                  onTap: () => _checkSubscription(product['id']),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
