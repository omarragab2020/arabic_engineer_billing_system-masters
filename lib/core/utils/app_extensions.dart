import 'dart:convert';
import 'dart:math';

import 'package:almuandes_billing_system/app/models/admin_data_model.dart';
import 'package:almuandes_billing_system/app/models/station_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:neuss_utils/home/src/language_service.dart';
import 'package:neuss_utils/utils/my_extensions.dart';

import '../../app/controllers/app_controller.dart';
import '../../app/models/location_model.dart';
import '../../app/models/user_model.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../services/location_services.dart';
import 'app_constants.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as ll2;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

extension UserModelExtension on UserModel {
  bool get isMe => id == AppController.to.mUserID;

  String get fullName => '$first_name ${last_name ?? ''}'.trim();

  bool get isArabic =>
      language.isNullOrEmptyOrWhiteSpace || language!.startsWith('ar');

  bool get isAdmin => role == AppConstants.roleAdmin;

  bool get isTeacher => role == AppConstants.roleTeacher;

  bool get isStudent => role == AppConstants.roleStudent;

  String get roleString => isTeacher
      ? 'Teacher'
      : isAdmin
          ? 'Admin'
          : 'Student';

  double get rating => rate == 0 ? 0 : point / rate;
}

extension AdminDataModelExtension on AdminDataModel {
  LatLng get defaultLatLng {
    if (mapDefaultPointLoad.isNullOrEmptyOrWhiteSpace ||
        !mapDefaultPointLoad!.contains(',')) ;
    List<double?> points =
        mapDefaultPointLoad!.split(',').map((e) => e.toDouble()).toList();
    if (points.length == 2) return LatLng.fromJson({'coordinates': points});

    return LocationService.initialLatLng;
  }
}

extension GeometryExtensions on Geometry {
  Map<String, dynamic> toMap2([bool reverse = false]) {
    return {
      'coordinates':
          reverse ? [location.lng, location.lat] : [location.lat, location.lng],
      'type': locationType ?? 'Point',
    };
  }
}

Future<LocationModel?> getPointDetails(GeoPoint geoPoint,
    [String? locale]) async {
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

extension GeoPointExtension on GeoPoint {
  LatLng get latLng => LatLng(latitude, longitude);

  ll2.LatLng get latLng2 => ll2.LatLng(latitude, longitude);

  LatLong get latLong => LatLong(latitude, longitude);

  String get markerId => (('$latitude-$longitude').toString());

  GeoPoint copyWithOther(GeoPoint other) =>
      GeoPoint(latitude: other.latitude, longitude: other.longitude);

  GeoPoint copyWith({double? latitude, double? longitude}) => GeoPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude);

  GeoPoint modify({double latitude = 0, double longitude = 0}) => GeoPoint(
      latitude: this.latitude + latitude,
      longitude: this.longitude + longitude);

  GeoPoint centerBetween(GeoPoint other) => GeoPoint(
      latitude: (latitude + other.latitude) / 2.0,
      longitude: (longitude + other.longitude) / 2.0);
}

//
// extension PickResultExtensions on PickResult {
//   Map<String, dynamic> toMap2() => toMap().snakeCaseKeys();
//
//   List<PickResult> fromMapList2(List<Map<String, dynamic>> list) {
//     return list.map((e) => PickResult.fromMap(e.camelCaseKeys())).toList();
//   }
// }

extension LocationModelExt on LocationModel? {
  LocationModel? swapXY() {
    return this?.copyWith(lat: this!.lng, lng: this!.lat);
  }

  bool get hasLatLng =>
      (this != null && this!.lat != null && this!.lng != null);
}

extension LocationModelExt2 on LocationModel {
  LatLng? get toLatLng =>
      (lat != null && lng != null) ? LatLng(lat!, lng!) : null;

  GeoPoint? get toGeoPoint => (lat != null && lng != null)
      ? GeoPoint(latitude: lat!, longitude: lng!)
      : null;
}

extension MapsExtensions on Map {
  Map<String, dynamic> snakeCaseKeys() {
    Map<String, dynamic> map = {};
    forEach((key, value) {
      map[GetUtils.snakeCase(key)!] = value;
    });
    return map;
  }

  Map<String, dynamic> camelCaseKeys() {
    Map<String, dynamic> map = {};
    forEach((key, value) {
      map[key.toString().camelCase!] = value;
    });
    return map;
  }
}

extension LocationExtensions on Location {
  GeoPoint get toGeoPoint => GeoPoint(latitude: lat, longitude: lng);

  GeoPoint get toGeoPointReverse => GeoPoint(latitude: lng, longitude: lat);
}

extension MarkerExtensions on Marker {
  String? get id => key == null ? null : (key as ValueKey).value.toString();
}

extension StationModelExtensions on StationModel {
  double? get distanceKM => 0.1 + Random().nextDouble() * 10;

  double? get durationMin => Random().nextDouble() * 60;

  LatLng? get latLng => latLong?.toLatLng();
}

extension LatLongExtensions on LatLong {
  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

extension LatLngExtensions on LatLng {
  LatLong get latLong => LatLong(latitude, longitude);
}
