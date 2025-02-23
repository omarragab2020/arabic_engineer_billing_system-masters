import 'package:get/get.dart';
import 'dart:async';
import '../models/story_model.dart';

class StoryController extends GetxController {
  RxList<StoryModel> stories = <StoryModel>[].obs;
  RxInt currentIndex = 0.obs;
  RxBool isPlaying = true.obs;
  RxDouble progress = 0.0.obs;
  Timer? progressTimer;
  late Duration currentStoryDuration;
  double progressIncrement = 0.0;
  RxBool enabled = true.obs; // Flag to enable or disable the story viewer

  // Callbacks
  Function(int index)? onPageChanged;
  Function()? onComplete;

  void addStories(List<StoryModel> newStories) {
    stories.assignAll(newStories);
    currentIndex.value = 0;
    if (enabled.value) {
      _startProgress();
    }
  }

  void nextStory() {
    if (!enabled.value) return; // Check if viewer is enabled

    if (currentIndex.value < stories.length - 1) {
      currentIndex.value++;
      _resetProgress();
      isPlaying.value = true;
      onPageChanged?.call(currentIndex.value); // Trigger page changed callback
    } else {
      isPlaying.value = false;
      onComplete?.call(); // Trigger completion callback
    }
  }

  void previousStory() {
    if (!enabled.value) return; // Check if viewer is enabled

    if (currentIndex.value > 0) {
      isPlaying.value = true;
      currentIndex.value--;
      _resetProgress(); // Reset progress for the new story
      onPageChanged?.call(currentIndex.value); // Trigger page changed callback
    }
  }

  void togglePlayPause() {
    if (!enabled.value) return; // Check if viewer is enabled

    isPlaying.value = !isPlaying.value; // Toggle play/pause
  }

  bool get isEnabled => enabled.value;

  bool get paused => !isPlaying.value;

  bool get playing => isPlaying.value;

  void pause() {
    if (!isEnabled) return; // Check if viewer is enabled
    isPlaying.value = false; // Toggle play/pause
  }

  void play() {
    if (!isEnabled) return; // Check if viewer is enabled
    isPlaying.value = true; // Toggle play/pause
  }

  void _startProgress() {
    progressTimer?.cancel(); // Cancel any existing timer

    final totalDuration = stories[currentIndex.value].duration;
    const interval = Duration(milliseconds: 50);
    final storyDuration = totalDuration!.inMilliseconds.toDouble();
    final steps = storyDuration / interval.inMilliseconds;
    progressIncrement = 1.0 / steps;

    progressTimer = Timer.periodic(interval, (timer) {
      if (!isPlaying.value) {
        return;
      }

      // Increment progress
      progress.value += progressIncrement;

      if (progress.value >= 1.0) {
        progress.value = 1.0; // Ensure progress does not exceed 1.0
        nextStory();
        timer.cancel();
      }
    });
  }

  void startProgress(Duration totalDuration) {
    progressTimer?.cancel(); // Cancel any existing timer
    progress.value = 0;

    const Duration interval = Duration(milliseconds: 50);
    final double storyDuration = totalDuration.inMilliseconds.toDouble();
    final double steps = storyDuration / interval.inMilliseconds;
    progressIncrement = 1.0 / steps;

    progressTimer = Timer.periodic(interval, (timer) {
      if (!isPlaying.value) {
        return;
      }

      // Increment progress
      progress.value += progressIncrement;

      if (progress.value >= 1.0) {
        progress.value = 1.0; // Ensure progress does not exceed 1.0
        nextStory();
        timer.cancel();
      }
    });
  }

  void _resetProgress() {
    if (!enabled.value) return; // Check if viewer is enabled
    progressTimer?.cancel(); // Cancel any existing timer
    progress.value = 0.0; // Reset progress to start of the new story
    _startProgress(); // Start the new story
  }
}
