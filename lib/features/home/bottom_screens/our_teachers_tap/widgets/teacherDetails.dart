import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/images_paths.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String categoryName;
  final String categoryId; // Add categoryId

  const CategoryDetailsScreen({Key? key, required this.categoryName, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(_getProductsQuery(categoryId)), // Use the query with the categoryId
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = result.data!['products']['items'] as List;

          return _buildProductList(products);
        },
      ),
    );
  }

  // GraphQL query to get products based on categoryId
  String _getProductsQuery(String categoryId) {
    return """
      query Products {
        products(
          storeId: "A2Z"
          filter: "category.subtree:f45c955e-f00e-4c99-96d3-b20bd8b48986/$categoryId"
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         Text("Courses",style: TextStyles.font15DarkBlueMedium,),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product['imgSrc'] != null ? Image.network(product['imgSrc'], width: 90, height: 90) : SvgPicture.asset(
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
