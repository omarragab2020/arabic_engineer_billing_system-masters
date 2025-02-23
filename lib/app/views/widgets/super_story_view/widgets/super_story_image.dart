import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:neuss_utils/image_utils/src/img_helpers.dart';

import '../controller/super_story_controller.dart';
import '../super_utils.dart';

/// Utitlity to load image (gif, png, jpg, etc) media just once. Resource is
/// cached to disk with default configurations of [DefaultCacheManager].
class SuperImageLoader {
  ui.Codec? frames;

  String? url;
  String? asset;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading; // by default

  SuperImageLoader({this.url, this.asset, this.requestHeaders}) : assert(url != null || asset != null);

  /// Load image from disk cache first, if not found then load from network.
  /// `onComplete` is called when [imageBytes] become available.
  Future<void> loadImage(VoidCallback onComplete) async {
    if (frames != null) {
      state = LoadState.success;
      onComplete();
    }

    if (url != null) {
      final fileStream = DefaultCacheManager().getFileStream(url!, headers: requestHeaders as Map<String, String>?);

      fileStream.listen(
        (fileResponse) {
          if (fileResponse is! FileInfo) return;
          if (frames != null) {
            return;
          }

          final imageBytes = fileResponse.file.readAsBytesSync();

          state = LoadState.success;

          ui.instantiateImageCodec(imageBytes).then((codec) {
            frames = codec;
            onComplete();
          }, onError: (error) {
            state = LoadState.failure;
            onComplete();
          });
        },
        onError: (error) {
          state = LoadState.failure;
          onComplete();
        },
      );
    } else if (asset != null) {
      var assetCodec = await getCodecFromAsset(asset!);
      if (assetCodec != null) {
        state = LoadState.success;
        frames = assetCodec;
        onComplete();
      } else {
        state = LoadState.failure;
        onComplete();
      }
    }
  }
}

/// Widget to display animated gifs or still images. Shows a loader while image
/// is being loaded. Listens to playback states from [controller] to pause and
/// forward animated media.
class SuperStoryImage extends StatefulWidget {
  final SuperImageLoader imageLoader;

  final BoxFit? fit;

  final SuperStoryController? controller;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  SuperStoryImage(
    this.imageLoader, {
    Key? key,
    this.controller,
    this.fit,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key ?? UniqueKey());

  /// Use this shorthand to fetch images/gifs from the provided [url]
  factory SuperStoryImage.url(
    String url, {
    SuperStoryController? controller,
    Map<String, dynamic>? requestHeaders,
    BoxFit fit = BoxFit.fitWidth,
    Widget? loadingWidget,
    Widget? errorWidget,
    Key? key,
  }) {
    return SuperStoryImage(
      SuperImageLoader(
        url: url,
        requestHeaders: requestHeaders,
      ),
      controller: controller,
      fit: fit,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      key: key,
    );
  }

  /// Use this shorthand to fetch images/gifs from the provided [asset]
  factory SuperStoryImage.asset(
    String asset, {
    SuperStoryController? controller,
    Map<String, dynamic>? requestHeaders,
    BoxFit fit = BoxFit.fitWidth,
    Widget? loadingWidget,
    Widget? errorWidget,
    Key? key,
  }) {
    return SuperStoryImage(
      SuperImageLoader(
        asset: asset,
      ),
      controller: controller,
      fit: fit,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      key: key,
    );
  }

  @override
  State<StatefulWidget> createState() => SuperStoryImageState();
}

class SuperStoryImageState extends State<SuperStoryImage> {
  ui.Image? currentFrame;

  Timer? _timer;

  StreamSubscription<PlaybackState>? _streamSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _streamSubscription = widget.controller!.playbackNotifier.listen((playbackState) {
        // for the case of gifs we need to pause/play
        if (widget.imageLoader.frames == null) {
          return;
        }

        if (playbackState == PlaybackState.pause) {
          _timer?.cancel();
        } else {
          forward();
        }
      });
    }

    widget.controller?.pause();

    widget.imageLoader.loadImage(() async {
      if (mounted) {
        if (widget.imageLoader.state == LoadState.success) {
          widget.controller?.play();
          forward();
        } else {
          // refresh to show error
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void forward() async {
    _timer?.cancel();

    if (widget.controller != null && widget.controller!.playbackNotifier.stream.value == PlaybackState.pause) {
      return;
    }

    final nextFrame = await widget.imageLoader.frames!.getNextFrame();

    currentFrame = nextFrame.image;

    if (nextFrame.duration > Duration(milliseconds: 0)) {
      _timer = Timer(nextFrame.duration, forward);
    }

    setState(() {});
  }

  Widget getContentView() {
    switch (widget.imageLoader.state) {
      case LoadState.success:
        return RawImage(
          image: currentFrame,
          fit: widget.fit,
        );
      case LoadState.failure:
        return Center(
            child: widget.errorWidget ??
                Text(
                  "Image failed to load.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ));
      default:
        return Center(
          child: widget.loadingWidget ??
              Container(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: getContentView(),
    );
  }
}
