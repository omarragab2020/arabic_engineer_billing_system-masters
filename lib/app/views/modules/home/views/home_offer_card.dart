import 'package:almuandes_billing_system/app/controllers/app_controller.dart';
import 'package:almuandes_billing_system/core/utils/app_assets.dart';
import 'package:almuandes_billing_system/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../screens/main_screen.dart';

class HomeOfferCard extends StatelessWidget {
  const HomeOfferCard(this.homeOfferModel, {super.key});

  final HomeOfferModel homeOfferModel;
  @override
  Widget build(BuildContext context) {
    return SuperDecoratedContainer(
      width: 0.36.w,
      // color: const Color(0xFF051B5D),
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: SuperImageView(
                      imgAssetPath: homeOfferModel.asset ?? AppAssets.appIcon,
                      imgUrl: homeOfferModel.url,
                      color: AppColors.appMainColor,
                      borderRadius: 16,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: SuperDecoratedContainer(
                      borderRadius: 16,
                      color: Colors.yellow,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Txt(homeOfferModel.flag, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
            vSpace8,
            Txt(
              homeOfferModel.title,
              fontSize: 16,
              maxLines: 2,
              isBold: true,
              overflow: TextOverflow.ellipsis,
            ),
            Txt(
              homeOfferModel.description,
              // fontSize: 16,
              color: AppColors.appGrey,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
