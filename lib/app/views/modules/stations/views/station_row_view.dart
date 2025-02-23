import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../models/station_model.dart';
import '../../../widgets/my_tile.dart';
import '../../osm/super_osm_manager.dart';

class StationRowView extends StatelessWidget {
  const StationRowView(this.stationModel, {super.key});

  final StationModel stationModel;

  @override
  Widget build(BuildContext context) {
    return MyTile(
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Txt(
            stationModel.name,
            isBold: true,
            fontSize: 16,
            letterSpacing: 2,
          ),
          Txt(stationModel.description),
          Txt(stationModel.address),
          Txt('${stationModel.distanceKM?.toStringAsFixed(2)} KM * ${stationModel.durationMin?.toStringAsFixed(2)} minutes'),
        ],
      ),
      trailing: SuperDecoratedContainer(
          borderRadius: 30,
          color: Get.theme.primaryColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: IconButton(
              icon: Icon(Icons.directions,
                  size: 30, color: Get.theme.primaryColor),
              onPressed: () {
                if (stationModel.latLong != null) {
                  SuperOSMManager.openGoogleMapFromLatLong(
                      stationModel.latLong!);
                }
              },
            ),
          )),
    );
  }
}
