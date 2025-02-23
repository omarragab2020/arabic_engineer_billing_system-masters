import 'package:almuandes_billing_system/app/views/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/country_model.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/app_button.dart';
import 'package:neuss_utils/widgets/src/super_country_picker.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_light_dark_btn.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../controllers/app_controller.dart';
import '../../../widgets/banner_slider_view.dart';
import '../../../widgets/header_view_all.dart';
import '../../auth/login_unlock.dart';
import '../views/home_grid_icon.dart';
import '../views/home_offer_card.dart';
import 'base_main_screen.dart';

class MainScreen extends GetView<AppController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMainScreen(
        title: 'Home',
        padding: 0,
        appBar: const MyAppBar(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace8,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Txt(
                  'Marhaba',
                  isBold: true,
                  fontSize: 26,
                  letterSpacing: 1.5,
                ),
              ),
              vSpace16,
              Obx(() {
                return BannerSliderView(
                    banners: controller.adminDataModel.homeSliders);
              }),
              vSpace32,
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: homeItems.map((e) => HomeGridIcon(e)).toList(),
                ),
              ),
              vSpace32,
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap(
                    //   spacing: 16,
                    //   runSpacing: 16,
                    //   alignment: WrapAlignment.center,
                    //   crossAxisAlignment: WrapCrossAlignment.center,
                    //   runAlignment: WrapAlignment.center,
                    //   children: homeItems.map((e) => HomeGridIcon(e)).toList(),
                    // ),
                    // GridView.count(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   crossAxisCount: 4,
                    //   mainAxisSpacing: 16,
                    //   crossAxisSpacing: 16,
                    //   childAspectRatio: 0.85,
                    //   shrinkWrap: true,
                    //   children: homeItems.map((e) => HomeGridIcon(e)).toList(),
                    // ),
                    vSpace16,
                    // SizedBox(
                    //   height: 0.33.h,
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: <Widget>[
                    //       HeaderViewAll(
                    //         title: 'Featured Offers',
                    //         onPressed: () {
                    //           // Get.to(() => ProvidersByCategoryScreen(providerType));
                    //         },
                    //       ),
                    //       Expanded(
                    //         child: Align(
                    //           alignment: LanguageService.to.alignment,
                    //           child: Builder(builder: (_) {
                    //             List<HomeOfferModel> list = [
                    //               HomeOfferModel(
                    //                   title:
                    //                       'Any Oasis\nCroissants / Self Service',
                    //                   description: 'Redeem 7,000 points'),
                    //               HomeOfferModel(
                    //                   title:
                    //                       'Any Oasis [S]\nCoffee / Self Service',
                    //                   description: 'Redeem 9,000 points'),
                    //               HomeOfferModel(
                    //                   title:
                    //                       'Any Croissant Sandwich / Pretzel / Other',
                    //                   description: 'Redeem 10,000 points'),
                    //               HomeOfferModel(
                    //                   title: 'Any Oasis Range of Pizzas',
                    //                   description: 'Redeem 14,000 points'),
                    //               HomeOfferModel(
                    //                   title: 'BOGO On Hot and Cold Coffee',
                    //                   description: 'Redeem 1,000 points',
                    //                   flag: 'Buy 1 Get 1'),
                    //             ];
                    //             if (list.isEmpty) {
                    //               return SuperImageView(
                    //                 imgAssetPath: AppAssets.appIcon,
                    //                 width: 1.w,
                    //               );
                    //             }
                    //
                    //             ///TODO 0
                    //             return ListView.separated(
                    //               shrinkWrap: true,
                    //               scrollDirection: Axis.horizontal,
                    //               itemCount: list.length,
                    //               itemBuilder: (BuildContext context,
                    //                       int index) =>
                    //                   InkWell(
                    //                       onTap: () {
                    //                         // Get.to(() => ProviderSingleScreen(providerModel: list[index]));
                    //                       },
                    //                       child: HomeOfferCard(list[index])),
                    //               separatorBuilder:
                    //                   (BuildContext context, int index) =>
                    //                       hSpace8,
                    //             );
                    //           }),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // vSpace32,
                    // const Txt('Enhance your experience',
                    //     fontSize: 18, isBold: true),
                    // vSpace8,
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: Stack(
                    //         children: [
                    //           SuperImageView(
                    //               imgAssetPath: AppAssets.board3,
                    //               height: 0.2.h,
                    //               fit: BoxFit.fill,
                    //               borderRadius: 16),
                    //           const Positioned(
                    //               bottom: 16,
                    //               left: 16,
                    //               right: 16,
                    //               child: Txt('WELCOME TO\nAI-ENABLED FUELING',
                    //                   color: Colors.white,
                    //                   maxLines: 2,
                    //                   fontSize: 16,
                    //                   isBold: true))
                    //         ],
                    //       ),
                    //     ),
                    //     hSpace16,
                    //     Expanded(
                    //       child: Stack(
                    //         children: [
                    //           SuperImageView(
                    //               imgAssetPath: AppAssets.board1,
                    //               height: 0.2.h,
                    //               fit: BoxFit.fill,
                    //               borderRadius: 16),
                    //           const Positioned(
                    //               bottom: 16,
                    //               left: 16,
                    //               right: 16,
                    //               child: Txt('SEAMLESS SERVICE HAS ARRIVED',
                    //                   color: Colors.white,
                    //                   maxLines: 2,
                    //                   fontSize: 16,
                    //                   isBold: true))
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    vSpace32,
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class HomeGridItem {
  String asset;
  String title;

  HomeGridItem(this.title, this.asset);

  HomeGridItem.named({required this.title, required this.asset});
}

List<HomeGridItem> homeItems = [
  HomeGridItem('Wallet', AppAssets.wallet),
  HomeGridItem('Vehicles', AppAssets.vehicle2),
  HomeGridItem('Orders', AppAssets.orderLpg),
  HomeGridItem('Stations', AppAssets.locationPin),
];

class HomeOfferModel {
  String? asset;
  String? url;
  String title;
  String description;
  String? flag;

  HomeOfferModel(
      {required this.title,
      required this.description,
      this.flag = 'Free',
      this.asset,
      this.url});
}
