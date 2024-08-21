import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/networking/const/api_constants.dart';
import '../../../../core/utils/images_paths.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Map<String, dynamic>? _productDetails;
  bool _isLoading = true;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.apiBaseUrlGraphQl,
        data: {
          'query': '''
          query Product {
            product(id: "${widget.productId}", storeId: "A2Z") {
              id
              productType
              name
              imgSrc
              videos {
                totalCount
                items {
                  name
                  description
                  uploadDate
                  thumbnailUrl
                  contentUrl
                  sortOrder
                }
              }
            }
          }
          '''
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['product'];
        setState(() {
          _productDetails = data;
          _isLoading = false;
        });

        // Initialize the video player with the first video's content URL, if available
        if (_productDetails!['videos']['totalCount'] > 0) {
          _initializeVideoPlayer(_productDetails!['videos']['items'][0]['contentUrl']);
        }
      } else {
        print('Failed to load product details');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeVideoPlayer(String contentUrl) {
    _videoController = VideoPlayerController.network(contentUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play(); // Auto-play the video
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productDetails?['name'] ?? 'Loading...'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _productDetails != null
          ? Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              children: [
                _productDetails!['imgSrc'] != null
                    ? Image.network(
                  _productDetails!['imgSrc'],
                  width: 150,
                  height: 100,
                )
                    : SvgPicture.asset(
                  ImagesPaths.logoImage,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _productDetails!['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Display video player if initialized
            _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
                : const SizedBox.shrink(),
            SizedBox(height: 20.h),
            // Display list of videos with play buttons
            _buildVideoList(),
          ],
        ),
      )
          : const Center(child: Text('Product not found.')),
    );
  }

  Widget _buildVideoList() {
    final videos = _productDetails!['videos']['items'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: videos.map((video) {
        return ListTile(
          leading: video['thumbnailUrl'] != null
              ? Image.network(video['thumbnailUrl'], width: 50, height: 50)
              : const Icon(Icons.video_collection),
          title: Text(video['name'] ?? 'Unnamed Video'),
          onTap: () {
            _initializeVideoPlayer(video['contentUrl']);
          },
        );
      }).toList(),
    );
  }
}
