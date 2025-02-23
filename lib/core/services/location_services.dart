import 'dart:convert';
import 'dart:math';

import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:dart_extensions/dart_extensions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
import 'package:google_maps_webservice/src/geocoding.dart';
import 'package:latlong2/latlong.dart';

// import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as lp;
import 'package:neuss_utils/home/home.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';

import '../../app/controllers/app_controller.dart';
import '../../app/models/location_model.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_webservice;
import 'package:google_api_headers/google_api_headers.dart';

import '../routes/app_pages.dart';

class LocationService extends GetxService {
  static LocationService get to => Get.find();

  final lp.Location location = lp.Location();
  late final google_maps_webservice.GoogleMapsPlaces places;
  late final GoogleMapsGeocoding geocoding;

  static const LatLng initialLatLng =
      LatLng(32.55670430051541, 35.84727275554576);

  final _userLatLng =
      LatLng(initialLatLng.latitude, initialLatLng.longitude).obs;

  LatLng get userLatLng => _userLatLng.value;

  set userLatLng(LatLng val) => _userLatLng.value = val;

  Future<bool> requestTrackingAuthorization() async {
    return true;
    // if (GetPlatform.isAndroid) return true;
    // TrackingStatus trackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    // return (trackingStatus == TrackingStatus.authorized);
  }

  bool apiInit = false;

  initApi() async {
    if (apiInit) return;
    mPrint('initApi');
    final apiHeaders = await const GoogleApiHeaders().getHeaders();
    places = google_maps_webservice.GoogleMapsPlaces(
      apiKey: AppController.to.adminDataModel.mapPlacesApiKey,
      // apiKey: AppController.to.adminDataModel.mapPlacesApiKey,
      apiHeaders: apiHeaders,
    );

    geocoding = GoogleMapsGeocoding(
      // apiKey: 'AIzaSyBRgWpRibo6HEjsgfX35HvzVC6pB7vR-1c',
      apiKey: AppController.to.adminDataModel.mapGeocodingApiKey,
      apiHeaders: apiHeaders,
    );

    userLatLng = AppController.to.adminDataModel.defaultLatLng;
    mPrint('defaultLatLng = $userLatLng');
    apiInit = true;
  }

  bool isInit = false;

  Future<bool> initAll() async {
    // await getUserLocation();
    return true;
    if (isInit) return true;
    try {
      bool b = await initPermissions();
      if (b) {
        b = await requestTrackingAuthorization();
        if (!b) {
          mShowToast('Unable to get your location. Please allow it');
          return false;
        }
      } else {
        mShowToast('Unable to get your location. Please allow permissions');
        return false;
      }
    } on Exception catch (e) {
      mPrintError('initPermissions exception $e');
      return false;
    }

    isInit = true;
    await getUserLocation();
    return true;
  }

  LatLng computeCentroid(Iterable<LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    if (n == 1) {
      return points.first;
    } else {
      for (LatLng point in points) {
        latitude += point.latitude;
        longitude += point.longitude;
      }
    }

    return LatLng(latitude / n, longitude / n);
  }

  Future<bool> initPermissions() async {
    bool serviceEnabled;
    lp.PermissionStatus permissionGranted;

    void checkRouting() {
      if (Get.currentRoute == Routes.SPLASH) {
        Get.offNamed(Routes.SPLASH, preventDuplicates: false);
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
      checkRouting();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == lp.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != lp.PermissionStatus.granted) {
        return false;
      }
      checkRouting();
    }
    return true;
  }

  Future<void> getUserLocation() async {
    initAll();
    try {
      lp.LocationData locationData = await location.getLocation();
      userLatLng = LatLng(locationData.latitude!, locationData.longitude!);
    } on Exception {
      // TODO
    }
  }

  Future<LocationModel?> getFullPlaceDetailsFromLatLng(LatLng latLng,
      [bool usePlaceDetailSearch = true]) async {
    late GeocodingResponse response;
    try {
      mPrint('Test 1 (${LocationService.to.geocoding.apiKey})');
      response = await geocoding.searchByLocation(
        google_maps_webservice.Location(
            lat: latLng.latitude, lng: latLng.longitude),
        // language: 'en',
        language: LanguageService.to.currentLanguage,
      );
    } on Exception catch (e) {
      mPrintError("Exception searchByLocation $e");
      return null;
    }

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      mPrint("Camera Location Search Error: ${response.errorMessage!}");
      return null;
    }

