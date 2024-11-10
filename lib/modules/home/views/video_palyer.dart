import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  bool _isVideoInitialized = false;
  CustomVideoPlayerController? _customVideoPlayerController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (!_isDisposed) {
          setState(() {
            _isVideoInitialized = true;
          });
          _customVideoPlayerController = CustomVideoPlayerController(
            context: context,
            videoPlayerController: _controller,
          );
        }
      });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _customVideoPlayerController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoInitialized ? CustomVideoPlayer(
      customVideoPlayerController: _customVideoPlayerController!,
    ) : const Center(
      child: SpinKitWave(
        color: btnColor,
        size: 50.0,
      ),
    );
  }
}
