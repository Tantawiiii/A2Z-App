import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideoPlayer extends StatelessWidget {
  final YoutubePlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Disable screenshots and screen recording
    _disableScreenRecording();

    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ),
      ),
      backgroundColor: Colors.white54,
    );
  }

  void _disableScreenRecording() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
