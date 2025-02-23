import 'dart:convert';

import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import 'dart:convert';

import 'location_picked_data.dart';

///****************************************
///region Model StationModelFields
class StationModelFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String description = 'description';
  static const String address = 'address';
  static const String cirt = 'cirt';
  static const String latLong = 'latLong';

  static const List<String> list = [
    id,
    name,
    description,
    address,
    cirt,
    latLong
  ];
}

///endregion Model StationModelFields

///****************************************
///region Model StationModel
class StationModel {
  ///region Fields
  int? id;
  String? name;
  String? description;
  String? address;
  String? cirt;
  LatLong? latLong;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = StationModelFields.list;

  List<dynamic> get toArgs => [id, name, description, address, cirt, latLong];

  ///endregion FieldsList

  ///region newInstance
  StationModel get newInstance => StationModel();

  ///endregion newInstance

  ///region default constructor
  StationModel(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.cirt,
      this.latLong});

  ///endregion default constructor

  ///region withFields constructor
  StationModel.withFields(this.id, this.name, this.description, this.address,
      this.cirt, this.latLong);

  ///endregion withFields constructor

  ///region fromMap
  StationModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<StationModel> fromMapList(List<dynamic> list) {
    return list
        .map((e) => StationModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  ///endregion fromMapList

  ///region fromJson
  StationModel.fromJson(String jsonInput)
      : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (id != null) StationModelFields.id: id,
      if (name != null) StationModelFields.name: name,
      if (description != null) StationModelFields.description: description,
      if (address != null) StationModelFields.address: address,
      if (cirt != null) StationModelFields.cirt: cirt,
      if (latLong != null) StationModelFields.latLong: latLong!.toMap(),
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
  StationModel copyWith(
      {int? id,
      String? name,
      String? description,
      String? address,
      String? cirt,
      LatLong? latLong}) {
    return StationModel()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..description = description ?? this.description
      ..address = address ?? this.address
      ..cirt = cirt ?? this.cirt
      ..latLong = latLong ?? this.latLong;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith(
      {int? id,
      String? name,
      String? description,
      String? address,
      String? cirt,
      LatLong? latLong}) {
    if (id != null) {
      this.id = id;
    }
    if (name != null) {
      this.name = name;
    }
    if (description != null) {
      this.description = description;
    }
    if (address != null) {
      this.address = address;
    }
    if (cirt != null) {
      this.cirt = cirt;
    }
    if (latLong != null) {
      this.latLong = latLong;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required StationModel another}) {
    if (another.id != null) {
      id = another.id;
    }
    if (another.name != null) {
      name = another.name;
    }
    if (another.description != null) {
      description = another.description;
    }
    if (another.address != null) {
      address = another.address;
    }
    if (another.cirt != null) {
      cirt = another.cirt;
    }
    if (another.latLong != null) {
      latLong = another.latLong;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[StationModelFields.id] != null) {
      id = int.tryParse(map[StationModelFields.id].toString());
    }
    if (map[StationModelFields.name] != null) {
      name = map[StationModelFields.name].toString();
    }
    if (map[StationModelFields.description] != null) {
      description = map[StationModelFields.description].toString();
    }
    if (map[StationModelFields.address] != null) {
      address = map[StationModelFields.address].toString();
    }
    if (map[StationModelFields.cirt] != null) {
      cirt = map[StationModelFields.cirt].toString();
    }
    if (map[StationModelFields.latLong] != null) {
      latLong = latLongFromMap(
          map[StationModelFields.latLong] as Map<String, dynamic>);
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StationModel &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        address == other.address &&
        cirt == other.cirt &&
        latLong == other.latLong;
  }

  bool isTheSameObjectID(StationModel other) =>
      id != null && other.id != null && id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      address.hashCode ^
      cirt.hashCode ^
      latLong.hashCode;

  ///endregion Equality
}

///endregion Model StationModel
