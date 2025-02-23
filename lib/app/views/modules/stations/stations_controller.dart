import 'dart:async';
import 'dart:math';

import 'package:almuandes_billing_system/app/controllers/app_controller.dart';
import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:meta/meta.dart';
import 'package:neuss_utils/image_utils/src/super_image_class.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../../../core/services/location_services.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import '../../../models/station_model.dart';
import '../osm/super_osm_manager.dart';

class StationsController extends GetxController {
  static StationsController get to => Get.find();

  ///region Vars
  final Rx<MapController> _mapController = MapController().obs;

  MapController get mapController => _mapController.value;

  set mapController(MapController val) => _mapController.value = val;

  final Rx<BoxController> _boxController = BoxController().obs;

  BoxController get boxController => _boxController.value;

  set boxController(BoxController val) => _boxController.value = val;

  void refreshAll() {
    _mapController.refresh();
    _boxController.refresh();
    update();
  }

  final TextEditingController textEditingController = TextEditingController();

  final _popupController = PopupController().obs;

  PopupController get popupController => _popupController.value;

  set popupController(PopupController val) => _popupController.value = val;

  final RxBool _selectedAreas = false.obs;

  bool get selectedAreas => _selectedAreas.value;

  set selectedAreas(dynamic val) => _selectedAreas.value = val;

  final RxList<Marker> _markers = <Marker>[].obs;

  List<Marker> get markers => _markers.value;

  set markers(List<Marker> val) => _markers.value = val;

  LatLng get defaultLatLng =>
      const LatLng(32.55670430051541, 35.84727275554576);

  // Marker get defaultMarker => generateMarker(defaultLatLng, 0);

  final _allStations = <StationModel>[].obs;

  List<StationModel> get allStations => _allStations.value;

  set allStations(List<StationModel> val) => _allStations.value = val;

  final _displayStations = <StationModel>[].obs;

  List<StationModel> get displayStations => _displayStations.value;

  set displayStations(List<StationModel> val) => _displayStations.value = val;

  final Rxn<StationModel> _selectedStation = Rxn<StationModel>();

  StationModel? get selectedStation => _selectedStation.value;

  set selectedStation(StationModel? val) => _selectedStation.value = val;

  ///endregion Vars

  StationModel? getMarkerStation(id) => allStations
      .firstWhereOrNull((station) => station.id.toString() == id.toString());

  Marker? getStationMarker(id) =>
      markers.firstWhereOrNull((marker) => marker.id == id.toString());

  void initMarkers() {
    for (StationModel e in allStations) {}
    markers.addAll(
      allStations.map((StationModel station) => generateMarker(station)),
    );
    mPrint2('markers len = ${markers.length}');
  }

  void initStations() {
    List<LatLong> latLongs = SuperOSMManager.to
        .generateNeighboringLocations(
          origin: LocationService.initialLatLng,
          numberOfPoints: 100,
          radiusInKm: 20,
        )
        .map((e) => e.latLong)
        .toList();
    Random random = Random();
    allStations = List.generate(
      100,
      (ind) => StationModel(
          id: ind + 1,
          name: 'Station ${ind + 1}',
          address: 'Address A${ind + 1}',
          description: "Description ${ind + 1}",
          latLong: latLongs[ind]),
    );
    displayStations = [...allStations];
  }

  @override
  void onInit() {
    initStations();
    initMarkers();
    super.onInit();
  }

  FutureOr<void> onWillPop(result) {
    boxController.isBoxOpen
        ? [boxController.closeBox(), _boxController.refresh()]
        : Get.back();
  }

  Marker generateMarker(StationModel station) {
    if (station.latLng == null) {
      station.latLong = defaultLatLng.latLong;
    }
    return Marker(
      key: ValueKey(station.id.toString()),
      point: station.latLng!,
      rotate: true,
      width: 50,
      height: 80,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          selectedStation = station;
          moveToLocation(station.latLng!, zoom: 15);
        },
        child: SuperDecoratedContainer(
          // padding: 2.allPadding,
          borderRadius: 24,
          color: Colors.white,
          borderColor: Get.theme.colorScheme.secondary,
          // color: Get.theme.colorScheme.secondary,
          child: Column(
            children: [
              const Expanded(
                child: SuperImageView(imgAssetPath: AppAssets.appIcon45),
              ),
              // vSpace4,
              Builder(builder: (context) {
                return Txt(station.id ?? '_',
                    fontSize: 16,
                    // color: Colors.white);
                    color: Get.theme.colorScheme.secondary);
              })
            ],
          ),
        ),
      ),
    );
  }

  void moveToUserLocation({double? zoom}) {
    zoom ??= mapController.camera.zoom < 14 ? 14 : mapController.camera.zoom;
    mapController.move(LocationService.to.userLatLng, zoom);
  }

  void moveToLocation(LatLng latLng, {double? zoom}) {
    mapController.move(latLng, zoom ?? mapController.camera.zoom);
  }
}
