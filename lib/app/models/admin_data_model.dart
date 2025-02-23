import 'dart:convert';
import 'super_date_converters.dart';
import 'banner_model.dart';

///****************************************
///region Model AdminDataModelFields
class AdminDataModelFields {
  static const String id = 'id';
  static const String Support_WA_number = 'Support_WA_number';
  static const String Donation_WA_number = 'Donation_WA_number';
  static const String Donation_WA_Message = 'Donation_WA_Message';
  static const String Support_WA_Message = 'Support_WA_Message';
  static const String Donation_WA_Message_ar = 'Donation_WA_Message_ar';
  static const String Support_WA_Message_ar = 'Support_WA_Message_ar';
  static const String homeSliders = 'homeSliders';
  static const String shareAppLinkAndroid = 'shareAppLinkAndroid';
  static const String shareAppLinkIOS = 'shareAppLinkIOS';
  static const String loadingMessage = 'loadingMessage';
  static const String dateUpdated = 'dateUpdated';
  static const String staticMapApiKey = 'staticMapApiKey';
  static const String mapDistanceApiKey = 'mapDistanceApiKey';
  static const String mapPlacesApiKey = 'mapPlacesApiKey';
  static const String mapGeocodingApiKey = 'mapGeocodingApiKey';
  static const String mapKeyDirectionsApiKey = 'mapKeyDirectionsApiKey';
  static const String mapDefaultPointLoad = 'mapDefaultPointLoad';
  static const String mapZoomLevel = 'mapZoomLevel';

  static const List<String> list = [
    id,
    Support_WA_number,
    Donation_WA_number,
    Donation_WA_Message,
    Support_WA_Message,
    Donation_WA_Message_ar,
    Support_WA_Message_ar,
    homeSliders,
    shareAppLinkAndroid,
    shareAppLinkIOS,
    loadingMessage,
    dateUpdated,
    staticMapApiKey,
    mapDistanceApiKey,
    mapPlacesApiKey,
    mapGeocodingApiKey,
    mapKeyDirectionsApiKey,
    mapDefaultPointLoad,
    mapZoomLevel
  ];
}

///endregion Model AdminDataModelFields

///****************************************
///region Model AdminDataModel
class AdminDataModel {
  ///region Fields
  int? id;
  String? Support_WA_number;
  String? Donation_WA_number;
  String? Donation_WA_Message;
  String? Support_WA_Message;
  String? Donation_WA_Message_ar;
  String? Support_WA_Message_ar;
  List<BannerModel> homeSliders = [];
  String shareAppLinkAndroid = "https://play.google.com/store/apps/dev?id";
  String shareAppLinkIOS = "https://apps.apple.com/in/developer/ahmad-al-mahdawi/id1651006070";
  String loadingMessage = "سبحان الله وبحمد\nسبحان الله العظيم";
  DateTime? dateUpdated;
  String? staticMapApiKey;
  String? mapDistanceApiKey;
  String? mapPlacesApiKey;
  String? mapGeocodingApiKey;
  String? mapKeyDirectionsApiKey;
  String? mapDefaultPointLoad;
  double mapZoomLevel = 16.0;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = AdminDataModelFields.list;
  List<dynamic> get toArgs => [
        id,
        Support_WA_number,
        Donation_WA_number,
        Donation_WA_Message,
        Support_WA_Message,
        Donation_WA_Message_ar,
        Support_WA_Message_ar,
        homeSliders,
        shareAppLinkAndroid,
        shareAppLinkIOS,
        loadingMessage,
        dateUpdated,
        staticMapApiKey,
        mapDistanceApiKey,
        mapPlacesApiKey,
        mapGeocodingApiKey,
        mapKeyDirectionsApiKey,
        mapDefaultPointLoad,
        mapZoomLevel
      ];

  ///endregion FieldsList

  ///region newInstance
  AdminDataModel get newInstance => AdminDataModel();

  ///endregion newInstance

