import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neuss_utils/utils/utils.dart';

///****************************************
///region Model FromToGeoModelFields
class FromToGeoModelFields {
  static const String type = 'type';
  static const String coordinates = 'coordinates';

  static const List<String> list = [type, coordinates];
}

///endregion Model FromToGeoModelFields

///****************************************
///region Model FromToGeoModel
class GeoModel {
  ///region Fields
  String? type;
  List<List<double>>? coordinates;

  ///endregion Fields

  LatLng? get toLatLng => (coordinates.hasData && coordinates!.last.hasData)
      ? LatLng(coordinates!.last[0], coordinates!.last[1])
      : null;
  List<LatLng>? get toLatLngList => (coordinates.hasData)
      ? coordinates!.map((e) => LatLng(e[0], e[1])).toList()
      : null;

  ///region FieldsList
  List<String> fieldsList = FromToGeoModelFields.list;
  List<dynamic> get toArgs => [type, coordinates];

  ///endregion FieldsList

  ///region newInstance
  GeoModel get newInstance => GeoModel();

  ///endregion newInstance

  ///region default constructor
  GeoModel({this.type, this.coordinates});
  GeoModel.point({this.coordinates}) : type = 'Point';
  GeoModel.multiPoint({this.coordinates}) : type = 'MultiPoint';

  bool get isPoint => type == 'Point';
  bool get isMultiPoint => type == 'MultiPoint';

  ///endregion default constructor

  ///region withFields constructor
  GeoModel.withFields(this.type, this.coordinates);

  ///endregion withFields constructor

  ///region fromMap
  GeoModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<GeoModel> fromMapList(List<dynamic> list) {
    return list
        .map((e) => GeoModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  ///endregion fromMapList

  ///region fromJson
  GeoModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    getType() => coordinates.hasData
        ? coordinates!.length > 1
            ? 'MultiPoint'
            : 'Point'
        : null;
    getCoordinates() => coordinates.hasData
        ? coordinates!.length > 1
            ? coordinates!.map((e) => e.reversed.toList())
            : [coordinates!.first.reversed.toList()]
        : null;

    return {
      if (type != null) FromToGeoModelFields.type: type,
      if (coordinates != null)
        FromToGeoModelFields.coordinates: getCoordinates(),
    };
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
  GeoModel copyWith({String? type, List<List<double>>? coordinates}) {
    return GeoModel()
      ..type = type ?? this.type
      ..coordinates = coordinates ?? this.coordinates;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({String? type, List<List<double>>? coordinates}) {
    if (type != null) {
      this.type = type;
    }
    if (coordinates != null) {
      this.coordinates = coordinates;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required GeoModel another}) {
    if (another.type != null) {
      type = another.type;
    }
    if (another.coordinates != null) {
      coordinates = another.coordinates;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[FromToGeoModelFields.type] != null) {
      type = map[FromToGeoModelFields.type].toString();
    }
    if (map[FromToGeoModelFields.coordinates] != null) {
      if (isMultiPoint) {
        coordinates = List<List<double>>.from(
          (map[FromToGeoModelFields.coordinates]).map(
            (x) => List<double>.from(x.map(
              (p) => double.parse(p.toString()),
            )).reversed.toList(),
          ),
        );
      } else if (isPoint) {
        coordinates = [
          List<double>.from(
            (map[FromToGeoModelFields.coordinates]).map(
              (p) => double.parse(p.toString()),
            ),
          ).reversed.toList(),
        ];
      }
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeoModel &&
        type == other.type &&
        coordinates == other.coordinates;
  }

  @override
  int get hashCode => type.hashCode ^ coordinates.hashCode;

  ///endregion Equality
}

///endregion Model FromToGeoModel
