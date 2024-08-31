import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/images_paths.dart';



class ProductItemTile extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductItemTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final categoryName = product['category']?['name'] ?? 'Unknown Category';

    return Card(
      elevation: 1.5,
      shadowColor: Colors.cyan,
      child: Container(
        height: 120.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
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
              fit: BoxFit.cover,
              width: 120,
              height: 100,
            )
                : SvgPicture.asset(
              ImagesPaths.logoImage,
              height: 90.h,
              width: 90.w,
            ),
            SizedBox(width: 16.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product['name'],
                  style: TextStyles.font20BlueBold,
                ),
                horizontalSpace(8),
                Text(
                  categoryName,
                  style: TextStyles.font18BlueSemiBold,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}