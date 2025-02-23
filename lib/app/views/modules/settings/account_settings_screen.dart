import 'package:almuandes_billing_system/app/views/modules/auth/profile_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/home/screens/base_main_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/others/no_data_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/widgets/src/app_button.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_language_btn.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMainScreen(
      title: 'Account Settings',
      child: Column(
        children: <Widget>[
          vSpace32,
          SuperDecoratedContainer(
            color: Colors.grey.shade200,
            borderRadius: 16,
            child: ProfileTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              title: 'Language',
              onTap: deleteProfile,
              trailing: SuperLanguageBtn(),
            ),
          ),
          vSpace32,
          SuperDecoratedContainer(
            color: Colors.grey.shade200,
            borderRadius: 16,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ProfileTile(
                title: 'Delete my account!',
                onTap: deleteProfile,
              ),
            ),
          ),
          vSpace32,
        ],
      ),
    );
  }

  void deleteProfile() {
    mShowToastError('To be done', displayTime: 1.seconds);
    return;
  }
}
