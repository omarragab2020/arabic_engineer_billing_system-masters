import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';

import '../../../core/routes/app_pages.dart';
import '../app_controller.dart';
import 'vars_mixin.dart';

mixin HomeMixin on VarsMixin {
  ///region BottomNavigatorMixin
  Future<void> onWillPop(dynamic result) async {
    Completer<void> completer = Completer();

    mPrintMap(prefix: 'onWillPop', {
      'currentRoute': Get.currentRoute,
      'previousRoute': Get.previousRoute,
      'isDialogShown': isDialogShown
    });
    try {
      if (isDialogShown) {
        mPrint('1 1');
        mHide();
        completer.complete();
      } else if (Get.currentRoute == Routes.HOME) {
        mPrint('3');
        mHide();
        if (selectedBottomBarIndex == 1) {
          mPrint('3 2');
          showConfirmationDialog(
            msg: 'exit the application',
            function: () async {
              if (Get.context != null && !Navigator.of(Get.context!).canPop()) {
                // await AppController.to.updateMyStatus(UserStatus.UnAvailable);
                // MoveToBackground.moveTaskToBack();
                SystemNavigator.pop();
              } else {
                Get.back();
              }
              completer.complete();
            },
            noFunction: () {
              completer.complete();
            },
          );
        } else {
          mPrint('3 3');
          updateBottomIndex(1);
          completer.complete();
        }
      } else if (Get.context != null && Navigator.of(Get.context!).canPop()) {
        mPrint('2');
        Get.back();
        completer.complete();
      }
    } on Exception catch (e) {
      mPrintException(e);
    }
    return completer.future;
  }

  Future<void> goToHome([int index = 1]) async {
    try {
      if (Get.currentRoute == Routes.HOME) return;
      while (Get.currentRoute != Routes.HOME) {
        Get.back(closeOverlays: true);
      }
      updateBottomIndex(index);
    } on Exception catch (e) {
      mPrintException(e);
    }
  }

  void updateBottomIndex(index) {
    selectedBottomBarIndex = index;
    homeTabController?.animateTo(selectedBottomBarIndex,
        duration: 100.milliseconds, curve: Curves.bounceIn);
  }

  ///endregion BottomNavigatorMixin
}
