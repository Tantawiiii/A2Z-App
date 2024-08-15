
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return Container(
          height: 160.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  width: 140.w,
                  height: 100.h,
                  color: Colors.white,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 150.w,
                        height: 20.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
