import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../models/location_model.dart';
import '../../super_osm_manager.dart';

class MapButton extends StatelessWidget {
  const MapButton({super.key, this.locationModel});
  final LocationModel? locationModel;

  @override
  Widget build(BuildContext context) {
    return locationModel == null
        ? const SizedBox(width: 0)
        : IconButton(
            onPressed: () {
              if (locationModel != null) {
                SuperOSMManager.openGoogleMapFromLocation(locationModel!);
              }
            },
            icon: FaIcon(FontAwesomeIcons.mapLocationDot, color: Get.theme.primaryColor));
  }
}
