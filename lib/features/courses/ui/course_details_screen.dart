import 'dart:async';
import 'dart:io';

import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../a2z_app.dart';
import '../../../../core/language/language.dart';
import '../../../../core/networking/const/api_constants.dart';
import '../../../../core/utils/colors_code.dart';
import '../../../../core/utils/images_paths.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/FullScreenVideoPlayer.dart';

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

  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
    _resetOrientation();
    // start checker internet connection
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
            default:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });

  }
  void _resetOrientation() async {
    await SystemChrome.setPreferredOrientations([
   // DeviceOrientation.landscapeLeft,
   //    DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setState(() {

    });
  }
  // play YouTube Video
  void _playYouTubeVideo(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          hideControls: false,
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
            assets {
              id
              name
              url
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
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? DefaultTabController(
        length: 4, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text(_productDetails?['name'] ?? 'Product'),
            bottom: TabBar(
              tabs: [
                Tab(text: Language.instance.txtDetails()),
                Tab(text: Language.instance.txtVideos()),
                Tab(text: Language.instance.txtExams()),
                Tab(text: Language.instance.txtAttachment()),
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
                  : Center(
                      child: Text(
                        Language.instance.txtNoProducts(),
                      ),
                    ),
        ),
      )
      : const NoInternetScreen(),
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
          })
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
            Language.instance.txtEmptyExams(),
            style: TextStyles.font14BlueSemiBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentTab() {
    final assets = _productDetails?['assets'];

    if (assets == null || assets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "asset/images/no_doc.png",
              width: 290.w,
            ),
            verticalSpace(12),
            Text(
              Language.instance.txtEmptyDoc(),
              style: TextStyles.font14BlueSemiBold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return Bounce(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.attachment_outlined,
                  size: 24,
                  color: ColorsCode.mainBlue,
                ),
                horizontalSpace(16),
                Expanded(
                  child: Text(
                    asset['name'] ?? 'Unnamed Asset',
                    style: TextStyles.font16BlueSemiBold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    final url = asset['url'];
                    final name = asset['name'];

                    if (url != null && name != null) {
                      // Request storage permission
                      final status = await Permission.storage.request();

                      if (status.isGranted) {
                        try {
                          // Get the application's documents directory
                          final directory = await getApplicationDocumentsDirectory();
                          final filePath = '${directory.path}/$name';

                          print('Saving file to: $filePath');  // Print file path for verification

                          // Create Dio instance
                          final dio = Dio();

                          // Download the file
                          await dio.download(
                            url,
                            filePath,
                            onReceiveProgress: (received, total) {
                              if (total != -1) {
                                print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
                              }
                            },
                          );

                          // Verify the file existence
                          final fileExists = await File(filePath).exists();
                          if (fileExists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Downloaded $name to $filePath')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to save $name')),
                            );
                          }
                        } catch (e) {
                          // Handle error
                          print('Download error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to download $name')),
                          );
                        }
                      } else {
                        // Notify user of missing permissions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Storage permission required')),
                        );
                      }
                    } else {
                      print('Invalid URL or name.');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
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
            '${Language.instance.txtSection()} $sectionNumber',
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
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
