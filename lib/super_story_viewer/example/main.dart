import 'package:flutter/material.dart';

import '../src/models/story_model.dart';
import '../src/widgets/story_viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Story Viewer Example',
      home: StoryViewerExample(),
    );
  }
}

class StoryViewerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<StoryModel> stories = [
      StoryModel(
        url: 'https://via.placeholder.com/400',
        type: StoryType.image,
        duration: Duration(seconds: 5),
      ),
      StoryModel(
        asset: 'assets/video.mp4',
        type: StoryType.video,
        duration: Duration(seconds: 10),
      ),
      StoryModel(
        text: 'This is a text story!',
        type: StoryType.text,
        duration: Duration(seconds: 5),
      ),
    ];

    return Scaffold(
      body: StoryViewer(stories: stories),
    );
  }
}
