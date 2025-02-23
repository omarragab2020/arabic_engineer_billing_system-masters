import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/widgets.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_helpers.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      appBar: AppBar(title: const Txt('Contact Us', fontSize: 20), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SuperImageView(
              imgAssetPath: AppAssets.appIcon,
              width: 0.5.w,
              fit: BoxFit.fitWidth,
            ),
            vSpace64, vSpace64,
            SuperImageView(
              width: Get.width * 0.4,
              height: Get.width * 0.4,
              svgAssetPath: AppAssets.whatsappIcon,
            ),

            SuperDecoratedContainer(
              padding: const EdgeInsets.all(8),
              borderColor: Colors.white,
              color: Colors.green,
              borderRadius: 20,
              borderWidth: 5,
              child: TextButton(
                onPressed: () => AppHelpers.mLaunchWhatsApp('+2012'),
                child: const Txt('Send a message', color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            // SizedBox(
            //   width: Get.width * 0.4,
            //   height: Get.width * 0.4,
            //   child: MainGridCard(
            //     title: 'Send a message',
            //     imageSvg: AppAssets.whatsappIcon,
            //     onPressed: () {
            //       mShowToast('Adding fund with contacting us...');
            //       launchWhatsApp();
            //       // Get.toNamed(Routes.PROFILE);
            //     },
            //   ),
            // ),

            vSpace32,
          ],
        ),
      ),
    );
  }
}
