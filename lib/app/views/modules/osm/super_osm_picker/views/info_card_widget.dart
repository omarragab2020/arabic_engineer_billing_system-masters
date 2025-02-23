import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../../../../models/location_model.dart';

class InfoCard extends StatelessWidget {
  final controller;

  const InfoCard(this.controller, [this.selectText, this.onPicked, Key? key]) : super(key: key);

  // final SuperOSMPickerController controller;
  final String? selectText;
  final void Function(LocationModel?)? onPicked;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: Colors.white.withOpacity(0.8),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: SuperDecoratedContainer(
        // color: Colors.white.withOpacity(0.9),
        borderRadius: 16,
        padding: const EdgeInsets.all(8),
        // boxShadow: const [
        //   BoxShadow(color: Colors.grey, offset: Offset(1, 1), spreadRadius: 1, blurRadius: 4),
        // ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            vSpace16,

            Obx(() {
              if (controller.isLoading) {
                return const SizedBox(width: 24, height: 24, child: CircularProgressIndicator());
              } else if (controller.lastLocation != null) {
                return Txt(controller.lastLocation!.address ?? '', color: Colors.green);
              } else {
                return const SizedBox();
              }
            }),
            vSpace16,
            InkWell(
              onTap: () async {
                if (controller.lastLocation != null) {
                  mHide();
                  onPicked?.call((controller.lastLocation! as LocationModel));
                } else {
                  controller.selectPlace().whenComplete(() {
                    // mShowToast('Click again to confirm');
                    mHide();
                    onPicked?.call((controller.lastLocation! as LocationModel));
                  });
                }
                // controller.selectPlace().whenComplete(() {
                //   if (controller.lastLocation != null) {
                //     mShowLoading();
                //     1.seconds.delay(() {
                //       mHide();
                //       onPicked?.call(controller.lastLocation);
                //       controller.lastLocation = null;
                //       // Get.delete<SuperOSMPickerController>();
                //     });
                //   }
                // });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.explore_sharp, color: Colors.orange),
                  hSpace8,
                  Txt(selectText ?? 'Select place', color: Colors.orange),
                ],
              ),
            ),
            vSpace16
            // Text(selectText ?? 'Select place', style: TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
