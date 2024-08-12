import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildBannersView extends StatelessWidget {
  const BuildBannersView({super.key, required this.banners});

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isNotEmpty) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.network(
                banners[index],
                fit: BoxFit.cover,
                width: 300,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4, // Placeholder item count
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
                },
              ),
            );
          },
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:4, // Placeholder item count
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
}
