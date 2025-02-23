import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/widgets.dart';

import '../../../../core/routes/app_pages.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../home/screens/main_screen.dart';

class LanguageSelectView extends GetView<AppController> {
  LanguageSelectView({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
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
              vSpace64,
              const Txt('Please choose language', fontSize: 20, fontWeight: FontWeight.w900),
              vSpace32,
              AppButton(
                size: Size(0.8.w, 60),
                onPressed: () {
                  LanguageService.to.updateLanguageToEnglish();
                  Get.toNamed(Routes.WELCOME);
                },
                txt: 'English',
                fillColor: AppColors.appMainColor,
                txtColor: Colors.white,
              ),
              vSpace32,
              AppButton(
                size: Size(0.8.w, 60),
                onPressed: () {
                  LanguageService.to.updateLanguageToArabic();
                  Get.toNamed(Routes.WELCOME);
                },
                txt: 'عربى',
                fillColor: AppColors.lightWhite,
                txtColor: Colors.white,
              ),
              vSpace32,
            ],
          ),
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
