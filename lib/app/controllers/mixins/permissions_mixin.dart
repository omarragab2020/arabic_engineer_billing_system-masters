import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/routes/app_pages.dart';
import '../../models/api_response.dart';
import 'vars_mixin.dart';

mixin PermissionsMixin on VarsMixin {
  final _isAppSettingsOpen = false.obs;

  bool get isAppSettingsOpen => _isAppSettingsOpen.value;

  set isAppSettingsOpen(bool val) => [_isAppSettingsOpen.value = val, _isAppSettingsOpen.refresh()];

  StreamController<bool> isAppSettingsOpenStream = StreamController<bool>.broadcast();

  Future<bool> waitAppSettingsClose() async {
    await isAppSettingsOpenStream.stream.first;
    isAppSettingsOpen = false;
    return isAppSettingsOpen;
  }

  void toggleAppSettingsOpen() {
    if (isAppSettingsOpen) {
      mPrint2('onResumedCallback (isAppSettingsOpen: $isAppSettingsOpen)');
      isAppSettingsOpenStream.sink.add(false);
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (GetPlatform.isAndroid) {
      if (permission.inList([
        Permission.reminders,
        Permission.mediaLibrary,
        Permission.photosAddOnly,
        Permission.criticalAlerts,
        Permission.backgroundRefresh,
        Permission.appTrackingTransparency,
      ])) return true;
    } else if (GetPlatform.isIOS) {
      if (permission.inList([
        Permission.sms,
        Permission.phone,
        Permission.systemAlertWindow,
        Permission.ignoreBatteryOptimizations,
      ])) return true;
    }
    Completer<PermissionStatus> statusCompleter = Completer();
    Completer<bool> completer = Completer();
    PermissionStatus permissionStatus = await permission.onPermanentlyDeniedCallback(() async {
      isAppSettingsOpen = true;
      mPrint2('PermissionStatusTAG openingAppSettings');
      await AppSettings.openAppSettings(type: permissionToSettingsMap[permission] ?? AppSettingsType.settings, asAnotherTask: true);
      isAppSettingsOpen = true;
      mShowToastError("Please allow/accept it", displayTime: GetNumUtils(1).seconds);
      await GetNumUtils(1).seconds.delay();
      mPrint2('PermissionStatusTAG waiting closing AppSettings');
      await waitAppSettingsClose();
      mPrint2('PermissionStatusTAG AppSettings closed');
      statusCompleter.complete(PermissionStatus.permanentlyDenied);
      return;
    }).request();
    if (!permissionStatus.isPermanentlyDenied) statusCompleter.complete(permissionStatus);

    PermissionStatus permissionStatus2 = await statusCompleter.future;

    mPrint2('PermissionStatusTAG PermissionStatus ($permission) is ($permissionStatus)');

    if (permissionStatus2.isGranted) {
      mPrint2('PermissionStatusTAG Completing');
      completer.complete(true);
    } else {
      mShowToastError("Please allow/accept it", displayTime: GetNumUtils(1).seconds);
      await GetNumUtils(1).seconds.delay();
      mPrint2('PermissionStatusTAG Requesting again');
      // requestPermission(permission);
      completer.complete(requestPermission(permission));
    }
    return completer.future;
  }

  Future<void> requestPermissions(List<Permission> list) async {
    // mPrint2('pause');
    await list.forEachAsync(requestPermission);
    // mPrint2('play');
  }

  Future<bool> requestStoragePermissions({bool photos = true, bool videos = false}) async {
    if (GetPlatform.isAndroid) {
      var info = await getAndroidDeviceInfo();
      mPrint2('info = ${info.version.toMap()}');
      if (info.version.sdkInt > 32) {
        await requestPermissions([
          if (photos) Permission.photos,
          if (videos) Permission.videos,
        ]);
      } else {
        return await requestPermission(Permission.storage);
      }
    }

    return false;
  }

  Future<bool> requestLocationPermissions({bool always = false, bool whenInUse = false}) async {
    await requestPermissions([
      Permission.location,
      if (whenInUse) Permission.locationWhenInUse,
      if (always) Permission.locationAlways,
    ]);
    return true;
  }

  static final Map<Permission, AppSettingsType> permissionToSettingsMap = {
    Permission.calendar: AppSettingsType.settings,
    Permission.camera: AppSettingsType.settings,
    Permission.contacts: AppSettingsType.settings,
    Permission.location: AppSettingsType.location,
    Permission.locationAlways: AppSettingsType.location,
    Permission.locationWhenInUse: AppSettingsType.location,
    Permission.mediaLibrary: AppSettingsType.settings,
    Permission.microphone: AppSettingsType.sound,
    Permission.phone: AppSettingsType.settings,
    Permission.photos: AppSettingsType.settings,
    Permission.photosAddOnly: AppSettingsType.settings,
    Permission.reminders: AppSettingsType.settings,
    Permission.sensors: AppSettingsType.settings,
    Permission.sms: AppSettingsType.settings,
    Permission.speech: AppSettingsType.settings,
    Permission.storage: AppSettingsType.settings,
    Permission.ignoreBatteryOptimizations: AppSettingsType.batteryOptimization,
    Permission.notification: AppSettingsType.notification,
    Permission.accessMediaLocation: AppSettingsType.location,
    Permission.activityRecognition: AppSettingsType.settings,
    Permission.unknown: AppSettingsType.settings,
    Permission.bluetooth: AppSettingsType.bluetooth,
    Permission.manageExternalStorage: AppSettingsType.internalStorage,
    Permission.systemAlertWindow: AppSettingsType.settings,
    Permission.requestInstallPackages: AppSettingsType.settings,
    Permission.appTrackingTransparency: AppSettingsType.settings,
    Permission.criticalAlerts: AppSettingsType.settings,
    Permission.accessNotificationPolicy: AppSettingsType.notification,
    Permission.bluetoothScan: AppSettingsType.bluetooth,
    Permission.bluetoothAdvertise: AppSettingsType.bluetooth,
    Permission.bluetoothConnect: AppSettingsType.bluetooth,
    Permission.nearbyWifiDevices: AppSettingsType.wifi,
    Permission.videos: AppSettingsType.settings,
    Permission.audio: AppSettingsType.settings,
    Permission.scheduleExactAlarm: AppSettingsType.alarm,
    Permission.sensorsAlways: AppSettingsType.settings,
    Permission.calendarWriteOnly: AppSettingsType.settings,
    Permission.calendarFullAccess: AppSettingsType.settings,
    Permission.assistant: AppSettingsType.settings,
    Permission.backgroundRefresh: AppSettingsType.settings,
  };
}
