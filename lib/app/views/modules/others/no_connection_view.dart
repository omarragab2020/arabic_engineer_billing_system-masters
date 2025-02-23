import 'package:flutter/material.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/utils.dart';
import 'package:neuss_utils/widgets/widgets.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mPrint("MoveToBackground NoConnectionPage");
        // MoveToBackground.moveTaskToBack();
        return false;
      },
      child: const Scaffold(
        body: Column(
          children: [
            vSpace96,
            Txt(
              'You are offline',
              fontSize: 30,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              color: AppColors.appLightPrimaryColor1,
            ),
            Txt(
              'Waiting for connection...',
              fontSize: 30,
              color: Colors.red,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            Expanded(
              child: SuperImageView(
                imgAssetPath: AppAssets.noConnection,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
