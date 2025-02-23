import 'package:flutter/material.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/widgets/src/app_button.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_edit_text.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';

class ForgetPassPage extends StatelessWidget {
  ForgetPassPage({required this.onSubmit, super.key});

  final void Function(String) onSubmit;
  final TextEditingController passController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SuperDecoratedContainer(
        color: Colors.white,
        borderRadius: 16,
        borderColor: AppColors.appLightPrimaryColor1,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            vSpace16,
            const Text("Change your password"),
            vSpace32,
            SuperEditText(
              passController,
              hint: AppStrings.passHint,
              prefixIconData: Icons.key,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              // fillColor: AppColors.authBgColor,
              obscureText: true,
            ),
            vSpace16,
            SuperEditText(
              pass2Controller,
              hint: AppStrings.passConfirmHint,
              prefixIconData: Icons.key,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              // fillColor: AppColors.authBgColor,
              obscureText: true,
            ),
            vSpace16,
            AppButton(
              txt: 'Update password',
              txtColor: Colors.white,
              fillColor: AppColors.appMainColor,
              onPressed: () {
                if (passController.text.trim() != pass2Controller.text.trim()) {
                  mShowToast("Passwords must be the same");
                  return;
                }
                mPrint('new password = ${passController.text.trim()}');
                onSubmit.call(passController.text.trim());
                mHide();
              },
            ),
            vSpace16,
          ],
        ),
      ),
    );
  }
}
