import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/utils/colors_code.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final YoutubePlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool isFullScreen = false; // Track fullscreen mode

  @override
  void initState() {
    super.initState();
    _disableScreenRecording();

    // Listen for fullscreen changes
    widget.controller.addListener(() {
      if (widget.controller.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = widget.controller.value.isFullScreen;
        });

        // Adjust the orientation when entering or exiting fullscreen
        if (isFullScreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      }
    });
  }

  @override
  void dispose() {
    // Reset orientation to portrait before disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: isFullScreen ? 0.84: 1.0, // Zoom in when fullscreen
          child: YoutubePlayer(
            controller: widget.controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: ColorsCode.mainBlue,
              handleColor: ColorsCode.darkBlue,
            ),
            onReady: () {
              // Automatically enter fullscreen when video starts
              widget.controller.toggleFullScreenMode();
            },
          ),
        ),
      ),
      backgroundColor: Colors.white54,
    );
  }

  void _disableScreenRecording() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
