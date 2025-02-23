import 'package:almuandes_billing_system/app/views/modules/home/screens/base_main_screen.dart';
import 'package:almuandes_billing_system/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/utils.dart';
import 'package:neuss_utils/widgets/src/super_button.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import 'add_voucher_screen.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMainScreen(
      title: 'Wallet',
      child: Column(
        children: <Widget>[
          vSpace32,
          SuperDecoratedContainer(
            gradient: LinearGradient(colors: [AppColors.appMainColor.withOpacity(0.9), AppColors.appMainColor.withOpacity(0.2)]),
            borderRadius: 16,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  vSpace8,
                  const Txt(
                    'Cash',
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontSize: 16,
                  ),
                  vSpace4,
                  const Txt(
                    'AED 0.00',
                    isBold: true,
                    fontSize: 30,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                  vSpace48,
                  Row(
                    children: <Widget>[
                      SuperButton.icon(
                          onPressed: () {
                            mShowToastError('Credit card payment is not available at this time');
                          },
                          icon: const Icon(Icons.add_circle),
                          label: const Txt('Add Cash')),
                      hSpace16,
                      SuperButton.icon(
                          onPressed: () {
                            Get.to(() => AddVoucherScreen());
                          },
                          icon: const Icon(Icons.add_circle),
                          label: const Txt('Add Voucher')),
                    ],
                  ),
                  vSpace8,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
