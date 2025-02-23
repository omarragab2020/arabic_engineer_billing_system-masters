import 'package:almuandes_billing_system/app/controllers/app_controller.dart';
import 'package:almuandes_billing_system/app/views/modules/orders/my_orders_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/stations/stations_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/vehicles/my_vehicles_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/wallet/my_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../widgets/location_picker.dart';
import '../screens/main_screen.dart';

class HomeGridIcon extends GetView<AppController> {
  const HomeGridIcon(this.homeGridItem, {super.key});

  final HomeGridItem homeGridItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (homeGridItem.title) {
          case 'Wallet':
            Get.to(() => const MyWalletScreen());
            // controller.goto(const MyWalletScreen());
            break;
          case 'Vehicles':
            Get.to(() => const MyVehiclesScreen());
            // controller.goto(const MyWalletScreen());
            break;
          case 'Orders':
            Get.to(() => const MyOrdersScreen());
            // controller.goto(const MyWalletScreen());
            // Get.to(() => const FlutterMapLocationPicker());
            break;
          case 'Stations':
            controller.updateBottomIndex(0);
            // Get.to(() => StationsScreen());
            // controller.goto(const MyWalletScreen());
            break;
          case 'EV Charger':
            controller.goto(const MyWalletScreen());
            break;
          case 'Fill & Go':
            controller.goto(const MyWalletScreen());
            break;
          case 'Shop':
            controller.goto(const MyWalletScreen());
            break;
          case 'More':
            controller.goto(const MyWalletScreen());
            break;
          default:
        }
      },
      child: SuperDecoratedContainer(
        elevation: 8,
        color: Colors.white,
        borderRadius: 12,
        width: 0.40.w,
        height: 0.30.w,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SuperImageView(
                    imgAssetPath: homeGridItem.asset,
                  ),
                ),
              ),
              vSpace8,
              Txt(homeGridItem.title,
                  fontWeight: FontWeight.w500, fontSize: 16),
            ],
          ),
        ),
      ),
    );
  }
}
