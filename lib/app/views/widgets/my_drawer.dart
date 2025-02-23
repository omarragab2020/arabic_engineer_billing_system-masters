import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/home.dart';
import 'package:neuss_utils/home/src/theme/theme_service.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/panel/super_panel.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_language_btn.dart';
import 'package:neuss_utils/widgets/src/super_light_dark_btn.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/routes/app_pages.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_helpers.dart';
import '../../../core/utils/app_themes.dart';
import '../../controllers/app_controller.dart';

class MyDrawer extends GetView<AppController> {
  const MyDrawer({super.key});

  Widget get divider => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppHelpers.appDivider(0, 2),
      );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Obx(() {
        return SuperDecoratedContainer(
          color: (ThemeService.to.isDark ? Colors.grey[900]! : Colors.white).withOpacity(0.9),
          width: 0.6.w,
          borderRadiusGeometry: LanguageService.to.isArabic
              ? BorderRadius.only(topLeft: 48.radius, bottomLeft: 48.radius)
              : BorderRadius.only(topRight: 48.radius, bottomRight: 48.radius),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              vSpace24,
              InkWell(
                onTap: Get.back,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SuperImageView(
                    imgAssetPath: AppAssets.appIcon,
                    // width: 0.2.w,
                    height: 0.12.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // const DrawerItem('Home'),
              SuperLanguageBtn.text(onChanged: () {
                // controller.updateMyLanguage();
                // controller.initHtmlPages();
              }),

              Center(child: SuperLightDarkBtn(
                onChanged: (_) {
                  // Get.back();
                },
              )),
              vSpace16,
              divider,

              if (controller.successfullyLoggedIn) ...[
                DrawerItem(
                  'Profile',
                  leadingIconData: Icons.person,
                  onTap: () {
                    if (Get.currentRoute == Routes.HOME) {
                      if (controller.selectedBottomBarIndex == 2) Get.back();
                      controller.updateBottomIndex(2);
                    } else {
                      // Get.to(() => UserProfileScreen(controller.mUser!));
                    }
                  },
                ),
                divider,
                DrawerItem(
                  'Notifications',
                  leadingIconData: Icons.notifications,
                  onTap: () {
                    // Get.to(() => const MyNotificationsScreen());
                  },
                ),
                divider,
                DrawerItem(
                  'Favourite Cars',
                  leadingIconData: FontAwesomeIcons.car,
                  onTap: () {
                    // Get.to(() => const FavouriteCarsScreen());
                  },
                ),
                divider,
                DrawerItem('Share App', leadingIconData: Icons.share_sharp, onTap: () {
                  mShowToast('Sharing app');
                  Share.share('Share msg');
                }),
                divider,
                DrawerItem('Logout', leadingIconData: Icons.logout, onTap: controller.signOutDialog),
                if (controller.isAdmin)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SuperPanel(
                      title: 'Admin Area',
                      child: Column(
                        children: <Widget>[
                          DrawerItem(
                            'Users Management',
                            leadingIconData: Icons.group,
                            // onTap: () => Get.to(() => const UsersManagementScreen()),
                          ),
                          divider,
                          DrawerItem(
                            'Categories Management',
                            leadingIconData: Icons.category_sharp,
                            // onTap: () => Get.to(() => const CategoriesManagementScreen()),
                          ),
                          divider,
                          DrawerItem(
                            'Home Sliders Management',
                            leadingIconData: Icons.slideshow,
                            // onTap: () => Get.to(() => const BannersManagementScreen()),
                          ),
                          divider,
                          DrawerItem(
                            'Chasis Types Management',
                            leadingIconData: FontAwesomeIcons.carBurst,
                            // onTap: () => Get.to(() => const ChasisTypesManagementScreen()),
                          ),
                          divider,
                          DrawerItem(
                            'Fuel Types Management',
                            leadingIconData: FontAwesomeIcons.bottleDroplet,
                            // onTap: () => Get.to(() => const FuelTypesManagementScreen()),
                          ),
                          divider,
                          DrawerItem(
                            'Motor Types Management',
                            leadingIconData: FontAwesomeIcons.motorcycle,
                            // onTap: () => Get.to(() => const MotorTypesManagementScreen()),
                          ),
                          divider,
                          DrawerItem(
                            'Notifications Center',
                            leadingIconData: Icons.notifications,
                            // onTap: () => Get.to(() => const NotificationCenterScreen()),
                          ),
                        ],
                      ),
                    ),
                  ),
              ] else ...[
                DrawerItem('Login', leadingIconData: Icons.login, onTap: () => Get.offAllNamed(Routes.LOGIN)),
              ],

              if (!controller.isAdmin) divider,
              if (controller.successfullyLoggedIn) ...[
                vSpace48,
                divider,
                DrawerItem('Delete my account', leadingIconData: Icons.close, onTap: () => AppHelpers.showDeleteAccountDialog(controller.mUser!)),
                divider,
              ],
              vSpace64,
            ],
          ),
        );
      }),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(this.title,
      {super.key, this.leadingIconData, this.leadingWidget, this.titleColor, this.onTap, this.trailingIconData, this.trailingWidget});

  final String title;
  final Color? titleColor;
  final IconData? leadingIconData;
  final IconData? trailingIconData;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leadingWidget ?? (leadingIconData == null ? null : Icon(leadingIconData, color: titleColor ?? AppColors.appMainColor)),
      trailing: leadingWidget ?? (trailingIconData == null ? null : Icon(trailingIconData, color: titleColor ?? AppColors.appMainColor)),
      title: Txt(
        title,
        color: titleColor ?? AppColors.appMainColor,
        fontWeight: FontWeight.bold,
        textAlign: LanguageService.to.textAlign,
      ),
    );
  }
}
