import 'package:flutter/material.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../super_story_view.dart';

class SuperStoryItem extends StoryItem {
  SuperStoryItem(super.view, {required super.duration, super.shown});

  factory SuperStoryItem.pageImageAsset({
    required String asset,
    required SuperStoryController controller,
    Key? key,
    BoxFit imageFit = BoxFit.fitWidth,
    Widget? caption,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
    Widget? loadingWidget,
    Widget? errorWidget,
    EdgeInsetsGeometry? captionOuterPadding,
    Duration? duration,
  }) {
    return SuperStoryItem(
      Container(
        key: key,
        // color: Colors.black,
        child: Stack(
          children: <Widget>[
            SuperStoryImage.asset(
              asset,
              controller: controller,
              fit: imageFit,
              requestHeaders: requestHeaders,
              loadingWidget: loadingWidget,
              errorWidget: errorWidget,
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: captionOuterPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                  child: caption ?? const SizedBox.shrink(),
                ),
              ),
            )
          ],
        ),
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shorthand for creating inline image. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory SuperStoryItem.inlineImage({
    required String url,
    Widget? caption,
    required SuperStoryController controller,
    Key? key,
    BoxFit imageFit = BoxFit.cover,
    Map<String, dynamic>? requestHeaders,
    bool shown = false,
    bool roundedTop = true,
    bool roundedBottom = false,
    Widget? loadingWidget,
    Widget? errorWidget,
    EdgeInsetsGeometry? captionOuterPadding,
    Duration? duration,
  }) {
    return SuperStoryItem(
      ClipRRect(
        key: key,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(roundedTop ? 8 : 0),
          bottom: Radius.circular(roundedBottom ? 8 : 0),
        ),
        child: Container(
          color: Colors.grey[100],
          child: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                SuperStoryImage.url(
                  url,
                  controller: controller,
                  fit: imageFit,
                  requestHeaders: requestHeaders,
                  loadingWidget: loadingWidget,
                  errorWidget: errorWidget,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: captionOuterPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      child: caption ?? const SizedBox.shrink(),
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
