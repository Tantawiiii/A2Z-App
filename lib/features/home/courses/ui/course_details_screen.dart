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
  void _playVideo(String contentUrl) {
    // Create a VideoPlayerController
    final controller = VideoPlayerController.network(contentUrl);

    showDialog(
      context: context,
      builder: (context) {
        // Initialize the controller
        controller.initialize().then((_) {
          // Update the state to rebuild the dialog with the video player
          setState(() {});
        });

        return AlertDialog(
          title: const Text('Video'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: VideoPlayer(controller),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                controller.dispose();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow,color: Colors.redAccent,),
            onPressed: () {
              _playVideo(video['contentUrl']);
            },
          ),
        );
      }).toList(),
    );
  }



  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

}
