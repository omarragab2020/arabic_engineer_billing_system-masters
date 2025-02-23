import 'dart:async';

import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../app/controllers/app_controller.dart';
import '../../app/models/user_model.dart';
import '../repositories/_base_api_service.dart';
import '../routes/app_pages.dart';
import 'app_colors.dart';
import 'app_constants.dart';
import 'app_strings.dart';
import 'app_extensions.dart';

class AppHelpers {
  static String get curLanguage => LanguageService.to.isArabic ? 'ar-SA' : 'en-US';

  static String translate(String s, [bool isArabic = true]) => isArabic ? Get.translations['ar']![s] ?? s : s;

  static Widget appDivider([double height = 32, double thickness = 1, double opacity = 0.2]) =>
      Divider(color: AppColors.appMainColor.withOpacity(opacity), thickness: thickness, height: height);

  static Map<A, T> listToIDMap<A, T>(list) {
    return {for (var e in list) e.id!: e as T};
  }

  static String? getServerImageUrl(String? path) {
    return path == null ? null : '${BaseApiService.assetsUrl}/$path';
  }

  static Future<bool> mLaunchWhatsApp(String num, [String msg = 'Hello']) async {
    if (!await launchWhatsApp(num, msg)) {
      mShowToast('Unable to launch WhatsApp');
      return false;
    }
    return true;
  }

  static mPrintList(List? list) {
    mPrint(list?.map((e) => '"$e"').join(','));
  }

  static void showLoginFirstToast() {
    mShowDialog(
      builder: (_) => SuperDecoratedContainer(
        color: Get.theme.dialogBackgroundColor,
        width: 0.8.w,
        padding: 8.allPadding,
        borderRadius: 36,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: LanguageService.to.alignmentReverse,
                child: const IconButton(
                    onPressed: mHide,
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ))),
            const Txt(AppStrings.loginMsgEn, fontSize: 18),
            vSpace16,
            OutlinedButton(
                onPressed: () {
                  mHide();

                  Get.toNamed(Routes.LOGIN);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Txt('Login now')),
            vSpace16,
          ],
        ),
      ),
    );
  }

  static void showDeleteAccountDialog(UserModel userModel) {
    RxInt timeTicks = (AppController.to.isAdmin ? 5 : AppConstants.deleteAccountCautionSeconds).obs;
    Timer timer = Timer.periodic(GetNumUtils(1).seconds, (timer) {
      timeTicks--;
      if (timeTicks.value == 0) timer.cancel();
    });

    mShowDialog(
        builder: (_) => SuperDecoratedContainer(
              color: Get.theme.dialogBackgroundColor,
              width: 0.8.w,
              padding: 8.allPadding,
              borderRadius: 36,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const IconButton(
                      onPressed: mHide,
                      icon: Icon(
                        Icons.dangerous,
                        color: Colors.red,
                        size: 40,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Txt('${"Are you sure you want to ".tr}${AppStrings.deleteAccMsgEn.tr}', fontSize: 18, textAlign: TextAlign.justify),
                  ),
                  vSpace16,
                  Obx(() {
                    return Column(
                      children: [
                        if (timeTicks.value > 0) Txt(timeTicks.value, fontSize: 18),
                        OutlinedButton(
                            onPressed: timeTicks.value <= 0
                                ? () async {
                                    timer.cancel();
                                    mShowLoading(msg: 'Deleting account...');
                                    if (userModel.isMe) {
                                      await AppController.to.deleteMyAccount();
                                    } else if (AppController.to.isAdmin) {
                                      // bool b = await FirebaseService.deleteUserById(userModel.id!);
                                      // mShowToast(b ? 'Deleted' : 'Failed');
                                      // if (b) {
                                      //   Get.back();
                                      // 5.seconds.delay(() {
                                      //   FirebaseService.setUserById(userModel.id!, userModel.toMap());
                                      // });
                                      // }
                                    }
                                    mHide();
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Txt('Delete my account')),
                      ],
                    );
                  }),
                  vSpace16,
                ],
              ),
            ));
  }
}
