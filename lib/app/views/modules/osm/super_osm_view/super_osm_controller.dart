import 'dart:convert';

import 'package:almuandes_billing_system/app/controllers/app_controller.dart';
import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';

import '../../../../models/location_model.dart';
import '../super_osm_manager.dart';

class SuperOSMController {
  LatLng? initialPoint;

  SuperOSMController({this.initialPoint}) {
    // initAll();
  }

  ///region Vars

  final _gpsPosition = Rxn<LatLng>();

  LatLng? get gpsPosition => _gpsPosition.value;

  set gpsPosition(LatLng? val) => _gpsPosition.value = val;

  final _currentPosition = LatLng(32.556573, 35.877716).obs;

  LatLng get currentPosition => _currentPosition.value;

  LatLng get currentPositionReversed => LatLng(currentPosition.longitude, currentPosition.latitude);

  set currentPosition(LatLng val) => _currentPosition.value = val;

  final _lastLocation = Rxn<LocationModel>();

  LocationModel? get lastLocation => _lastLocation.value;

  set lastLocation(LocationModel? val) => _lastLocation.value = val;

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool val) => _isLoading.value = val;

  LatLng? lastGeoPoint;

  final _mapController = MapController().obs;

  MapController get mapController => _mapController.value;

  set mapController(MapController val) => _mapController.value = val;

  final _init = false.obs;

  bool get init => _init.value;

  set init(bool val) => _init.value = val;

  final _init2 = false.obs;

  bool get init2 => _init2.value;

  set init2(bool val) => _init2.value = val;

  final _locationsList = <LocationModel>[].obs;

  List<LocationModel> get locationsList => _locationsList;

  set locationsList(List<LocationModel> val) => _locationsList.value = val;

  final _markerList = <Marker>[].obs;

  List<Marker> get markerList => _markerList;

  set markerList(List<Marker> val) => _markerList.value = val;

  final Rxn<LocationModel> _selectedLocationForTooltip = Rxn<LocationModel>();

  LocationModel? get selectedLocationForTooltip => _selectedLocationForTooltip.value;

  set selectedLocationForTooltip(LocationModel? val) => {_selectedLocationForTooltip.value = val, _selectedLocationForTooltip.refresh()};

  final _popupController = PopupController().obs;

  PopupController get popupLayerController => _popupController.value;

  set popupLayerController(PopupController val) => _popupController.value = val;

  final _curZoom = 16.0.obs;

  double get curZoom => _curZoom.value;

  set curZoom(double val) => _curZoom.value = val;

  final _curCenter = LatLng(33.3, 40).obs;

  LatLng get curCenter => _curCenter.value;

  set curCenter(LatLng val) => _curCenter.value = val;

  ///endregion Vars

  Marker getMarker(LocationModel locModel, [Widget? markerIcon, Color? markerColor]) {
    return Marker(
      width: 50,
      height: 50,
      point: LatLng(locModel.lat!, locModel.lng!),
      alignment: Alignment.topCenter,
      child: markerIcon ?? FaIcon(FontAwesomeIcons.box, color: markerColor ?? Colors.red, size: 45),
    );
  }

  Future<void> addMarker(LocationModel locModel, {Widget? markerIcon}) async {
    _markerList.add(getMarker(locModel, markerIcon));
  }

  addAllMarkers() async {
    mPrint('addAllMarkers');
    locationsList = await SuperOSMManager.getAbuZeitLocations2();
    if (locationsList.hasData) {
      locationsList = locationsList.map((e) => e.swapXY()!).toList();
    }
    mPrint('locationsList len = ${locationsList.length}');
    // mPrint('locationsList 0 = ${locationsList.first}');
    for (var readyLoc in locationsList) {
      await addMarker(readyLoc);
    }
  }

  Future<LatLng?> getCurrentPosition({LocationAccuracy locationAccuracy = LocationAccuracy.best}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracy);
    gpsPosition = LatLng(position.latitude, position.longitude);
    return gpsPosition;
  }

  initAll() async {
    init = false;
    mapController = MapController();
    await addAllMarkers();
    hideKeyboard(Get.context);
    lastLocation = null;
    // mShowLoading();
    if (SuperOSMManager.to.gpsPosition != null) {
      gpsPosition = LatLng(SuperOSMManager.to.gpsPosition!.latitude, SuperOSMManager.to.gpsPosition!.longitude);
    }
    mPrint('gpsPosition = $gpsPosition');
    currentPosition = (initialPoint ?? gpsPosition)!;
    mPrint('currentPosition = $currentPosition');

    hideKeyboard(Get.context);
    init = true;
    // update();
  }

  Future<void> selectPlace() async {
    lastLocation = null;
    isLoading = true;
    currentPosition = mapController.camera.center;
    lastLocation = await getPointDetails(currentPosition);
    isLoading = false;
    // update();
  }

  Future<LocationModel?> getPointDetails(LatLng geoPoint, [String? locale]) async {
    locale ??= LanguageService.to.currentLanguage;
    http.Response response = await http.get(
      Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?lat=${geoPoint.latitude}&lon=${geoPoint.longitude}&format=json&&accept-language=$locale"),
    );
    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);

      return LocationModel(
        lat: double.tryParse(map['lat']),
        lng: double.tryParse(map['lon']),
        address: map['display_name'],
        country: map['address']['country'],
        administrativeArea: map['address']['state'],
        plusCode: map['address']['postcode'],
      );
    }
    return null;
  }
}
