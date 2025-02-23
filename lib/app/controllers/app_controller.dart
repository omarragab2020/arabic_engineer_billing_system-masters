import 'dart:async';

import 'package:almuandes_billing_system/app/controllers/mixins/permissions_mixin.dart';
import 'package:almuandes_billing_system/app/views/modules/auth/login_screen.dart';
import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/utils/app_logger.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:ready_extensions/ready_extensions.dart';
import 'package:shake/shake.dart';
import 'package:synchronized/extension.dart';

import '../../core/repositories/app_api_service.dart';
import '../../core/routes/app_pages.dart';
import '../../core/services/offline_storage.dart';
import '../../core/services/super_notification_service.dart';
import '../../core/utils/app_helpers.dart';
import '../models/admin_data_model.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import 'mixins/auth_mixin.dart';
import 'mixins/connectivity_mixin.dart';
import 'mixins/home_mixin.dart';
import 'mixins/notify_mixin.dart';
import 'mixins/users_mixin.dart';
import 'mixins/vars_mixin.dart';

class AppController extends GetxService with VarsMixin, PermissionsMixin, NotifyMixin, ConnectivityMixin, HomeMixin, AuthMixin, UsersMixin {
  static AppController get to => Get.find();

  @override
  void onReady() {
    initAll();
    super.onReady();
  }

  Future<void> initAll() async {
    initDetector();
    // saveUserPermanently = (OfflineStorage.getUser() != null);

    await initAppVersion();
    await initAuth();
    await initConnectivity();
    await initConnected();
    // await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> initConnected() async {
    mPrint2('initConnected');
    synchronized(() async {
      if (!isConnected) return;

      await initAdminData();

      if (!firstLoading && firstLoadOk != true && successfullyLoggedIn) {
        firstLoading = true;
        bool b = await initLoggedIn();
        if (!b) b = await initLoggedIn();

        mPrint('initLoggedIn: $b');
        1.seconds.delay(() async {
          firstLoadOk = b;
          if (b) {
            refreshUsers();
            refreshUser();
          } else {
            mShowToastError('Retrying');
            await initConnected();
          }
          firstLoading = false;
        });
      }
    });
  }

  initAppVersion() async {
    appVersion = (await getAppVersionNum()) ?? '1.0.0';
  }

  Future<bool> initLoggedIn() async {
    Future<bool> func() async {
      // mPrint("Starting initialize");
      try {
        // OfflineStorage.setBGCall(false);
        await syncMyUser();
        // checkSessions();
        // DirectusWSManager.to.initWebSocket();

        // await initNotifications();
        // await initMyChats();
        // await initMySchedules();
        await initMyFavouriteIDS();
        await checkFCMToken();
        updateMyLanguage();
        SuperNotificationService.to.updateMyTopics();

        getUserLocation();
        refreshMyTokenTimer();
        refreshMyNotifyTimer();
        refreshMyChatTimer();
        // if (!inMeeting&&!inCallScreen&&!isTeacher) {
        mPrint('initMyFavouriteIDS');

        updateMyUser({UserModelFields.isAndroid: GetPlatform.isAndroid});

        // setCallListeners();

        mPrint("Successfully initialized");
        return true;
      } on Exception catch (e) {
        mPrintException(e);
        // FirebaseCrashlytics.instance.recordError(e, null, fatal: false, reason: 'initLoggedIn');
        return false;
      }
    }

    Future<bool> func2() async {
      if (!await AppApiService.to.checkMyUserExist()) {
        signOut();
        return false;
      } else {
        bool b = await func();
        if (b) {
          1.seconds.delay(() {
            if (successfullyLoggedIn) {
              try {
                mShowToast('${'Welcome back'.tr} (${mUser!.first_name})', color: Colors.green);
                mPrint('Welcome back');
              } on Exception {}
            }
          });
        }
        return b;
      }
    }

    mPrint('initLoggedIn');
    if (successfullyLoggedIn) {
      AuthTokensModel? b = await UsersMixin.refreshTokenBG();
      b ??= await UsersMixin.refreshTokenBG();
      if (b != null) return await func2();
    }
    return false;
  }

  Future<void> updateMyLanguage() async {
    if (successfullyLoggedIn &&
        (mUser!.language == null || ((mUser!.isArabic && !LanguageService.to.isArabic) || (!mUser!.isArabic && LanguageService.to.isArabic)))) {
      mPrint('updateMyLanguage to ${AppHelpers.curLanguage}');
      await updateMyUser({UserModelFields.language: AppHelpers.curLanguage});
    }
  }

  Future<bool> initAdminData() async {
    bool b = false;
    AdminDataModel? conf = OfflineStorage.getAdminData();
    if (conf != null) {
      adminDataModel = conf;
      b = true;
    }
    conf = await AppApiService.to.getAdminConfigData(adminDataModel.dateUpdated);
    if (conf != null) {
      adminDataModel = conf;
      OfflineStorage.saveAdminData(adminDataModel);
      b = true;
    }
    // mPrint('adminDataModel welcomeHintsList = ${adminDataModel.weclomeHintsList}');
    // mPrint('adminDataModel homeSliders = ${adminDataModel.homeSliders}');
    return b;
  }

  Future<void> checkFCMToken() async {
    if (!successfullyLoggedIn) return;
    String token = await SuperNotificationService.to.getFirebaseMessagingToken();
    if (!token.isNullOrEmptyOrWhiteSpace && token != mUser!.fcm_token) {
      await SuperNotificationService.myFcmTokenHandle(token);
    }
  }

  @override
  Future<void> onClose() async {
    if (isStudent) {
      // AppController.to.updateMyStatus(UserStatus.UnAvailable, refreshMain: false, refreshDialog: false);
    }
    connectionStream?.cancel();
    homeTabController?.dispose();
    // syncTeachersTimer?.cancel();
    // refreshTokenTimer?.cancel();
    // refreshNotifyTimer?.cancel();
    // refreshChatTimer?.cancel();
    // refreshStatusTimer?.cancel();
    // syncUsersTimer?.cancel();
    fireCallsStream?.cancel();
    connectionStream = null;
    homeTabController = null;
    detector?.stopListening();
    mPrint('onClose onClose onClose');

    super.onClose();
  }

  void gotoNamed(String route) {
    successfullyLoggedIn ? Get.toNamed(route) : Get.toNamed(Routes.LOGINUnlock);
  }

  void goto(Widget route) {
    successfullyLoggedIn ? Get.to(() => route) : Get.toNamed(Routes.LOGINUnlock);
  }

  initDetector() async {
    try {
      if (await checkIsPhysicalDevice()) {
        detector ??= ShakeDetector.autoStart(
            onPhoneShake: () {
              mPrint('onPhoneShake');
              SuperLogOutput.showLogDialogPass();
            },
            minimumShakeCount: 5);
      }
    } on Exception {}
  }

  void continueAsGuest() {
    isGuest = true;
    Get.offNamed(Routes.HOME);
    requestLocationPermissions();
    mShowToast('You can try as a guest only now',displayTime: 1.seconds);
  }
}