    if (usePlaceDetailSearch) {
      final google_maps_webservice.PlacesDetailsResponse detailResponse =
          await places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: LanguageService.to.currentLanguage,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        mPrint(
            "Fetching details by placeId Error: ${detailResponse.errorMessage!}");
        return null;
      }
      // return LocationModel.fromPickResult(PickResult.fromPlaceDetailResult(detailResponse.result));
    }
    return null;
    // else {
    //   return LocationModel.fromPickResult(PickResult.fromGeocodingResult(response.results[0]));
    // }
  }

  Future<LocationModel?> getPlaceDetailsFromLatLng(LatLng latLng) async {
    Future<LocationModel?> ll() async {
      try {
        List<Placemark> placeMarks =
            await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        if (!placeMarks.isEmptyOrNull) {
          return LocationModel.fromMap(placeMarks.first.toJson());
        }
      } on Exception catch (e) {
        mPrintError('Exception $e');
      }
      return null;
    }

    LocationModel? l;
    try {
      l ??= await ll();
      l ??= await ll();
      await 0.5.seconds.delay(() async {
        l ??= await ll();
      });
    } on Exception catch (e) {
      mPrintError('Exception $e');
    }
    return l;
  }

  Future<LocationModel?> getPlaceDetailsFromLocationModel(
      LocationModel locationModel) async {
    Future<LocationModel?> ll() async {
      try {
        if (!locationModel.hasLatLng) return null;
        LatLng? latLng = locationModel.toLatLng;
        if (latLng == null) return null;

        List<Placemark> placeMarks =
            await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        if (!placeMarks.isEmptyOrNull) {
          locationModel.updateFromMap(placeMarks.first.toJson());
        }
        return locationModel;
      } on Exception catch (e) {
        mPrintError('Exception $e');
      }
      return null;
    }

    LocationModel? l;
    try {
      l ??= await ll();
      l ??= await ll();
      l ??= await ll();
    } on Exception catch (e) {
      mPrintError('Exception $e');
    }
    return l;
  }

  Future<LocationModel?> getFullPlaceDetailsFromLocationModel(
      LocationModel locationModel) async {
    Future<LocationModel?> ll() async {
      try {
        if (!locationModel.hasLatLng) return null;
        LatLng? latLng = locationModel.toLatLng;
        if (latLng == null) return null;

        LocationModel? x = await getFullPlaceDetailsFromLatLng(latLng);
        if (x != null) {
          locationModel.updateFrom(another: x);
          return locationModel;
        }
      } on Exception catch (e) {
        mPrintError('Exception $e');
      }
      return null;
    }

    LocationModel? l;
    try {
      l ??= await ll();
      l ??= await ll();
      l ??= await ll();
    } on Exception catch (e) {
      mPrintError('Exception $e');
    }
    return l;
  }

  void getPlaceMarksFromLatLng(LatLng latLng) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    for (Placemark placeMark in placeMarks) {
      mPrint('placeMark = ${jsonEncode(placeMark.toJson())}');
    }
  }

  void getPlaceMarksFromLatAndLng(double lat, double lng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    for (Placemark placeMark in placeMarks) {
      mPrint('placeMark = ${placeMark.toJson()}');
    }
  }

  Future<void> openGoogleMapFromLatLng(
      double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    launchStringURL(googleUrl);
  }

  Future<void> openGoogleMapFromLatLngs(List<List<double>> latLngs) async {
    String googleUrl;
    if (latLngs.length > 1) {
      googleUrl =
          'https://www.google.de/maps/dir/${latLngs.map((e) => e.join(',')).join('/')}';
    } else {
      googleUrl =
          'https://www.google.de/maps/search/${latLngs.map((e) => e.join(',')).join('/')}';
    }
    mPrint('Map Url = $googleUrl');
    launchStringURL(googleUrl);
  }

  Future<void> openGoogleMapFromLocation(LocationModel locationModel,
      [int ind = 0]) async {
    // if (locationModel.geo?.coordinates?[ind].hasData == true) {
    // mPrint('locationModel geo = ${locationModel.geo}');
    // if (locationModel.geo?.coordinates.hasData == true) {
    //   openGoogleMapFromLatLngs(locationModel.geo!.coordinates!);
    //   // openGoogleMapFromLatLng(locationModel.geo!.coordinates![ind][0], locationModel.geo!.coordinates![ind][1]);
    // } else {
    //   mPrintError('locationModel lat or lng null');
    // }
  }

  Future<double> calculateDistanceInMeterFromGoogleAPI(
      LocationModel locationModel1, LocationModel locationModel2) async {
    // String url = "https://maps.googleapis.com/maps/api/distancematrix/json?"
    //     "origins=${locationModel1.lat}%2C${locationModel1.lng}"
    //     "&destinations=${locationModel2.lat}%2C${locationModel2.lng}"
    //     "&key=$mapDistanceApiKey";
    //
    // http.Response response = await http.post(Uri.parse(url));
    // // mPrint('response ${response.statusCode} - $mapDistanceApiKey - ${response.body}');
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> bodyMap = jsonDecode(response.body);
    //   // mPrint('Distance: ${response.body}');
    //   if (bodyMap.containsKey('rows')) {
    //     var rows = (bodyMap['rows'] as List);
    //     if (rows.hasData) {
    //       var elements = (rows.first['elements'] as List);
    //       if (elements.hasData) {
    //         return double.tryParse((elements.first['distance']?['value'] ?? '0.0').toString()) ?? 0.0;
    //       }
    //       return 0.0;
    //     }
    //     return 0.0;
    //   }
    //   return 0.0;
    // }
    return 0.0;
  }

  ///

  static const double EARTH_RADIUS = 6371.0;

  double toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double getBestZoomLevel(LatLng latLng1, LatLng latLng2) {
    double lat1 = toRadians(latLng1.latitude);
    double lon1 = toRadians(latLng1.longitude);
    double lat2 = toRadians(latLng2.latitude);
    double lon2 = toRadians(latLng2.longitude);

    // Haversine formula to calculate the distance between two points on the Earth's surface
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = EARTH_RADIUS * c;

    double zoomLevel = 15 - log(distance) / log(2);

    return zoomLevel;
  }
}
