import 'dart:async';

import 'package:almuandes_billing_system/core/repositories/auth_api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neuss_utils/utils/app_life_cycle_controller.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'app/views/modules/osm/super_osm_manager.dart';
import 'core/repositories/app_api_service.dart';
import 'core/services/location_services.dart';
import 'core/services/super_notification_service.dart';
import 'package:neuss_utils/home/home.dart';

import 'app/controllers/app_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/utils/app_constants.dart';
import 'core/utils/app_themes.dart';
import 'core/utils/app_translations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TxtManager.defaultColor = AppColors.appMainTextColor;
  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put<AppController>(AppController(), permanent: true);
  Get.put<AuthApiService>(AuthApiService(), permanent: true);
  Get.put<AppApiService>(AppApiService(), permanent: true);
  Get.put<LanguageService>(LanguageService(), permanent: true);
  Get.put<ThemeService>(ThemeService(), permanent: true);
  Get.put<SuperNotificationService>(SuperNotificationService(),
      permanent: true);
  Get.put<LocationService>(LocationService(), permanent: true);
  Get.put<SuperOSMManager>(SuperOSMManager(), permanent: true);
  Get.put<SuperLifeCycleController>(
      SuperLifeCycleController(
          debug: false,
          onResumedCallback: AppController.to.toggleAppSettingsOpen),
      permanent: true);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SuperMainApp(
      title: AppConstants.appName,

      ///region Routing
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      ///endregion Routing

      ///region Themes
      lightTheme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      ///endregion Themes

      ///region Locales
      supportedLocales: const <Locale>[
        Locale('ar'),
        Locale('en'),
      ],
      translations: AppTranslations(),

      ///endregion Locales
    );
  }
}
