import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/app_button.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../../core/routes/app_pages.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../controllers/app_controller.dart';

class NoDataView extends GetView<AppController> {
  const NoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        vSpace64,
        SuperImageView(imgAssetPath: AppAssets.serverErrorIcon, width: 0.4.w),
        vSpace16,
        const Txt('No Data', fontWeight: FontWeight.w800, fontSize: 20),
        vSpace48,
        AppButton(
          size: Size(0.8.w, 60),
          onPressed: () {
            if (Get.currentRoute == Routes.HOME) {
              controller.updateBottomIndex(2);
            } else {
              Get.back();
            }
          },
          txt: 'Back to Home',
          fillColor: AppColors.appMainColor,
          txtColor: Colors.white,
        ),
      ],
    );
  }
}
