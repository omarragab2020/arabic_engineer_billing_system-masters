import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import '../controller/story_controller.dart';

class StoryProgressBar extends StatelessWidget {
  final int index;
  final double height;
  final Color valueColor, backgroundColor;

  const StoryProgressBar({super.key, this.height = 4, required this.index, this.valueColor = Colors.white, this.backgroundColor = Colors.white30});

  @override
  Widget build(BuildContext context) {
    final storyController = Get.find<StoryController>();

    return Obx(() {
      if (storyController.currentIndex.value == index) {
        return LinearProgressIndicator(
          value: storyController.progress.value,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          backgroundColor: backgroundColor,
          borderRadius: 8.borderRadius,
          minHeight: height,
        );
      } else if (storyController.currentIndex.value > index) {
        return LinearProgressIndicator(
          value: 1.0,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          backgroundColor: backgroundColor,
          borderRadius: 8.borderRadius,
          minHeight: height,
        );
      } else {
        return LinearProgressIndicator(
          value: 0.0,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          backgroundColor: backgroundColor,
          borderRadius: 8.borderRadius,
          minHeight: height,
        );
      }
    });
  }
}
