import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/networking/const/api_constants.dart';
import '../../../../core/utils/colors_code.dart';
import '../../../../core/utils/images_paths.dart';
import '../../widgets/FullScreenVideoPlayer.dart';

class CoursesDetailsScreen extends StatefulWidget {
  final String productId;

  const CoursesDetailsScreen({super.key, required this.productId});

  @override
  _CoursesDetailsScreenState createState() => _CoursesDetailsScreenState();
}

class _CoursesDetailsScreenState extends State<CoursesDetailsScreen> {
  Map<String, dynamic>? _productDetails;
  bool _isLoading = true;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  void _playYouTubeVideo(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      // Navigate to the full screen video player
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FullScreenVideoPlayer(controller: _youtubeController!),
        ),
      );
    } else {
      print("Invalid YouTube URL.");
    }
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
              descriptions {
                  content
                 }
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

        print("data: ${response.data['data']['product']}");
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
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(_productDetails?['name'] ?? 'Loading...'),
          bottom: const TabBar(
            tabs: [
              Tab(text: StringTextsNames.txtDetails),
              Tab(text: StringTextsNames.txtVideos),
              Tab(text: StringTextsNames.txtExams),
              Tab(text: StringTextsNames.txtAttachment),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _productDetails != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TabBarView(
                      children: [
                        _buildDetailsTab(),
                        _buildVideoList(),
                        _buildExamsTab(),
                        _buildAttachmentTab(),
                      ],
                    ),
                  )
                : const Center(child: Text(StringTextsNames.txtNoProducts)),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _productDetails!['imgSrc'] != null
                ? Image.network(
                    _productDetails!['imgSrc'],
                    fit: BoxFit.cover,
                  )
                : SvgPicture.asset(
                    ImagesPaths.logoImage,
                  ),
            verticalSpace(16),
            Text(
              _productDetails!['name'] ?? 'Product Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            verticalSpace(16),
          ],
        ),
        if (_productDetails!['descriptions'] != null &&
            (_productDetails!['descriptions'] as List).isNotEmpty)
          ...(_productDetails!['descriptions'] as List).map<Widget>((desc) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                desc['content'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList()
      ],
    );
  }

  Widget _buildExamsTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagesPaths.imgEmptyExam,
            width: 290.w,
          ),
          verticalSpace(12),
          Text(
            StringTextsNames.txtEmptyExams,
            style: TextStyles.font14BlueSemiBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagesPaths.imgEmptyExam,
            width: 290.w,
          ),
          verticalSpace(12),
          Text(
            StringTextsNames.txtEmptyExams,
            style: TextStyles.font14BlueSemiBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    final videos =
        List<Map<String, dynamic>>.from(_productDetails!['videos']['items']);

    // Sort videos by 'sortOrder'
    videos.sort(
        (a, b) => (a['sortOrder'] as int).compareTo(b['sortOrder'] as int));

    Map<int, List<Map<String, dynamic>>> sections = {};

    // Group videos by section
    for (var video in videos) {
      int sectionNumber = video['sortOrder'];
      if (!sections.containsKey(sectionNumber)) {
        sections[sectionNumber] = [];
      }
      sections[sectionNumber]!.add(video);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.entries.map((entry) {
        int sectionNumber = entry.key;
        List<Map<String, dynamic>> sectionVideos = entry.value;

        return ExpansionTile(
          title: Text(
            'Section $sectionNumber',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: sectionVideos.map((video) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  video['thumbnailUrl'] != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              video['thumbnailUrl'],
                              width: 120,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.play_circle_outline_sharp,
                                color: ColorsCode.mainBlue,
                                size: 50,
                              ),
                              onPressed: () {
                                _playYouTubeVideo(video['contentUrl']);
                              },
                            ),
                          ],
                        )
                      : const Icon(Icons.video_collection),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      video['name'] ?? 'Unnamed Video',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }
}
