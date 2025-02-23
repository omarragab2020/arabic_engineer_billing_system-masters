import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/widgets.dart';

import '../../../../core/routes/app_pages.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../controllers/app_controller.dart';
import '../home/screens/main_screen.dart';

class WelcomeView extends GetView<AppController> {
  WelcomeView({super.key});

  final _activeStep = 2.obs;

  int get activeStep => _activeStep.value;

  set activeStep(int val) => _activeStep.value = val;

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      // backgroundColor: AppColors.appBlackBG,
      // decorationImage: appBgImg,
      // gradient: appMainGradient,
      showBackBtn: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // vSpace64,
            SuperImageView(
              imgAssetPath: AppAssets.appIcon,
              width: double.infinity,
              height: Get.height * 0.3,
              fit: BoxFit.fitHeight,
            ),
            vSpace32,
            SizedBox(
              height: 0.3.h,
              width: double.infinity,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (DragEndDetails details) {
                  if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                    mPrint('right');
                    if (activeStep < 2) activeStep = activeStep + 1;
                  } else if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                    mPrint('left');
                    if (activeStep > 0) activeStep--;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Obx(() {
                        return Txt(AppStrings.welcomeHints[2 - activeStep], fontSize: 18);
                      }),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Obx(() {
                        return DotStepper(
                          // direction: Axis.vertical,
                          dotCount: 3,
                          dotRadius: 12,
                          tappingEnabled: false,
                          activeStep: activeStep,
                          shape: Shape.pipe,
                          spacing: 10,
                          indicator: Indicator.shift,
                          indicatorDecoration:  IndicatorDecoration(color: AppColors.appMainColor),
                          lineConnectorDecoration:  LineConnectorDecoration(color: AppColors.appMainColor),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: LanguageService.to.alignmentReverse,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: IconButton(
                  color: Colors.white,
                  style:  ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.appMainColor)),
                  onPressed: () {
                    if (activeStep > 0) {
                      activeStep--;
                    } else {
                      Get.toNamed(Routes.LOGIN);
                    }
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 40,
                  ),
                ),
              ),
            ),
            vSpace32,
          ],
        ),
      ),
    );
  }

  void submitSignUp() {
    controller.isGuest = false;
    Get.toNamed(Routes.SIGNUP);
  }

  void submitLogin() {
    controller.isGuest = false;
    Get.toNamed(Routes.LOGIN);
  }

  void signInAsAGuest() {
    controller.isGuest = true;
    Get.to(() => const MainScreen());
    mShowToast("Welcome guest");
  }
}
