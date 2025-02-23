import 'package:almuandes_billing_system/app/views/modules/auth/login_unlock.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../auth/profile_screen.dart';
import '../stations/stations_screen.dart';
import 'screens/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AppController controller = AppController.to;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      0.1.milliseconds.delay(() {
        bool b = controller.homeTabController == null;
        controller.homeTabController = TabController(length: 3, vsync: this);
        if (b) {
          controller.updateBottomIndex(1);
        }
      });
      controller.requestLocationPermissions();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SuperScaffold(
        onWillPop: controller.onWillPop,
        body: Obx(() {
          return controller.homeTabController == null
              ? const SizedBox()
              : TabBarView(
                  controller: controller.homeTabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    StationsScreen(),
                    const MainScreen(),
                    const ProfileScreen(),
                  ],
                );
        }),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            elevation: 16,
            iconSize: 40,
            selectedFontSize: 15,
            unselectedFontSize: 14,
            type: BottomNavigationBarType.fixed,
            enableFeedback: true,
            items: [
              getBottomNavigationItem(
                  iconData: Icons.location_pin, label: 'Stations'),
              getBottomNavigationItem(iconData: Icons.home, label: 'Home'),
              getBottomNavigationItem(
                  iconData: Icons.person_2_sharp, label: 'Profile'),
            ],
            onTap: controller.updateBottomIndex,
            currentIndex: controller.selectedBottomBarIndex,
            selectedItemColor: AppColors.appMainColor,
            selectedLabelStyle: TextStyle(color: AppColors.appMainColor),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    controller.homeTabController?.dispose();
    controller.homeTabController = null;
    super.dispose();
  }
}

BottomNavigationBarItem getBottomNavigationItem(
    {IconData? iconData,
    IconData? activeIconData,
    String? label,
    String? assetPath,
    Widget? child,
    Widget? activeChild}) {
  if (iconData != null) {
    return BottomNavigationBarItem(
        icon: FaIcon(iconData, size: 30),
        activeIcon: FaIcon(activeIconData ?? iconData,
            size: 30, color: AppColors.appMainColor),
        label: label?.tr);
  }
  if (assetPath != null) {
    return BottomNavigationBarItem(
        icon: child ??
            SuperImageView(
                imgAssetPath: assetPath, fit: BoxFit.fitWidth, width: 30),
        activeIcon: activeChild ??
            SuperImageView(
                imgAssetPath: assetPath,
                fit: BoxFit.fitWidth,
                width: 30,
                color: AppColors.appMainColor),
        label: label?.tr);
  }
  return BottomNavigationBarItem(
      icon: SuperImageView(imgAssetPath: assetPath, width: 30), label: '');
}
