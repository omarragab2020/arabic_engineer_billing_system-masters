import 'package:almuandes_billing_system/app/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

enum StoryType { image, video, text }

///****************************************
///region Model StoryModelFields
class StoryModelFields {
  static const String url = 'url';
  static const String asset = 'asset';
  static const String text = 'text';
  static const String type = 'type';
  static const String duration = 'duration';
  static const String captionTxt = 'captionTxt';
  static const String captionWidget = 'captionWidget';
  static const String boxFit = 'boxFit';

  static const List<String> list = [
    url,
    asset,
    text,
    type,
    duration,
    captionTxt,
    captionWidget,
    boxFit
  ];
}

///endregion Model StoryModelFields

///****************************************
///region Model StoryModel
class StoryModel {
  ///region Fields
  String? url;
  String? asset;
  String? text;
  StoryType type = StoryType.image;
  Duration? duration;
  String? captionTxt;
  Widget? captionWidget;
  BoxFit boxFit = BoxFit.fill;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = StoryModelFields.list;

  List<dynamic> get toArgs =>
      [url, asset, text, type, duration, captionTxt, captionWidget, boxFit];

  ///endregion FieldsList

  ///region newInstance
  StoryModel get newInstance => StoryModel();

  ///endregion newInstance

  ///region default constructor
  StoryModel(
      {this.url,
      this.asset,
      this.text,
      this.type = StoryType.image,
      this.duration,
      this.captionTxt,
      this.captionWidget,
      this.boxFit = BoxFit.fill});

  ///endregion default constructor

  ///region withFields constructor
  StoryModel.withFields(this.url, this.asset, this.text, this.type,
      this.duration, this.captionTxt, this.captionWidget, this.boxFit);

  ///endregion withFields constructor

  ///region fromMap
  StoryModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<StoryModel> fromMapList(List<dynamic> list) {
    return list
        .map((e) => StoryModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  ///endregion fromMapList

  ///region fromJson
  StoryModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (url != null) StoryModelFields.url: url,
      if (asset != null) StoryModelFields.asset: asset,
      if (text != null) StoryModelFields.text: text,
      StoryModelFields.type: type.name,
      if (duration != null) StoryModelFields.duration: duration!.toString(),
      if (captionTxt != null) StoryModelFields.captionTxt: captionTxt,
      if (captionWidget != null) StoryModelFields.captionWidget: captionWidget!,
      StoryModelFields.boxFit: boxFit.name,
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
  StoryModel copyWith(
      {String? url,
      String? asset,
      String? text,
      StoryType? type,
      Duration? duration,
      String? captionTxt,
      Widget? captionWidget,
      BoxFit? boxFit}) {
    return StoryModel()
      ..url = url ?? this.url
      ..asset = asset ?? this.asset
      ..text = text ?? this.text
      ..type = type ?? this.type
      ..duration = duration ?? this.duration
      ..captionTxt = captionTxt ?? this.captionTxt
      ..captionWidget = captionWidget ?? this.captionWidget
      ..boxFit = boxFit ?? this.boxFit;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith(
      {String? url,
      String? asset,
      String? text,
      StoryType? type,
      Duration? duration,
      String? captionTxt,
      Widget? captionWidget,
      BoxFit? boxFit}) {
    if (url != null) {
      this.url = url;
    }
    if (asset != null) {
      this.asset = asset;
    }
    if (text != null) {
      this.text = text;
    }
    if (type != null) {
      this.type = type;
    }
    if (duration != null) {
      this.duration = duration;
    }
    if (captionTxt != null) {
      this.captionTxt = captionTxt;
    }
    if (captionWidget != null) {
      this.captionWidget = captionWidget;
    }
    if (boxFit != null) {
      this.boxFit = boxFit;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required StoryModel another}) {
    if (another.url != null) {
      url = another.url;
    }
    if (another.asset != null) {
      asset = another.asset;
    }
    if (another.text != null) {
      text = another.text;
    }
    type = another.type;
    if (another.duration != null) {
      duration = another.duration;
    }
    if (another.captionTxt != null) {
      captionTxt = another.captionTxt;
    }
    if (another.captionWidget != null) {
      captionWidget = another.captionWidget;
    }
    boxFit = another.boxFit;
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[StoryModelFields.url] != null) {
      url = map[StoryModelFields.url].toString();
    }
    if (map[StoryModelFields.asset] != null) {
      asset = map[StoryModelFields.asset].toString();
    }
    if (map[StoryModelFields.text] != null) {
      text = map[StoryModelFields.text].toString();
    }
    if (map[StoryModelFields.type] != null) {
      type = StoryType.values.firstWhere(
          (e) => e.name == map[StoryModelFields.type],
          orElse: () => StoryType.image);
    }
    if (map[StoryModelFields.duration] != null) {
      duration = map[StoryModelFields.duration];
    }
    if (map[StoryModelFields.captionTxt] != null) {
      captionTxt = map[StoryModelFields.captionTxt].toString();
    }
    if (map[StoryModelFields.captionWidget] != null) {
      captionWidget = map[StoryModelFields.captionWidget];
    }
    if (map[StoryModelFields.boxFit] != null) {
      boxFit = BoxFit.values.firstWhere(
          (e) => e.name == map[StoryModelFields.boxFit],
          orElse: () => BoxFit.fill);
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoryModel &&
        url == other.url &&
        asset == other.asset &&
        text == other.text &&
        type == other.type &&
        duration == other.duration &&
        captionTxt == other.captionTxt &&
        captionWidget == other.captionWidget &&
        boxFit == other.boxFit;
  }

  @override
  int get hashCode =>
      url.hashCode ^
      asset.hashCode ^
      text.hashCode ^
      type.hashCode ^
      duration.hashCode ^
      captionTxt.hashCode ^
      captionWidget.hashCode ^
      boxFit.hashCode;

  ///endregion Equality
}

///endregion Model StoryModel
