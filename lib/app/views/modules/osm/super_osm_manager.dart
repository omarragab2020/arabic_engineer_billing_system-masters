import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:almuandes_billing_system/core/utils/app_assets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mp;
import 'package:http_parser/http_parser.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../../models/location_model.dart';
import 'super_osm_picker/super_osm_picker_controller.dart';

class SuperOSMManager extends GetxService {
  static SuperOSMManager get to => Get.find();

  SuperOSMManager();

  SuperOSMManager.init() {
    Get.put<SuperOSMManager>(this, permanent: true);
  }

  // late SuperOsmPickerController _superOsmPickerController;
  // SuperOsmPickerController get superOsmPickerController => _superOsmPickerController;

  ///region Vars
  final _gpsPosition = Rxn<GeoPoint>();

  GeoPoint? get gpsPosition => _gpsPosition.value;

  set gpsPosition(GeoPoint? val) => _gpsPosition.value = val;

  ///endregion Vars

  /// Generates a list of neighboring locations within a given radius from a specified LatLng point.
  ///
  /// [origin] - The original location from which to generate neighbors.
  /// [numberOfPoints] - The number of neighboring points to generate.
  /// [radiusInKm] - The radius in kilometers within which the neighboring points should be generated.
  ///
  /// Returns a list of LatLng objects representing the neighboring locations.
  List<LatLng> generateNeighboringLocations({
    required LatLng origin,
    int numberOfPoints = 10,
    double radiusInKm = 10.0,
  }) {
    const double earthRadiusKm = 6371.0;
    final List<LatLng> locations = [];

    final random = Random();

    for (int i = 0; i < numberOfPoints; i++) {
      // Convert radius from kilometers to radians
      double radiusInRadians = radiusInKm / earthRadiusKm;

      // Random distance from the origin (0 to radius)
      double distance = radiusInRadians * sqrt(random.nextDouble());

      // Random bearing (angle) in radians
      double bearing = random.nextDouble() * 2 * pi;

      double originLat = origin.latitudeInRad;
      double originLng = origin.longitudeInRad;

      double newLat = asin(sin(originLat) * cos(distance) +
          cos(originLat) * sin(distance) * cos(bearing));
      double newLng = originLng +
          atan2(sin(bearing) * sin(distance) * cos(originLat),
              cos(distance) - sin(originLat) * sin(newLat));

      // Convert back to degrees
      newLat = newLat * (180.0 / pi);
      newLng = newLng * (180.0 / pi);

      // Add the new location to the list
      locations.add(LatLng(newLat, newLng));
    }

    return locations;
  }

