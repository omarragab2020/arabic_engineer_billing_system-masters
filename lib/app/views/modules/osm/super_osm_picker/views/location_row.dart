import 'package:almuandes_billing_system/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../../controllers/app_controller.dart';
import '../../../../../models/location_model.dart';
import 'map_btn.dart';

// ignore: must_be_immutable
class LocationRow extends GetView<AppController> {
  LocationRow(
      {LocationModel? locationModel,
      this.onChanged,
      this.label = 'Leaving from',
      this.selectText = 'Select place',
      this.enableChange = true,
      this.enableLabelClick = false,
      LocationModel? initialLoc,
      super.key}) {
    this.locationModel = locationModel;
    this.initialLoc ??= initialLoc ?? locationModel;
  }

  final Rxn<LocationModel> _locationModel = Rxn<LocationModel>();

  LocationModel? get locationModel => _locationModel.value;

  set locationModel(LocationModel? val) => _locationModel.value = val;

  final Rxn<LocationModel> _initialLoc = Rxn<LocationModel>();

  LocationModel? get initialLoc => _initialLoc.value;

  set initialLoc(LocationModel? val) => _initialLoc.value = val;

  void Function(LocationModel?)? onChanged;
  final String label, selectText;
  final bool enableChange, enableLabelClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enableChange
          ? () {
              // Get.to(() => SuperOSMPicker(
              //       // controller: controller.superOSMPickerController,
              //       initialPoint: initialLoc?.toGeoPoint ?? SuperOSMManager.to.gpsPosition,
              //       selectText: selectText.tr,
              //       onPicked: (LocationModel? loc) {
              //         locationModel = loc;
              //         mShowToast("Location picked".tr);
              //         onChanged?.call(locationModel!);
              //         Get.back();
              //       },
              //     ));
              ///lat: 32.55206793472388, lng: 35.87744589499908,
              // Get.to(() => SuperOSMView2(
              //     initialPoint: initialLoc?.toGeoPoint ?? SuperOSMManager.to.gpsPosition,
              //     onPicked: (loc) {
              //       mPrint('Location = $loc');
              //       locationModel = loc;
              //       mShowToast("Location picked".tr);
              //       onChanged?.call(locationModel!);
              //       Get.back();
              //     }));
            }
          : enableLabelClick
              ? () {
                  // LocationService.openGoogleMapFromLocation(locationModel!);
                }
              : null,
      child: SuperDecoratedContainer(
        color: Colors.white,
        borderRadius: 16,
        borderColor: Get.theme.primaryColor,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (!enableChange)
              Obx(() {
                return MapButton(locationModel: locationModel);
              }),
            const Icon(Icons.map),
            hSpace8,
            Expanded(
              child: Obx(() {
                if (locationModel == null) {
                  return Txt(label, textAlign: LanguageService.to.textAlign, color: AppColors.appMainTextColor);
                } else {
                  return SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: Txt(
                          '${label.split(' ').last.toUpperCase()}: ${locationModel!.address! ?? (locationModel!.subAdministrativeArea ?? locationModel!.administrativeArea)}',
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          color: AppColors.appMainTextColor));
                }
              }),
            ),
            if (enableChange)
              Obx(() {
                if (locationModel != null) {
                  return IconButton(
                      onPressed: () {
                        showConfirmationDialog(
                            msg: 'You want to remove this location?',
                            function: () {
                              onChanged?.call(null);
                            });
                      },
                      icon: const Icon(Icons.clear));
                }
                return const SizedBox();
              })
          ],
        ),
      ),
    );
  }
}
