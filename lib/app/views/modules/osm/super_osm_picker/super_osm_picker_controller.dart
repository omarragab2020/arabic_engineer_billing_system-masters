import 'dart:convert';

import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/utils/helpers.dart';

import '../../../../models/location_model.dart';
import '../super_osm_manager.dart';

class SuperOSMPickerController {
  GeoPoint? initialPoint;
  SuperOSMPickerController({this.initialPoint}) {
    // initAll();
  }

  ///region Vars

  final _gpsPosition = Rxn<GeoPoint>();
  GeoPoint? get gpsPosition => _gpsPosition.value;
  set gpsPosition(GeoPoint? val) => _gpsPosition.value = val;

  final _currentPosition = Rxn<GeoPoint>();
  GeoPoint? get currentPosition => _currentPosition.value;
  set currentPosition(GeoPoint? val) => _currentPosition.value = val;

  final _lastLocation = Rxn<LocationModel>();
  LocationModel? get lastLocation => _lastLocation.value;
  set lastLocation(LocationModel? val) => _lastLocation.value = val;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;

  GeoPoint? lastGeoPoint;

  final _customTile = Rxn<CustomTile>();
  CustomTile? get customTile => _customTile.value;
  set customTile(CustomTile? val) => _customTile.value = val;

  final _mapController = Rxn<MapController>();
  MapController? get mapController => _mapController.value;
  set mapController(MapController? val) => _mapController.value = val;

  PickerMapController? pickerMapController;

  final _init = false.obs;
  bool get init => _init.value;

  set init(bool val) => _init.value = val;

  final _init2 = false.obs;

  bool get init2 => _init2.value;

  set init2(bool val) => _init2.value = val;

  final _locationsList = <LocationModel>[].obs;

  List<LocationModel> get locationsList => _locationsList;

  set locationsList(List<LocationModel> val) => _locationsList.value = val;

  final Rxn<LocationModel> _selectedLocationForTooltip = Rxn<LocationModel>();

  LocationModel? get selectedLocationForTooltip => _selectedLocationForTooltip.value;

  set selectedLocationForTooltip(LocationModel? val) => _selectedLocationForTooltip.value = val;

  ///endregion Vars

  Set<Marker> markerList = {};

  Future<void> addMarker(GeoPoint geoPoint, {MarkerIcon? markerIcon}) async {
    markerIcon ??= pickMarker;
    // markerList.add(geoPoint.googleMarker);
    await mapController!.addMarker(geoPoint, markerIcon: markerIcon);
    // await mapController!.setMarkerIcon(geoPoint, markerIcon);
  }

  addAllMarkers() async {
    // locationsList = await SuperOSMManager.getAbuZeitLocations2();
    // mPrint2('locationsList len = ${locationsList.length}');
    // mPrint2('locationsList 0 = ${locationsList.first}');
    // 1.seconds.delay(() async {
    //   for (var value1 in locationsList) {
    //     var readyLoc = value1.swapXY()!;
    //     await addMarker(readyLoc.toGeoPoint!,
    //         markerIcon: const MarkerIcon(
    //           icon: Icon(
    //             FontAwesomeIcons.box,
    //             color: Colors.red,
    //             size: 50,
    //           ),
    //           // iconWidget: GestureDetector(
    //           //   onTap: () {
    //           //     mPrint('Marker click');
    //           //     selectedLocationForTooltip = readyLoc;
    //           //   },
    //           //   child: const Icon(
    //           //     FontAwesomeIcons.box,
    //           //     color: Colors.red,
    //           //     size: 50,
    //           //   ),
    //           // ),
    //         ));
    //   }
    // });
  }

  Future<GeoPoint?> getCurrentPosition({LocationAccuracy locationAccuracy = LocationAccuracy.best}) async {
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
    gpsPosition = GeoPoint(latitude: position.latitude, longitude: position.longitude);
    return gpsPosition;
  }

  initAll() async {
    init = false;
    hideKeyboard();
    lastLocation = null;
    // mShowLoading();
    gpsPosition = SuperOSMManager.to.gpsPosition;
    mPrint('gpsPosition = $gpsPosition');
    currentPosition = (initialPoint ?? gpsPosition);
    mPrint('currentPosition = $currentPosition');
    mapController = MapController.withPosition(
      initPosition: currentPosition!,
    );
    mapController!.listenerRegionIsChanging.addListener(() async {
      if (mapController!.listenerRegionIsChanging.value != null) {
        currentPosition = mapController!.listenerRegionIsChanging.value?.center;
        lastLocation = null;
        isLoading = false;

        // if (lastGeoPoint != null) {
        //   mapController!.changeLocationMarker(
        //     oldLocation: lastGeoPoint!,
        //     newLocation: currentPosition!,
        //   );
        //   lastGeoPoint = currentPosition;
        // }
        // else {
        // GeoPoint point = GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude + 0.0000001);
        // await mapController!.addMarker(point, markerIcon: pickMarker);
        // await mapController!.setMarkerIcon(point, pickMarker);
        // lastGeoPoint = point;
        // }
        // update();
      }
    });
    hideKeyboard(Get.context);
    init = true;
    // update();
  }

  Future<void> selectPlace() async {
    lastLocation = null;
    isLoading = true;
    // update();
    lastLocation = await getPointDetails(currentPosition!);
    isLoading = false;
    // update();
  }

  Future<LocationModel?> getPointDetails(GeoPoint geoPoint, [String? locale]) async {
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

  changeTileLayer(CustomTile? tile) async {
    customTile = tile;
    await mapController!.changeTileLayer(tileLayer: customTile);
  }
}
