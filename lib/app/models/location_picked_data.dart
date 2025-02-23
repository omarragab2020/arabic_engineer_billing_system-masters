import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import 'dart:convert';
import 'package:almuandes_billing_system/core/utils/app_extensions.dart';

///****************************************
///region Model LocationPickedDataModelFields
class LocationPickedDataModelFields {
  static const String latLong = 'latLong';
  static const String address = 'address';
  static const String addressData = 'addressData';
  static const String fullResponse = 'fullResponse';

  static const List<String> list = [
    latLong,
    address,
    addressData,
    fullResponse
  ];
}

///endregion Model LocationPickedDataModelFields

///****************************************
///region Model LocationPickedDataModel
class LocationPickedDataModel {
  ///region Fields
  LatLong? latLong;
  String? address;
  Map<String, dynamic>? addressData;
  dynamic fullResponse;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = LocationPickedDataModelFields.list;

  List<dynamic> get toArgs => [latLong, address, addressData, fullResponse];

  ///endregion FieldsList

  ///region newInstance
  LocationPickedDataModel get newInstance => LocationPickedDataModel();

  ///endregion newInstance

  ///region default constructor
  LocationPickedDataModel(
      {this.latLong, this.address, this.addressData, this.fullResponse});

  ///endregion default constructor

  ///region withFields constructor
  LocationPickedDataModel.fromPickedData(PickedData pickedData) {
    latLong = pickedData.latLong;
    address = pickedData.address;
    addressData = pickedData.addressData;
    fullResponse = pickedData.fullResponse;
  }

  ///endregion withFields constructor

  ///region withFields constructor
  LocationPickedDataModel.withFields(
      this.latLong, this.address, this.addressData, this.fullResponse);

  ///endregion withFields constructor

  ///region fromMap
  LocationPickedDataModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<LocationPickedDataModel> fromMapList(List<dynamic> list) {
    return list
        .map((e) => LocationPickedDataModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  ///endregion fromMapList

  ///region fromJson
  LocationPickedDataModel.fromJson(String jsonInput)
      : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (latLong != null)
        LocationPickedDataModelFields.latLong: latLong!.toMap(),
      if (address != null) LocationPickedDataModelFields.address: address,
      if (addressData != null)
        LocationPickedDataModelFields.addressData: addressData!,
      LocationPickedDataModelFields.fullResponse: fullResponse,
    };
//return map;
  }

  ///endregion toMap

  ///region toJson
  String toJson([bool isDateIso8601String = false]) =>
      json.encode(toMap(isDateIso8601String));

  ///endregion toJson

  ///region toString
  @override
  String toString() => toMap().toString();

  ///endregion toString

  ///region copyWith
  LocationPickedDataModel copyWith(
      {LatLong? latLong,
      String? address,
      Map<String, dynamic>? addressData,
      dynamic fullResponse}) {
    return LocationPickedDataModel()
      ..latLong = latLong ?? this.latLong
      ..address = address ?? this.address
      ..addressData = ({...?addressData ?? this.addressData})
      ..fullResponse = fullResponse ?? this.fullResponse;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith(
      {LatLong? latLong,
      String? address,
      Map<String, dynamic>? addressData,
      dynamic fullResponse}) {
    if (latLong != null) {
      this.latLong = latLong;
    }
    if (address != null) {
      this.address = address;
    }
    if (addressData != null) {
      this.addressData = ({}..addAll(addressData));
    }
    if (fullResponse != null) {
      this.fullResponse = fullResponse;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required LocationPickedDataModel another}) {
    if (another.latLong != null) {
      latLong = another.latLong;
    }
    if (another.address != null) {
      address = another.address;
    }
    if (another.addressData != null) {
      addressData = ({}..addAll(another.addressData ?? {}));
    }
    fullResponse = another.fullResponse;
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[LocationPickedDataModelFields.latLong] != null) {
      latLong = latLongFromMap(
          map[LocationPickedDataModelFields.latLong] as Map<String, dynamic>);
    }
    if (map[LocationPickedDataModelFields.address] != null) {
      address = map[LocationPickedDataModelFields.address].toString();
    }
    if (map[LocationPickedDataModelFields.addressData] != null) {
      addressData = (map[LocationPickedDataModelFields.addressData]
              as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v));
    }
    if (map[LocationPickedDataModelFields.fullResponse] != null) {
      fullResponse = map[LocationPickedDataModelFields.fullResponse].toString();
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationPickedDataModel &&
        latLong == other.latLong &&
        address == other.address &&
        addressData == other.addressData &&
        fullResponse == other.fullResponse;
  }

  @override
  int get hashCode =>
      latLong.hashCode ^
      address.hashCode ^
      addressData.hashCode ^
      fullResponse.hashCode;

  ///endregion Equality
}

///endregion Model LocationPickedDataModel

LatLong? latLongFromMap(Map<String, dynamic> map) {
  if (map.containsKey('latitude') && map.containsKey('longitude')) {
    return LatLong(map['latitude'], map['longitude']);
  }
  return null;
}
