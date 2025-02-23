import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import '../controller/story_controller.dart';
import '../models/story_model.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isAsset;

  const VideoPlayerWidget(
      {super.key, required this.videoUrl, this.isAsset = false});

  @override
  State<StatefulWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  final StoryController storyController = Get.find<StoryController>();

  @override
  void initState() {
    super.initState();
    _controller = widget.isAsset
        ? VideoPlayerController.asset(widget.videoUrl)
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _controller.addListener(() {
      if (_controller.value.isInitialized) {}
      if (_controller.value.position == _controller.value.duration) {
        storyController.nextStory();
      }
    });

    bool isRunning = storyController.playing && storyController.isEnabled;
    if (isRunning) {
      storyController.progress.value = 0;
      storyController.pause();
    }
    _controller.initialize().then((_) {
      if (isRunning) {
        storyController.currentStoryDuration = _controller.value.duration;
        storyController.stories[storyController.currentIndex.value].duration =
            _controller.value.duration;

        storyController.startProgress(_controller.value.duration);
        storyController.play();
        _controller.play();
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (storyController.isPlaying.value) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
