import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';

import '../../../core/routes/app_pages.dart';
import '../app_controller.dart';
import 'vars_mixin.dart';

mixin ConnectivityMixin on VarsMixin {
  bool isFirst = true;
  StreamSubscription? connectionStream;

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result =
        await Connectivity().checkConnectivity().timeout(5.seconds).onError((error, stackTrace) => [ConnectivityResult.none]);
    isConnected = (result
        .toSet()
        .intersection({ConnectivityResult.ethernet, ConnectivityResult.wifi, ConnectivityResult.vpn, ConnectivityResult.mobile}).isNotEmpty);

    await checkRealConnected();
    connectionStream ??= Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      isConnected = (result
          .toSet()
          .intersection({ConnectivityResult.ethernet, ConnectivityResult.wifi, ConnectivityResult.vpn, ConnectivityResult.mobile}).isNotEmpty);
      // mPrint(isConnected ? 'Network Connected' : 'Network Disconnected');
      changeConnectivityNavigation(isConnected);
      await checkRealConnected();
      if (isRealConnected) {
        AppController.to.initConnected();
        // DirectusWSManager.to.checkConnection();
      }
      // if (!isFirst) {
      //   mShowToast(
      //     isConnected ? 'Network Connected' : 'Network disconnected',
      //     displayTime: (isConnected ? 1000 : 2000).milliseconds,
      //   );
      // }
      isFirst = false;
    });
  }

  Future<bool> checkRealConnected([int seconds = 10]) async {
    if (!isConnected) return false;
    try {
      String url = 'https://www.google.com/';
      Response response = await GetHttpClient().get(url).timeout(seconds.seconds);
      isRealConnected = (response.statusCode == 200);
      if (!isRealConnected) {
        response = await GetHttpClient().get(url).timeout(seconds.seconds);
        isRealConnected = (response.statusCode == 200);
      }
      mPrint('isRealConnected = $isRealConnected');
      return (isRealConnected);
    } catch (e) {
      mPrintError(e);
    }
    return false;
  }

  void changeConnectivityNavigation(bool isConnected) {
    if (isConnected && Get.currentRoute == Routes.NOCONNECTION) {
      if (Get.context != null && Navigator.of(Get.context!).canPop()) {
        Get.back();
      } else {
        if (!mUser!.approved) {
          Get.offAllNamed(Routes.NOTACTIAVTED);
        } else if (Get.currentRoute == Routes.NOTACTIAVTED && isTeacher && mUser!.approved) {
          Get.offAllNamed(successfullyLoggedIn ? Routes.HOME : Routes.LanguageSelect);
        }
      }
    }
  }

  Future<void> checkConnectivityNavigation() async {
    List<ConnectivityResult> result =
        await Connectivity().checkConnectivity().timeout(5.seconds).onError((error, stackTrace) => [ConnectivityResult.none]);
    isConnected = (result
        .toSet()
        .intersection({ConnectivityResult.ethernet, ConnectivityResult.wifi, ConnectivityResult.vpn, ConnectivityResult.mobile}).isNotEmpty);
    mPrint('check isConnected = $isConnected');
    if (isConnected) {
      AppController.to.initConnected();
    }
    // mShowToast(
    //   isConnected ? 'Network Connected' : 'Network disconnected',
    //   displayTime: (isConnected ? 500 : 1000).milliseconds,
    // );
    changeConnectivityNavigation(isConnected);
  }
}
