import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';

import '../../models/location_picked_data.dart';

class FlutterMapLocationPicker extends StatelessWidget {
  const FlutterMapLocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      body: FlutterLocationPicker(
          initPosition: const LatLong(32.55670430051541, 35.84727275554576),
          selectLocationButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blue),
          ),
          selectedLocationButtonTextStyle: const TextStyle(fontSize: 18),
          selectLocationButtonText: 'Set Current Location',
          selectLocationButtonLeadingIcon: const Icon(Icons.check),
          zoomButtonsBackgroundColor: Colors.white70,
          initZoom: 11,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          trackMyPosition: true,
          onError: mPrintException,
          onPicked: (pickedData) {
            LocationPickedDataModel loc =
                LocationPickedDataModel.fromPickedData(pickedData);
            mPrint2(loc.toJson());
          },
          onChanged: (pickedData) {
            LocationPickedDataModel loc =
                LocationPickedDataModel.fromPickedData(pickedData);
            mPrint2(loc.toJson());
          }),
    );
  }
}
