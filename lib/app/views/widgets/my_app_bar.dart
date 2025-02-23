import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../core/routes/app_pages.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../controllers/app_controller.dart';

class MyAppBar extends GetView<AppController> implements PreferredSizeWidget {
  const MyAppBar({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // centerTitle: true,
      leading: IconButton(icon: const Icon(Icons.notifications, size: 40), onPressed: () {}),
      title: title == null
          ? null
          : Txt(
              title,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
      actions: [
        Obx(() {
          if (controller.successfullyLoggedIn) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: FilledButton(
                onPressed: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: const Txt("Login")),
          );
        })
        // InkWell(
        //   onTap: () {
        //     Get.toNamed(Routes.Notifications);
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //     child: Obx(() {
        //       int cnt = controller.myNotificationsList.where((element) => element.seen == false && element.userID != null).length;
        //       return Badge(
        //         label: Txt(
        //           cnt,
        //           fontSize: 16,
        //         ),
        //         largeSize: 20,
        //         isLabelVisible: cnt > 0,
        //         alignment: Alignment.topRight,
        //         child: const Icon(Icons.notifications, size: 30),
        //       );
        //     }),
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
