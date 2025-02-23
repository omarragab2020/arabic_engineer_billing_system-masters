import 'dart:convert';

import 'package:neuss_utils/home/home.dart';

///****************************************
///region Model BannerModelFields
class BannerModelFields {
  static const String txt = 'txt';
  static const String txt_ar = 'txt_ar';
  static const String img = 'img';
  static const String link = 'link';

  static const List<String> list = [txt, txt_ar, img, link];
}

///endregion Model BannerModelFields

///****************************************
///region Model BannerModel
class BannerModel {
  ///region Fields
  String? txt;
  String? txt_ar;
  String? img;
  String? link;

  ///endregion Fields

  String get text => (LanguageService.to.isArabic ? txt_ar : txt) ?? txt_ar ?? txt ?? '';

  ///region FieldsList
  List<String> fieldsList = BannerModelFields.list;
  List<dynamic> get toArgs => [txt, txt_ar, img, link];

  ///endregion FieldsList

  ///region newInstance
  BannerModel get newInstance => BannerModel();

  ///endregion newInstance

  ///region default constructor
  BannerModel({this.txt, this.txt_ar, this.img, this.link});

  ///endregion default constructor

  ///region withFields constructor
  BannerModel.withFields(this.txt, this.txt_ar, this.img, this.link);

  ///endregion withFields constructor

  ///region fromMap
  BannerModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<BannerModel> fromMapList(List<dynamic> list) {
    return list.map((e) => BannerModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  BannerModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (txt != null) BannerModelFields.txt: txt,
      if (txt_ar != null) BannerModelFields.txt_ar: txt_ar,
      if (img != null) BannerModelFields.img: img,
      if (link != null) BannerModelFields.link: link,
    };
//return map;
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
  BannerModel copyWith({String? txt, String? txt_ar, String? img, String? link}) {
    return BannerModel()
      ..txt = txt ?? this.txt
      ..txt_ar = txt_ar ?? this.txt_ar
      ..img = img ?? this.img
      ..link = link ?? this.link;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({String? txt, String? txt_ar, String? img, String? link}) {
    if (txt != null) {
      this.txt = txt;
    }
    if (txt_ar != null) {
      this.txt_ar = txt_ar;
    }
    if (img != null) {
      this.img = img;
    }
    if (link != null) {
      this.link = link;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required BannerModel another}) {
    if (another.txt != null) {
      txt = another.txt;
    }
    if (another.txt_ar != null) {
      txt_ar = another.txt_ar;
    }
    if (another.img != null) {
      img = another.img;
    }
    if (another.link != null) {
      link = another.link;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[BannerModelFields.txt] != null) {
      txt = map[BannerModelFields.txt].toString();
    }
    if (map[BannerModelFields.txt_ar] != null) {
      txt_ar = map[BannerModelFields.txt_ar].toString();
    }
    if (map[BannerModelFields.img] != null) {
      img = map[BannerModelFields.img].toString();
    }
    if (map[BannerModelFields.link] != null) {
      link = map[BannerModelFields.link].toString();
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BannerModel && txt == other.txt && txt_ar == other.txt_ar && img == other.img && link == other.link;
  }

  @override
  int get hashCode => txt.hashCode ^ txt_ar.hashCode ^ img.hashCode ^ link.hashCode;

  ///endregion Equality
}

///endregion Model BannerModel
