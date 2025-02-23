import 'package:almuandes_billing_system/app/views/widgets/my_tile.dart';
import 'package:almuandes_billing_system/core/utils/app_assets.dart';
import 'package:almuandes_billing_system/core/utils/app_helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/home.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../core/routes/app_pages.dart';
import '../../../../core/utils/app_colors.dart';

class LoginUnlockPage extends StatelessWidget {
  const LoginUnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            vSpace8,
            Align(alignment: LanguageService.to.alignmentReverse, child: TextButton(onPressed: Get.back, child: const Txt('Later', fontSize: 20))),
            const vSpace(32),
            Icon(Icons.lock, color: AppColors.appGrey, size: 80),
            vSpace8,
            Txt(
              'Login to unlock\nall feature',
              textStyle: Get.textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            AppHelpers.appDivider(),
            MyTile(
              contentPadding: 16.hPadding,
              leading: const SuperImageView(
                imgAssetPath: AppAssets.fuel,
                width: 50,
              ),
              title: const Txt(
                'Faster fill-ups',
                isBold: true,
                fontSize: 18,
              ),
              subTitle: Txt('Fuel up and pay through the app', fontSize: 18, color: AppColors.appGrey),
            ),
            AppHelpers.appDivider(),
            MyTile(
              contentPadding: 16.hPadding,
              leading: const SuperImageView(
                imgAssetPath: AppAssets.gift,
                width: 50,
              ),
              title: const Txt(
                'Earn Rewards Points',
                isBold: true,
                fontSize: 18,
              ),
              subTitle: Txt('Earn Al Muhandes Rewards with every purchase', fontSize: 18, color: AppColors.appGrey),
            ),
            AppHelpers.appDivider(),
            MyTile(
              contentPadding: 16.hPadding,
              leading: const SuperImageView(
                imgAssetPath: AppAssets.orderLpg,
                width: 50,
                fit: BoxFit.fill,
              ),
              title: const Txt(
                'Order LPG',
                isBold: true,
                fontSize: 18,
              ),
              subTitle: Txt('Order LPG direct to your door', fontSize: 18, color: AppColors.appGrey),
            ),
            AppHelpers.appDivider(),
            MyTile(
              contentPadding: 16.hPadding,
              leading: const SuperImageView(
                imgAssetPath: AppAssets.wallet,
                width: 50,
              ),
              title: const Txt(
                'Pay with Al Muhandes Wallet',
                isBold: true,
                fontSize: 18,
              ),
              subTitle: Txt('Top up your wallet to pay quickly and securely', fontSize: 18, color: AppColors.appGrey),
            ),
            const Spacer(),
            FilledButton(
                style: FilledButton.styleFrom(minimumSize: Size(0.9.w, 50)),
                onPressed: () {
                  Get.offNamed(Routes.LOGIN);
                },
                child: const Txt(
                  'Login',
                  fontSize: 16,
                )),
            TextButton(
                onPressed: () {
                  Get.offNamed(Routes.SIGNUP);
                },
                child: const Txt('Register Now', fontSize: 16)),
            vSpace32,
          ],
        ),
      ),
    );
  }
}
