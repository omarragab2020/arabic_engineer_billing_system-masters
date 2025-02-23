import 'package:almuandes_billing_system/core/utils/app_assets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';

import '../../../core/utils/app_colors.dart';
import '../../models/banner_model.dart';

class BannerSliderView extends StatelessWidget {
  BannerSliderView({super.key, this.banners = const []});

  final List<BannerModel> banners;

  final SliderController sliderController = SliderController();

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      banners.addAll([
        BannerModel(img: AppAssets.board1),
        BannerModel(img: AppAssets.board2),
        BannerModel(img: AppAssets.board3),
      ]);
      // return SuperImageView(
      //   imgAssetPath: AppAssets.appIcon,
      //   height: 0.18.h,
      //   width: 1.w,
      //   elevation: 2,
      //   borderRadius: 16,
      //   shadowColor: Colors.white,
      // );
    }
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 0.3.h,
            aspectRatio: 16 / 9,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: 5.seconds,
            autoPlayAnimationDuration: 1.seconds,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: (int index, CarouselPageChangedReason reason) {
              sliderController.updateIndex(index);
            },
            scrollDirection: Axis.horizontal,
          ),
          itemCount: banners.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
            width: 1.w,
            // margin: 4.hPadding,
            child: SuperImageView(
              imgAssetPath: banners[itemIndex].img,
              borderRadius: 16,
            ),
          ),
        ),
        vSpace16,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              banners.length,
              (ind) => Obx(() {
                    return SuperDecoratedContainer(
                      width: sliderController.curIndex == ind ? 10 : 8,
                      margin: 4.hPadding,
                      shape: BoxShape.circle,
                      color: sliderController.curIndex == ind
                          ? AppColors.appMainColor
                          : AppColors.selectedColor,
                    );
                  })),
        )
      ],
    );
  }
}

class SliderController extends GetxController {
  final _curIndex = 0.obs;

  int get curIndex => _curIndex.value;

  set curIndex(int val) => _curIndex.value = val;

  updateIndex(int ind) {
    curIndex = ind;
    update();
  }
}
