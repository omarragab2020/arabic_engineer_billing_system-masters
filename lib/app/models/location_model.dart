import 'dart:convert';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///****************************************
///region Model LocationModelFields
class LocationModelFields {
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String address = 'address';
  static const String plusCode = 'plusCode';
  static const String administrativeArea = 'administrativeArea';
  static const String subAdministrativeArea = 'subAdministrativeArea';
  static const String country = 'country';
  static const String description = 'description';
  static const String image = 'image';

  static const List<String> list = [lat, lng, address, plusCode, administrativeArea, subAdministrativeArea, country, description, image];
}

///endregion Model LocationModelFields

///****************************************
///region Model LocationModel
class LocationModel {
  ///region Fields
  int? id;
  double? lat;
  double? lng;
  String? address;
  String? plusCode;
  String? administrativeArea;
  String? subAdministrativeArea;
  String? country;
  String? description;
  String? image;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = LocationModelFields.list;

  List<dynamic> get toArgs => [lat, lng, address, plusCode, administrativeArea, subAdministrativeArea, country, description, image];

//   ///region fromPickResult
//   LocationModel.fromPickResult(PickResult pickResult) {
//     address = pickResult.formattedAddress;
// // city=pickResult.addressComponents;
//     lat = pickResult.geometry!.location.lat;
//     lng = pickResult.geometry!.location.lng;
//   }

  ///endregion FieldsList

  ///region newInstance
  LocationModel get newInstance => LocationModel();

  ///endregion newInstance

  ///region default constructor
  LocationModel(
      {this.lat,
      this.lng,
      this.address,
      this.plusCode,
      this.administrativeArea,
      this.subAdministrativeArea,
      this.country,
      this.description,
      this.image});

  ///endregion default constructor

  ///region withFields constructor
  LocationModel.withFields(this.lat, this.lng, this.address, this.plusCode, this.administrativeArea, this.subAdministrativeArea, this.country,
      this.description, this.image);

  ///endregion withFields constructor

  ///region fromMap
  LocationModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<LocationModel> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((e) => LocationModel.fromMap(e)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  LocationModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (lat != null) {
      map[LocationModelFields.lat] = lat;
    }
    if (lng != null) {
      map[LocationModelFields.lng] = lng;
    }
    if (address != null) {
      map[LocationModelFields.address] = address;
    }
    if (plusCode != null) {
      map[LocationModelFields.plusCode] = plusCode;
    }
    if (administrativeArea != null) {
      map[LocationModelFields.administrativeArea] = administrativeArea;
    }
    if (subAdministrativeArea != null) {
      map[LocationModelFields.subAdministrativeArea] = subAdministrativeArea;
    }
    if (country != null) {
      map[LocationModelFields.country] = country;
    }
    if (description != null) {
      map[LocationModelFields.description] = description;
    }
    if (image != null) {
      map[LocationModelFields.image] = image;
    }
    return map;
  }

  ///endregion toMap

  ///region toJson
  String toJson() => json.encode(toMap());

  ///endregion toJson

  ///region toString
  @override
  String toString() => toMap().toString();

  ///endregion toString

  ///region copyWith
  LocationModel copyWith(
      {double? lat,
      double? lng,
      String? address,
      String? plusCode,
      String? administrativeArea,
      String? subAdministrativeArea,
      String? country,
      String? description,
      String? image}) {
    return LocationModel()
      ..lat = lat ?? this.lat
      ..lng = lng ?? this.lng
      ..address = address ?? this.address
      ..plusCode = plusCode ?? this.plusCode
      ..administrativeArea = administrativeArea ?? this.administrativeArea
      ..subAdministrativeArea = subAdministrativeArea ?? this.subAdministrativeArea
      ..country = country ?? this.country
      ..description = description ?? this.description
      ..image = image ?? this.image;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith(
      {double? lat,
      double? lng,
      String? address,
      String? plusCode,
      String? administrativeArea,
      String? subAdministrativeArea,
      String? country,
      String? description,
      String? image}) {
    if (lat != null) {
      this.lat = lat;
    }
    if (lng != null) {
      this.lng = lng;
    }
    if (address != null) {
      this.address = address;
    }
    if (plusCode != null) {
      this.plusCode = plusCode;
    }
    if (administrativeArea != null) {
      this.administrativeArea = administrativeArea;
    }
    if (subAdministrativeArea != null) {
      this.subAdministrativeArea = subAdministrativeArea;
    }
    if (country != null) {
      this.country = country;
    }
    if (description != null) {
      this.description = description;
    }
    if (image != null) {
      this.image = image;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required LocationModel another}) {
    if (another.lat != null) {
      lat = another.lat;
    }
    if (another.lng != null) {
      lng = another.lng;
    }
    if (another.address != null) {
      address = another.address;
    }
    if (another.plusCode != null) {
      plusCode = another.plusCode;
    }
    if (another.administrativeArea != null) {
      administrativeArea = another.administrativeArea;
    }
    if (another.subAdministrativeArea != null) {
      subAdministrativeArea = another.subAdministrativeArea;
    }
    if (another.country != null) {
      country = another.country;
    }
    if (another.description != null) {
      description = another.description;
    }
    if (another.image != null) {
      image = another.image;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[LocationModelFields.lat] != null) {
      lat = double.tryParse(map[LocationModelFields.lat].toString());
    }
    if (map[LocationModelFields.lng] != null) {
      lng = double.tryParse(map[LocationModelFields.lng].toString());
    }
    if (map[LocationModelFields.address] != null) {
      address = map[LocationModelFields.address].toString();
    }
    if (map[LocationModelFields.plusCode] != null) {
      plusCode = map[LocationModelFields.plusCode].toString();
    }
    if (map[LocationModelFields.administrativeArea] != null) {
      administrativeArea = map[LocationModelFields.administrativeArea].toString();
    }
    if (map[LocationModelFields.subAdministrativeArea] != null) {
      subAdministrativeArea = map[LocationModelFields.subAdministrativeArea].toString();
    }
    if (map[LocationModelFields.country] != null) {
      country = map[LocationModelFields.country].toString();
    }
    if (map[LocationModelFields.description] != null) {
      description = map[LocationModelFields.description].toString();
    }
    if (map[LocationModelFields.image] != null) {
      image = map[LocationModelFields.image].toString();
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        lat == other.lat &&
        lng == other.lng &&
        address == other.address &&
        plusCode == other.plusCode &&
        administrativeArea == other.administrativeArea &&
        subAdministrativeArea == other.subAdministrativeArea &&
        country == other.country &&
        description == other.description &&
        image == other.image;
  }

  @override
  int get hashCode =>
      lat.hashCode ^
      lng.hashCode ^
      address.hashCode ^
      plusCode.hashCode ^
      administrativeArea.hashCode ^
      subAdministrativeArea.hashCode ^
      country.hashCode ^
      description.hashCode ^
      image.hashCode;

  ///endregion Equality
}

///endregion Model LocationModel
