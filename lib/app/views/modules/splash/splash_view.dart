import 'package:almuandes_billing_system/app/views/widgets/super_story_view/controller/super_story_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../core/routes/app_pages.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../super_story_viewer/src/controller/story_controller.dart';
import '../../../../super_story_viewer/src/models/story_model.dart';
import '../../../../super_story_viewer/src/widgets/story_viewer.dart';
import '../../../controllers/app_controller.dart';
import '../../widgets/super_story_view/controller/super_story_controller.dart';
import '../../widgets/super_story_view/widgets/super_story_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late List<StoryModel> stories;

  bool enabled = false;

  Widget caption(int ind) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SuperImageView(
            imgAssetPath: AppAssets.appIcon,
            width: 0.45.w,
            height: 0.3.w,
            // color: Colors.white,
          ),
          vSpace16,
          const Txt("Specialized in Turn-Key MEP solutions",
              textAlign: TextAlign.justify,
              color: Colors.white,
              fontSize: 22,
              isBold: true),
          vSpace16,
          const Divider(thickness: 2, height: 2, color: Colors.white30),
          vSpace16,
          const Txt(
              "Perfect synergy of precise engineering, top quality products and commitment to service delivery",
              color: Colors.white,
              fontSize: 20,
              textAlign: TextAlign.justify,
              isBold: true),
          vSpace16,
          Row(
            children: <Widget>[
              FilledButton(
                  onPressed: () {
                    mPrint2('FilledButton');
                    Get.offNamed(Routes.SIGNUP);
                  },
                  child: const Txt("Register", color: Colors.white)),
              hSpace16,
              OutlinedButton(
                  onPressed: () {
                    mPrint2('OutlinedButton');
                    Get.offNamed(Routes.LOGIN);
                  },
                  child: const Txt("Login", color: Colors.white)),
            ],
          ),
          vSpace8,
          TextButton(
              onPressed: () {
                enabled = false;
                storyController.dispose();
                setState(() {});
                AppController.to.continueAsGuest();
              },
              child: const Txt("Continue as guest",
                  underlined: true,
                  underlineHeight: 4,
                  decorationColor: Colors.white,
                  color: Colors.white,
                  fontSize: 20)),
          // vSpace32,
        ],
      );

  void initStories() {
    stories = [
      StoryModel(
        asset: AppAssets.board1,
        type: StoryType.image,
        duration: const Duration(seconds: 6),
        captionWidget: caption(1),
      ),
      StoryModel(
        asset: AppAssets.board2,
        type: StoryType.image,
        duration: const Duration(seconds: 6),
        captionWidget: caption(2),
        captionTxt: 'caption',
      ),
      StoryModel(
        asset: AppAssets.board3,
        type: StoryType.image,
        duration: const Duration(seconds: 6),
        captionWidget: caption(3),
      ),
      StoryModel(
        asset: AppAssets.board4,
        type: StoryType.video,
        duration: const Duration(seconds: 6),
        captionWidget: caption(4),
      ),
    ];
  }

  transitFunction() async {
    return;
    AppController controller = AppController.to;
    Get.offAllNamed(
        controller.successfullyLoggedIn ? Routes.HOME : Routes.LOGIN);
    if (!controller.isConnected) {
      Get.offAllNamed(Routes.NOCONNECTION);
    }
  }

  StoryController storyController = StoryController();

  @override
  void initState() {
    initStories();
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      GetNumUtils(1).seconds.delay(() async {
        await AppController.to.requestPermissions([Permission.notification]);
        // await AppController.to.requestStoragePermissions();
        enabled = true;
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // backgroundColor: const Color(0xFF00052D),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StoryViewer(
              storyController: storyController,
              stories: stories,
              enabled: enabled,
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Txt('Powered by @Neuss for App Development',
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