  Future<GeoPoint?> getCurrentPosition(
      {LocationAccuracy locationAccuracy = LocationAccuracy.best}) async {
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: locationAccuracy, timeLimit: 5.seconds);
    } on Exception catch (e) {
      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high, timeLimit: 10.seconds);
      } on Exception catch (e) {
        try {
          position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium,
              timeLimit: 15.seconds,
              forceAndroidLocationManager: true);
        } on Exception catch (e) {
          position = await Geolocator.getLastKnownPosition();
        }
      }
    }
    if (position == null) return null;

    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }

  initAll() async {
    gpsPosition =
        GeoPoint(latitude: 32.55670430051541, longitude: 35.84727275554576);
    GeoPoint? geoPoint =
        await getCurrentPosition(locationAccuracy: LocationAccuracy.best);
    if (geoPoint != null) {
      gpsPosition = geoPoint;
    }
    mPrint('gpsPosition = $gpsPosition');
  }

  @override
  void onInit() {
    initAll();
    super.onInit();
  }

  static Future<void> openGoogleMapFromLatLng(LatLng latLng) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
    launchStringURL(googleUrl);
  }

  static Future<void> openGoogleMapFromLatLong(LatLong latLng) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
    launchStringURL(googleUrl);
  }

  static Future<void> openGoogleMapFromLatAndLng(
      double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    launchStringURL(googleUrl);
  }

  static Future<void> openGoogleMapFromLocation(
      LocationModel locationModel) async {
    if (locationModel.lat != null && locationModel.lng != null) {
      openGoogleMapFromLatAndLng(locationModel.lat!, locationModel.lng!);
    } else {
      mPrintError('locationModel lat or lng null');
    }
  }

  static double calculateDistanceBetween2LocInKM(
      LocationModel locationModel1, LocationModel locationModel2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((locationModel2.lat! - locationModel1.lat!) * p) / 2 +
        c(locationModel1.lat! * p) *
            c(locationModel2.lat! * p) *
            (1 - c((locationModel2.lng! - locationModel1.lng!) * p)) /
            2;
    return 12742.0 * asin(sqrt(a));
  }

  static Future<double> calculateDistanceInMeterFromGoogleAPI(
      LocationModel locationModel1, LocationModel locationModel2) async {
    return calculateDistanceBetween2LocInKM(locationModel1, locationModel2);
    // String url = "https://maps.googleapis.com/maps/api/distancematrix/json?"
    //     "origins=${locationModel1.lat}%2C${locationModel1.lng}"
    //     "&destinations=${locationModel2.lat}%2C${locationModel2.lng}"
    //     "&key=$mapApiKey";
    //
    // http.Response response = await http.post(Uri.parse(url));
    // try {
    //   if (response.statusCode == 200) {
    //     Map<String, dynamic> bodyMap = jsonDecode(response.body);
    //     // mPrint('Distance: ${response.body}');
    //     return double.tryParse(((bodyMap['rows'] as List).first['elements'] as List).first['distance']['value'].toString()) ?? 0.0;
    //   }
    // } catch (e) {
    //   mPrintError('Exception $e');
    // }
    // return calculateDistanceBetween2LocInKM(locationModel1, locationModel2);
  }

  // static Future<List<PickResult>> getAbuZeitLocations() async {
  //   String url = "https://ultimate.abuzeit.com/items/map_data/";
  //
  //   try {
  //     http.Response response = await http.get(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  //     if (response.statusCode == 200) {
  //       List<Map<String, dynamic>> bodyMap = jsonDecode(response.body);
  //       List<PickResult> result = PickResult().fromMapList2(bodyMap);
  //       return result;
  //     }
  //   } on Exception catch (e) {
  //     mPrintError('Exception $e');
  //   }
  //   return [];
  // }

  static const String token = '-DGP10zL_8NV642P8b5XBryJ-0PI2ptr';
  static Map<String, String> abuzeitHeaders = {
    HttpHeaders.authorizationHeader: 'Bearer $token',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  static Future<List<LocationModel>> getAbuZeitLocations2() async {
    String url = "https://ultimate.abuzeit.com/items/map_data/";

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: abuzeitHeaders);
      mPrint('response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> bodyMap = jsonDecode(response.body);
        List<dynamic> bodyMapList = bodyMap['data'];
        List<LocationModel> list = [];
        // for (var element in bodyMapList) {
        //   PickResult result = PickResult.fromMap((element as Map<String, dynamic>).camelCaseKeys());
        //   LocationModel loc = LocationModel.fromPickResult(result);
        //   loc.description = element['Description'];
        //   loc.image = element['image'] ?? element['icon'];
        //   list.add(loc);
        // }

        return list;
      }
    } on Exception catch (e) {
      mPrintError('Exception $e');
    }
    return [];
  }

  // static Future<List<PickResult>> searchAbuZeitLocations(String searchStr) async {
  //   String url = "https://ultimate.abuzeit.com/items/map_data/?fields=*&search=$searchStr";
  //   try {
  //     http.Response response = await http.get(Uri.parse(url), headers: abuzeitHeaders);
  //     if (response.statusCode == 200) {
  //       List<dynamic> bodyList = (jsonDecode(response.body))['data'];
  //       List<Map<String, dynamic>> bodyMapList = [];
  //       bodyMapList.addAll(bodyList.map((e) => e as Map<String, dynamic>).toList());
  //       mPrint('bodyMapList = $bodyMapList');
  //       List<PickResult> result = PickResult().fromMapList2(bodyMapList);
  //       // for (PickResult pickResult in PickResult.fromMapList(bodyMapList)) {
  //       //   if (result.indexWhere((element) => element.id == pickResult.id) == -1) {
  //       //     result.add(pickResult);
  //       //   }
  //       // }
  //       return result;
  //     }
  //   } on Exception catch (e) {
  //     mPrintError('Exception $e');
  //   }
  //   return [];
  // }

  // static Future<bool> addAbuZeitPickResult(PickResult pickResult) async {
  //   String url = "https://ultimate.abuzeit.com/items/map_data/";
  //
  //   try {
  //     Map<String, dynamic> map = {};
  //
  //     pickResult.toMap().forEach((key, value) {
  //       map[GetUtils.snakeCase(key)!] = value;
  //     });
  //     map['geometry'] = pickResult.geometry?.toMap2(HomeController.to.reverseLatLng);
  //     mPrint('map = ${json.encode(map)}');
  //     // Clipboard.setData(ClipboardData(text: json.encode(map)));
  //     // return false;
  //
  //     http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //       body: json.encode(map),
  //     );
  //
  //     ///:{"coordinates":[31.16345471357503,32.00696665794375],
  //     ///:{"coordinates":[32.00696665794375,31.16345471357503],
  //     if (response.statusCode == 200) {
  //       // List<Map<String, dynamic>> bodyMap = jsonDecode(response.body);
  //       // List<PickResult> result = PickResult.fromMapList(bodyMap);
  //       return true;
  //     }
  //   } on Exception catch (e) {
  //     mPrintError('Exception $e');
  //   }
  //   return false;
  // }

  static Future<bool> addAbuZeitLocation(LocationModel locationModel,
      {File? imgFile, String? description}) async {
    String url = "https://ultimate.abuzeit.com/items/map_data/";

    try {
      String? id;
      if (imgFile != null)
        id = await SuperOSMManager.uploadAbuZeitImage(imgFile);

      Map<String, dynamic> map = {
        'Description': description,
        'icon': id,
        'image': id,
        'geometry': {
          'type': 'Point',
          'coordinates': [locationModel.lat, locationModel.lng]
        },
        'formatted_address': locationModel.address,
        'address_components': [
          if (!locationModel.plusCode.isNullOrEmptyOrWhiteSpace)
            {
              "types": ["plus_code"],
              "long_name": "${locationModel.plusCode}",
              "short_name": "${locationModel.plusCode}",
            },
          if (!locationModel.administrativeArea.isNullOrEmptyOrWhiteSpace)
            {
              "types": ["administrative_area_level_1"],
              "long_name": "${locationModel.administrativeArea}",
              "short_name": "${locationModel.administrativeArea}",
            },
          if (!locationModel.subAdministrativeArea.isNullOrEmptyOrWhiteSpace)
            {
              "types": ["administrative_area_level_2"],
              "long_name": "${locationModel.subAdministrativeArea}",
              "short_name": "${locationModel.subAdministrativeArea}",
            },
          if (!locationModel.country.isNullOrEmptyOrWhiteSpace)
            {
              "types": ["country"],
              "long_name": "${locationModel.country}",
              "short_name": "${locationModel.country}",
            },
        ],
      };
      mPrint('map = ${json.encode(map)}');
      // Clipboard.setData(ClipboardData(text: json.encode(map)));
      // return false;

      http.Response response = await http.post(
        Uri.parse(url),
        headers: abuzeitHeaders,
        body: json.encode(map),
      );
      mPrint('response = ${response.statusCode} - ${response.body}');

      ///:{"coordinates":[31.16345471357503,32.00696665794375],
      ///:{"coordinates":[32.00696665794375,31.16345471357503],
      if (response.statusCode == 200) {
        Map<String, dynamic> bodyMap = jsonDecode(response.body);
        int id = bodyMap['data']['id'];
        mPrint('id = $id');
        // List<PickResult> result = PickResult.fromMapList(bodyMap);
        return true;
      }
    } on Exception catch (e) {
      mPrintError('Exception $e');
    }
    return false;
  }

  static Future<String?> uploadAbuZeitImage(File file, [String? loc]) async {
    mPrint('uploadAbuZeitImage is called');
    mPrint('File path = ${file.path}');
    // String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    String fileName = file.path.split('/').last;
    String imageType = fileName.split('.').last;
    if (fileName.isNullOrEmptyOrWhiteSpace)
      fileName = DateTime.now().microsecondsSinceEpoch.toString();

    final httpImage = await http.MultipartFile.fromPath('', file.path,
        contentType: MediaType('image', imageType));

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse('https://ultimate.abuzeit.com/files'));
      request.fields.addAll({
        'title': fileName,
        'description': 'DESC1',
        'location': loc ?? 'Irbid'
      });
      request.files.add(httpImage);
      request.headers.addAll(abuzeitHeaders);
      mPrint(
          'request = ${request.fields} - ${request.files} - ${request.headers}');
      http.StreamedResponse response = await request.send();
      String resp = await response.stream.bytesToString();
      mPrint('response = ${response.statusCode} - $resp');
      if (response.statusCode == 200) {
        mPrint("Uploaded!");
        var serverJson = jsonDecode(resp);
        String id = serverJson['data']['id'].toString();
        mPrint('id = $id');
        return id;
      }
    } catch (error) {
      mPrint("Upload error: $error");
      return null;
    }
    return null;
  }

  static Future<String?> uploadAbuZeitImage2(File file, [String? loc]) async {
    var headers = {'Authorization': 'Bearer -DGP10zL_8NV642P8b5XBryJ-0PI2ptr'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ultimate.abuzeit.com/files'));
    request.fields.addAll({'title': 't', 'description': 'desc'});
    request.files.add(await http.MultipartFile.fromPath('', file.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      mPrint(await response.stream.bytesToString());
    } else {
      mPrint(response.reasonPhrase);
    }

    return null;
  }
}

MarkerIcon pickMarker = MarkerIcon(
  assetMarker: AssetMarker(
    image: const AssetImage(AppAssets.pin),
  ),
);

MarkerIcon fromMarker = MarkerIcon(
  assetMarker: AssetMarker(
    image: const AssetImage(AppAssets.pinFrom),
    scaleAssetImage: 0.7,
  ),
);

MarkerIcon toMarker = MarkerIcon(
  assetMarker: AssetMarker(
    image: const AssetImage(AppAssets.pinTo),
    scaleAssetImage: 0.7,
  ),
);

MarkerIcon gpsMarker = const MarkerIcon(
  icon: Icon(
    Icons.person_pin_circle_sharp,
    color: Colors.indigo,
    size: 96,
  ),
);
