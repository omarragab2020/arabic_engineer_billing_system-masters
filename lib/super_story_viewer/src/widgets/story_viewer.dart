import 'package:almuandes_billing_system/app/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/home.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:video_player/video_player.dart';
import '../controller/story_controller.dart';
import '../models/story_model.dart';
import 'story_progress_bar.dart';
import 'video_player_widget.dart';

class StoryViewer extends StatelessWidget {
  late final StoryController storyController;

  final double progressBarTopMargin;
  final double progressBarHeight;
  final bool enabled;
  final Color? valueColor, backgroundColor;

  StoryViewer(
      {super.key,
      required List<StoryModel> stories,
      this.progressBarTopMargin = kToolbarHeight + 20,
      this.progressBarHeight = 4,
      this.valueColor,
      this.backgroundColor,
      StoryController? storyController,
      this.enabled = true,
      Function(int index)? onPageChanged,
      Function()? onComplete}) {
    this.storyController = Get.put(storyController ?? StoryController());
    this.storyController.enabled.value = enabled;
    this.storyController.onPageChanged = onPageChanged ??
        (index) {
          mPrint2('onPageChanged: $index');
        };
    this.storyController.onComplete = onComplete ??
        () {
          mPrint2('onCompleted');
        };
    this.storyController.addStories(stories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final story =
            storyController.stories[storyController.currentIndex.value];
        return InkWell(
          onTapDown: (details) => _onTapDown(details, context),
          onLongPress: storyController.togglePlayPause,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  left: 16,
                  right: 16,
                  top: 0.15.h,
                  bottom: 0.45.h,
                  child: _buildStoryContent(story)),
              // Positioned.fill(child: _buildStoryContent(story)),
              Positioned(
                top: progressBarTopMargin,
                left: 10,
                right: 10,
                child: Row(
                  children: storyController.stories.map((s) {
                    int index = storyController.stories.indexOf(s);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: StoryProgressBar(
                          index: index,
                          height: progressBarHeight,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (story.captionTxt != null || story.captionWidget != null)
                Align(
                    alignment: LanguageService.to.alignmentBottom,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: story.captionWidget ??
                          Txt(
                            story.captionTxt,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                    ))
              // Positioned(
              //   top: 60,
              //   left: 20,
              //   child: IconButton(
              //     icon: Icon(Icons.close, color: Colors.white),
              //     onPressed: () => Navigator.of(context).pop(),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStoryContent(StoryModel story) {
    switch (story.type) {
      case StoryType.image:
        return _buildImage(story);
      case StoryType.video:
        return _buildVideo(story);
      case StoryType.text:
        return _buildText(story);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImage(StoryModel story) {
    return SuperImageView(
      imgAssetPath: story.asset,
      imgUrl: story.url,
      fit: story.boxFit,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildVideo(StoryModel story) {
    return VideoPlayerWidget(
      videoUrl: (story.url ?? story.asset)!,
      isAsset: story.asset != null,
    );
  }

  Widget _buildText(StoryModel story) {
    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Txt(
            story.text ?? '',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      storyController.previousStory();
    } else if (dx > 2 * screenWidth / 3) {
      storyController.nextStory();
    } else {
      storyController.togglePlayPause();
    }
  }
}
