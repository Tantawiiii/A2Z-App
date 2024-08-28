import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/colors_code.dart';
import '../../../core/utils/images_paths.dart';

class ProductItemTile extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductItemTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            fit: BoxFit.cover,
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
