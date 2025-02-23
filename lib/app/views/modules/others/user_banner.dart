import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/widgets/widgets.dart';

import '../../../../core/routes/app_pages.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../models/user_model.dart';

class UserBanner extends GetView<AppController> {
  const UserBanner({required this.userModel, super.key});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (controller.successfullyLoggedIn && controller.mUser?.id == userModel.id)
          ? () {
              Get.toNamed(Routes.PROFILEEDIT);
            }
          : null,
      child: SuperDecoratedContainer(
        width: Get.width,
        borderWidth: 1,
        borderColor: AppColors.appMainTextColor.withOpacity(0.3),
        borderRadius: 16,
        child: ListTile(
          leading: const SuperImageView(
            svgAssetPath: 'assets/images/student_icon.svg',
            fit: BoxFit.cover,
            shape: BoxShape.circle,
            color: Colors.white,
            width: 50,
            height: 50,
          ),
          title: Txt(
            userModel.first_name ?? 'Error',
            fontSize: 18,
            color: AppColors.appMainTextColor,
            textAlign: LanguageService.to.textAlign,
          ),
        ),
      ),
    );
  }
}