  ///region default constructor
  AdminDataModel(
      {this.id,
      this.Support_WA_number,
      this.Donation_WA_number,
      this.Donation_WA_Message,
      this.Support_WA_Message,
      this.Donation_WA_Message_ar,
      this.Support_WA_Message_ar,
      this.homeSliders = const [],
      this.shareAppLinkAndroid = "https://play.google.com/store/apps/dev?id",
      this.shareAppLinkIOS = "https://apps.apple.com/in/developer/ahmad-al-mahdawi/id1651006070",
      this.loadingMessage = "سبحان الله وبحمد\nسبحان الله العظيم",
      this.dateUpdated,
      this.staticMapApiKey,
      this.mapDistanceApiKey,
      this.mapPlacesApiKey,
      this.mapGeocodingApiKey,
      this.mapKeyDirectionsApiKey,
      this.mapDefaultPointLoad,
      this.mapZoomLevel = 16.0});

  ///endregion default constructor

  ///region withFields constructor
  AdminDataModel.withFields(
      this.id,
      this.Support_WA_number,
      this.Donation_WA_number,
      this.Donation_WA_Message,
      this.Support_WA_Message,
      this.Donation_WA_Message_ar,
      this.Support_WA_Message_ar,
      this.homeSliders,
      this.shareAppLinkAndroid,
      this.shareAppLinkIOS,
      this.loadingMessage,
      this.dateUpdated,
      this.staticMapApiKey,
      this.mapDistanceApiKey,
      this.mapPlacesApiKey,
      this.mapGeocodingApiKey,
      this.mapKeyDirectionsApiKey,
      this.mapDefaultPointLoad,
      this.mapZoomLevel);

  ///endregion withFields constructor

  ///region fromMap
  AdminDataModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<AdminDataModel> fromMapList(List<dynamic> list) {
    return list.map((e) => AdminDataModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  AdminDataModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (id != null) AdminDataModelFields.id: id,
      if (Support_WA_number != null) AdminDataModelFields.Support_WA_number: Support_WA_number,
      if (Donation_WA_number != null) AdminDataModelFields.Donation_WA_number: Donation_WA_number,
      if (Donation_WA_Message != null) AdminDataModelFields.Donation_WA_Message: Donation_WA_Message,
      if (Support_WA_Message != null) AdminDataModelFields.Support_WA_Message: Support_WA_Message,
      if (Donation_WA_Message_ar != null) AdminDataModelFields.Donation_WA_Message_ar: Donation_WA_Message_ar,
      if (Support_WA_Message_ar != null) AdminDataModelFields.Support_WA_Message_ar: Support_WA_Message_ar,
      AdminDataModelFields.homeSliders: homeSliders.map((e) => e.toMap()).toList(),
      AdminDataModelFields.shareAppLinkAndroid: shareAppLinkAndroid,
      AdminDataModelFields.shareAppLinkIOS: shareAppLinkIOS,
      AdminDataModelFields.loadingMessage: loadingMessage,
      if (dateUpdated != null)
        AdminDataModelFields.dateUpdated: isDateIso8601String ? dateUpdated!.toIso8601String() : SuperDateConverters.toMapConversion(dateUpdated),
      if (staticMapApiKey != null) AdminDataModelFields.staticMapApiKey: staticMapApiKey,
      if (mapDistanceApiKey != null) AdminDataModelFields.mapDistanceApiKey: mapDistanceApiKey,
      if (mapPlacesApiKey != null) AdminDataModelFields.mapPlacesApiKey: mapPlacesApiKey,
      if (mapGeocodingApiKey != null) AdminDataModelFields.mapGeocodingApiKey: mapGeocodingApiKey,
      if (mapKeyDirectionsApiKey != null) AdminDataModelFields.mapKeyDirectionsApiKey: mapKeyDirectionsApiKey,
      if (mapDefaultPointLoad != null) AdminDataModelFields.mapDefaultPointLoad: mapDefaultPointLoad,
      AdminDataModelFields.mapZoomLevel: mapZoomLevel,
    };
//return map;
  }

  ///endregion toMap

  ///region toJson
  String toJson([bool isDateIso8601String = false]) => json.encode(toMap(isDateIso8601String));

  ///endregion toJson

  ///region toString
  @override
  String toString() => toMap().toString();

  ///endregion toString

