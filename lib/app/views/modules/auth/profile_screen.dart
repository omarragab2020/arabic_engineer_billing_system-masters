import 'package:almuandes_billing_system/app/views/modules/home/screens/base_main_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/locations/my_locations_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/orders/my_orders_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/vehicles/my_vehicles_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/wallet/my_wallet_screen.dart';
import 'package:almuandes_billing_system/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/home.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/app_button.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_language_btn.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../widgets/my_tile.dart';
import '../settings/account_settings_screen.dart';
import 'user_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              vSpace16,
              SuperDecoratedContainer(
                shape: BoxShape.circle,
                height: 0.3.w,
                width: 0.3.w,
                color: Get.theme.primaryColor,
                child: const Center(
                  child: Txt('MA',
                      color: Colors.white, fontSize: 28, isBold: true),
                ),
              ),
              vSpace8,
              const Txt('Muath Abuzeit',
                  fontSize: 20, letterSpacing: 1.5, isBold: true),
              vSpace32,
              SuperDecoratedContainer(
                  color: Colors.grey.shade200,
                  borderRadius: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ProfileTile(
                            onTap: () {
                              Get.to(() => const UserProfilePage());
                            },
                            title: 'My personal details',
                            icon: Icons.perm_identity),
                        const Divider(
                            thickness: 2, height: 2, color: Colors.white),
                        ProfileTile(
                            onTap: () {
                              Get.to(() => const MyLocationsScreen());
                            },
                            title: 'My locations',
                            icon: Icons.my_location),
                        const Divider(
                            thickness: 2, height: 2, color: Colors.white),
                        ProfileTile(
                            onTap: () {
                              Get.to(() => const MyVehiclesScreen());
                            },
                            title: 'My vehicles',
                            icon: Icons.local_car_wash_sharp),
                        const Divider(
                            thickness: 2, height: 2, color: Colors.white),
                        ProfileTile(
                            onTap: () {
                              Get.to(() => const MyOrdersScreen());
                            },
                            title: 'My orders',
                            icon: Icons.request_page),
                      ],
                    ),
                  )),
              vSpace16,
              SuperDecoratedContainer(
                  color: Colors.grey.shade200,
                  borderRadius: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ProfileTile(
                            onTap: () {
                              Get.to(() => const MyWalletScreen());
                            },
                            title: 'Wallet',
                            icon: Icons.wallet),
                        const Divider(
                            thickness: 2, height: 2, color: Colors.white),
                        ProfileTile(
                            title: 'Rewards', icon: Icons.card_giftcard),
                      ],
                    ),
                  )),
              vSpace16,
              SuperDecoratedContainer(
                  color: Colors.grey.shade200,
                  borderRadius: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ProfileTile(title: 'Call us', icon: Icons.contact_mail),
                        const Divider(
                            thickness: 2, height: 2, color: Colors.white),
                        ProfileTile(title: 'Chat with us', icon: Icons.chat),
                      ],
                    ),
                  )),
              vSpace16,
              SuperDecoratedContainer(
                  color: Colors.grey.shade200,
                  borderRadius: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ProfileTile(
                            onTap: () {
                              Get.to(() => const AccountSettingsScreen());
                            },
                            title: 'Account Settings',
                            icon: Icons.settings),
                        const Divider(
                            thickness: 2, height: 2, color: Colors.white),
                        ProfileTile(
                            onTap: deleteProfile,
                            title: 'Logout',
                            icon: Icons.logout),
                      ],
                    ),
                  )),
              // vSpace16,
              // SuperLanguageBtn(),
              vSpace32,
            ],
          ),
        ),
      ),
    );
  }

  void deleteProfile() {
    mShowToastError('To be done', displayTime: 1.seconds);
    return;
  }
}

class ProfileTile extends MyTile {
  ProfileTile(
      {super.key,
      Function()? onTap,
      String? title,
      Widget? trailing,
      IconData? icon,
      EdgeInsets? contentPadding})
      : super(
          onTap: onTap ??
              () {
                mShowToast('To be done...', displayTime: 0.5.seconds);
              },
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          leading: icon == null ? null : Icon(icon),
          title: Txt(title, fontSize: 16),
          trailing: trailing ??
              Icon(
                LanguageService.to.isArabic
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: AppColors.appGrey,
                // textDirection: LanguageService.to.isArabic
                //     ? TextDirection.ltr
                //     : TextDirection.rtl,
              ),
        );
}
