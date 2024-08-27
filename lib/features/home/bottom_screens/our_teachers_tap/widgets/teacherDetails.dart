import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/images_paths.dart';

class CategoryDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(_getProductsQuery(categoryId)),
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return _buildShimmerEffect(); // Replace the loading indicator with the Shimmer effect
          }

          final products = result.data!['products']['items'] as List;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Hero(
                  tag: heroTag,
                  child: imageSrc != null
                      ? Image.network(imageSrc!, fit: BoxFit.cover, height: 300.h)
                      : SvgPicture.asset(ImagesPaths.logoImage, height: 250),
                ),
                verticalSpace(16),
                Text(
                  parentName,
                  style: TextStyles.font20BlueBold,
                ),
                verticalSpace(16),
                Expanded(child: _buildProductList(products)),
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
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
              height: 300.h,
              width: double.infinity,
            ),
          ),
          verticalSpace(16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
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
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      width: 90.w,
                      height: 90.h,
                    ),
                  ),
                  title: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
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
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product['imgSrc'] != null
                    ? Image.network(product['imgSrc'], width: 90, height: 90)
                    : SvgPicture.asset(
                  ImagesPaths.logoImage,
                  height: 90.h,
                  width: 90.w,
                ),
                title: Text(product['name']),
              );
            },
          ),
        ),
      ],
    );
  }
}