  ///region copyWith
  AdminDataModel copyWith(
      {int? id,
      String? Support_WA_number,
      String? Donation_WA_number,
      String? Donation_WA_Message,
      String? Support_WA_Message,
      String? Donation_WA_Message_ar,
      String? Support_WA_Message_ar,
      List<BannerModel>? homeSliders,
      String? shareAppLinkAndroid,
      String? shareAppLinkIOS,
      String? loadingMessage,
      DateTime? dateUpdated,
      String? staticMapApiKey,
      String? mapDistanceApiKey,
      String? mapPlacesApiKey,
      String? mapGeocodingApiKey,
      String? mapKeyDirectionsApiKey,
      String? mapDefaultPointLoad,
      double? mapZoomLevel}) {
    return AdminDataModel()
      ..id = id ?? this.id
      ..Support_WA_number = Support_WA_number ?? this.Support_WA_number
      ..Donation_WA_number = Donation_WA_number ?? this.Donation_WA_number
      ..Donation_WA_Message = Donation_WA_Message ?? this.Donation_WA_Message
      ..Support_WA_Message = Support_WA_Message ?? this.Support_WA_Message
      ..Donation_WA_Message_ar = Donation_WA_Message_ar ?? this.Donation_WA_Message_ar
      ..Support_WA_Message_ar = Support_WA_Message_ar ?? this.Support_WA_Message_ar
      ..homeSliders = ([...homeSliders ?? this.homeSliders])
      ..shareAppLinkAndroid = shareAppLinkAndroid ?? this.shareAppLinkAndroid
      ..shareAppLinkIOS = shareAppLinkIOS ?? this.shareAppLinkIOS
      ..loadingMessage = loadingMessage ?? this.loadingMessage
      ..dateUpdated = dateUpdated ?? this.dateUpdated
      ..staticMapApiKey = staticMapApiKey ?? this.staticMapApiKey
      ..mapDistanceApiKey = mapDistanceApiKey ?? this.mapDistanceApiKey
      ..mapPlacesApiKey = mapPlacesApiKey ?? this.mapPlacesApiKey
      ..mapGeocodingApiKey = mapGeocodingApiKey ?? this.mapGeocodingApiKey
      ..mapKeyDirectionsApiKey = mapKeyDirectionsApiKey ?? this.mapKeyDirectionsApiKey
      ..mapDefaultPointLoad = mapDefaultPointLoad ?? this.mapDefaultPointLoad
      ..mapZoomLevel = mapZoomLevel ?? this.mapZoomLevel;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith(
      {int? id,
      String? Support_WA_number,
      String? Donation_WA_number,
      String? Donation_WA_Message,
      String? Support_WA_Message,
      String? Donation_WA_Message_ar,
      String? Support_WA_Message_ar,
      List<BannerModel>? homeSliders,
      String? shareAppLinkAndroid,
      String? shareAppLinkIOS,
      String? loadingMessage,
      DateTime? dateUpdated,
      String? staticMapApiKey,
      String? mapDistanceApiKey,
      String? mapPlacesApiKey,
      String? mapGeocodingApiKey,
      String? mapKeyDirectionsApiKey,
      String? mapDefaultPointLoad,
      double? mapZoomLevel}) {
    if (id != null) {
      this.id = id;
    }
    if (Support_WA_number != null) {
      this.Support_WA_number = Support_WA_number;
    }
    if (Donation_WA_number != null) {
      this.Donation_WA_number = Donation_WA_number;
    }
    if (Donation_WA_Message != null) {
      this.Donation_WA_Message = Donation_WA_Message;
    }
    if (Support_WA_Message != null) {
      this.Support_WA_Message = Support_WA_Message;
    }
    if (Donation_WA_Message_ar != null) {
      this.Donation_WA_Message_ar = Donation_WA_Message_ar;
    }
    if (Support_WA_Message_ar != null) {
      this.Support_WA_Message_ar = Support_WA_Message_ar;
    }
    if (homeSliders != null) {
      this.homeSliders = homeSliders;
    }
    if (shareAppLinkAndroid != null) {
      this.shareAppLinkAndroid = shareAppLinkAndroid;
    }
    if (shareAppLinkIOS != null) {
      this.shareAppLinkIOS = shareAppLinkIOS;
    }
    if (loadingMessage != null) {
      this.loadingMessage = loadingMessage;
    }
    if (dateUpdated != null) {
      this.dateUpdated = dateUpdated;
    }
    if (staticMapApiKey != null) {
      this.staticMapApiKey = staticMapApiKey;
    }
    if (mapDistanceApiKey != null) {
      this.mapDistanceApiKey = mapDistanceApiKey;
    }
    if (mapPlacesApiKey != null) {
      this.mapPlacesApiKey = mapPlacesApiKey;
    }
    if (mapGeocodingApiKey != null) {
      this.mapGeocodingApiKey = mapGeocodingApiKey;
    }
    if (mapKeyDirectionsApiKey != null) {
      this.mapKeyDirectionsApiKey = mapKeyDirectionsApiKey;
    }
    if (mapDefaultPointLoad != null) {
      this.mapDefaultPointLoad = mapDefaultPointLoad;
    }
    if (mapZoomLevel != null) {
      this.mapZoomLevel = mapZoomLevel;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required AdminDataModel another}) {
    if (another.id != null) {
      id = another.id;
    }
    if (another.Support_WA_number != null) {
      Support_WA_number = another.Support_WA_number;
    }
    if (another.Donation_WA_number != null) {
      Donation_WA_number = another.Donation_WA_number;
    }
    if (another.Donation_WA_Message != null) {
      Donation_WA_Message = another.Donation_WA_Message;
    }
    if (another.Support_WA_Message != null) {
      Support_WA_Message = another.Support_WA_Message;
    }
    if (another.Donation_WA_Message_ar != null) {
      Donation_WA_Message_ar = another.Donation_WA_Message_ar;
    }
    if (another.Support_WA_Message_ar != null) {
      Support_WA_Message_ar = another.Support_WA_Message_ar;
    }
    homeSliders = another.homeSliders;
    shareAppLinkAndroid = another.shareAppLinkAndroid;
    shareAppLinkIOS = another.shareAppLinkIOS;
    loadingMessage = another.loadingMessage;
    if (another.dateUpdated != null) {
      dateUpdated = another.dateUpdated;
    }
    if (another.staticMapApiKey != null) {
      staticMapApiKey = another.staticMapApiKey;
    }
    if (another.mapDistanceApiKey != null) {
      mapDistanceApiKey = another.mapDistanceApiKey;
    }
    if (another.mapPlacesApiKey != null) {
      mapPlacesApiKey = another.mapPlacesApiKey;
    }
    if (another.mapGeocodingApiKey != null) {
      mapGeocodingApiKey = another.mapGeocodingApiKey;
    }
    if (another.mapKeyDirectionsApiKey != null) {
      mapKeyDirectionsApiKey = another.mapKeyDirectionsApiKey;
    }
    if (another.mapDefaultPointLoad != null) {
      mapDefaultPointLoad = another.mapDefaultPointLoad;
    }
    mapZoomLevel = another.mapZoomLevel;
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[AdminDataModelFields.id] != null) {
      id = int.tryParse(map[AdminDataModelFields.id].toString());
    }
    if (map[AdminDataModelFields.Support_WA_number] != null) {
      Support_WA_number = map[AdminDataModelFields.Support_WA_number].toString();
    }
    if (map[AdminDataModelFields.Donation_WA_number] != null) {
      Donation_WA_number = map[AdminDataModelFields.Donation_WA_number].toString();
    }
    if (map[AdminDataModelFields.Donation_WA_Message] != null) {
      Donation_WA_Message = map[AdminDataModelFields.Donation_WA_Message].toString();
    }
    if (map[AdminDataModelFields.Support_WA_Message] != null) {
      Support_WA_Message = map[AdminDataModelFields.Support_WA_Message].toString();
    }
    if (map[AdminDataModelFields.Donation_WA_Message_ar] != null) {
      Donation_WA_Message_ar = map[AdminDataModelFields.Donation_WA_Message_ar].toString();
    }
    if (map[AdminDataModelFields.Support_WA_Message_ar] != null) {
      Support_WA_Message_ar = map[AdminDataModelFields.Support_WA_Message_ar].toString();
    }
    if (map[AdminDataModelFields.homeSliders] != null) {
      homeSliders = BannerModel.fromMapList(map[AdminDataModelFields.homeSliders] as List);
    }
    if (map[AdminDataModelFields.shareAppLinkAndroid] != null) {
      shareAppLinkAndroid = map[AdminDataModelFields.shareAppLinkAndroid] ?? "https://play.google.com/store/apps/dev?id".toString();
    }
    if (map[AdminDataModelFields.shareAppLinkIOS] != null) {
      shareAppLinkIOS = map[AdminDataModelFields.shareAppLinkIOS] ?? "https://apps.apple.com/in/developer/ahmad-al-mahdawi/id1651006070".toString();
    }
    if (map[AdminDataModelFields.loadingMessage] != null) {
      loadingMessage = map[AdminDataModelFields.loadingMessage] ?? "سبحان الله وبحمد\nسبحان الله العظيم".toString();
    }
    if (map[AdminDataModelFields.dateUpdated] != null) {
      dateUpdated = SuperDateConverters.tryParseDateTime(map[AdminDataModelFields.dateUpdated]!.toString());
    }
    if (map[AdminDataModelFields.staticMapApiKey] != null) {
      staticMapApiKey = map[AdminDataModelFields.staticMapApiKey].toString();
    }
    if (map[AdminDataModelFields.mapDistanceApiKey] != null) {
      mapDistanceApiKey = map[AdminDataModelFields.mapDistanceApiKey].toString();
    }
    if (map[AdminDataModelFields.mapPlacesApiKey] != null) {
      mapPlacesApiKey = map[AdminDataModelFields.mapPlacesApiKey].toString();
    }
    if (map[AdminDataModelFields.mapGeocodingApiKey] != null) {
      mapGeocodingApiKey = map[AdminDataModelFields.mapGeocodingApiKey].toString();
    }
    if (map[AdminDataModelFields.mapKeyDirectionsApiKey] != null) {
      mapKeyDirectionsApiKey = map[AdminDataModelFields.mapKeyDirectionsApiKey].toString();
    }
    if (map[AdminDataModelFields.mapDefaultPointLoad] != null) {
      mapDefaultPointLoad = map[AdminDataModelFields.mapDefaultPointLoad].toString();
    }
    if (map[AdminDataModelFields.mapZoomLevel] != null) {
      mapZoomLevel = double.tryParse(map[AdminDataModelFields.mapZoomLevel].toString()) ?? 16.0;
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminDataModel &&
        id == other.id &&
        Support_WA_number == other.Support_WA_number &&
        Donation_WA_number == other.Donation_WA_number &&
        Donation_WA_Message == other.Donation_WA_Message &&
        Support_WA_Message == other.Support_WA_Message &&
        Donation_WA_Message_ar == other.Donation_WA_Message_ar &&
        Support_WA_Message_ar == other.Support_WA_Message_ar &&
        homeSliders == other.homeSliders &&
        shareAppLinkAndroid == other.shareAppLinkAndroid &&
        shareAppLinkIOS == other.shareAppLinkIOS &&
        loadingMessage == other.loadingMessage &&
        dateUpdated == other.dateUpdated &&
        staticMapApiKey == other.staticMapApiKey &&
        mapDistanceApiKey == other.mapDistanceApiKey &&
        mapPlacesApiKey == other.mapPlacesApiKey &&
        mapGeocodingApiKey == other.mapGeocodingApiKey &&
        mapKeyDirectionsApiKey == other.mapKeyDirectionsApiKey &&
        mapDefaultPointLoad == other.mapDefaultPointLoad &&
        mapZoomLevel == other.mapZoomLevel;
  }

  bool isTheSameObjectID(AdminDataModel other) => id != null && other.id != null && id == other.id;
  @override
  int get hashCode =>
      id.hashCode ^
      Support_WA_number.hashCode ^
      Donation_WA_number.hashCode ^
      Donation_WA_Message.hashCode ^
      Support_WA_Message.hashCode ^
      Donation_WA_Message_ar.hashCode ^
      Support_WA_Message_ar.hashCode ^
      homeSliders.hashCode ^
      shareAppLinkAndroid.hashCode ^
      shareAppLinkIOS.hashCode ^
      loadingMessage.hashCode ^
      dateUpdated.hashCode ^
      staticMapApiKey.hashCode ^
      mapDistanceApiKey.hashCode ^
      mapPlacesApiKey.hashCode ^
      mapGeocodingApiKey.hashCode ^
      mapKeyDirectionsApiKey.hashCode ^
      mapDefaultPointLoad.hashCode ^
      mapZoomLevel.hashCode;

  ///endregion Equality
}

///endregion Model AdminDataModel
