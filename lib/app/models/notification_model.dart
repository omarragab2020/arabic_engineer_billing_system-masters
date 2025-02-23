import 'dart:convert';
import 'super_date_converters.dart';

///****************************************
///region Model NotificationModelFields
class NotificationModelFields {
  static const String id = 'id';
  static const String userID = 'userID';
  static const String title = 'title';
  static const String body = 'body';
  static const String seen = 'seen';
  static const String date_created = 'date_created';

  static const List<String> list = [id, userID, title, body, seen, date_created];
}

///endregion Model NotificationModelFields

///****************************************
///region Model NotificationModel
class NotificationModel {
  ///region Fields
  String? id;
  String? userID;
  String? title;
  String? body;
  bool seen = false;
  DateTime? date_created;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = NotificationModelFields.list;
  List<dynamic> get toArgs => [id, userID, title, body, seen, date_created];

  ///endregion FieldsList

  ///region newInstance
  NotificationModel get newInstance => NotificationModel();

  ///endregion newInstance

  ///region default constructor
  NotificationModel({this.id, this.userID, this.title, this.body, this.seen = false, this.date_created});

  ///endregion default constructor

  ///region withFields constructor
  NotificationModel.withFields(this.id, this.userID, this.title, this.body, this.seen, this.date_created);

  ///endregion withFields constructor

  ///region fromMap
  NotificationModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<NotificationModel> fromMapList(List<dynamic> list) {
    return list.map((e) => NotificationModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  NotificationModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (id != null) NotificationModelFields.id: id,
      if (userID != null) NotificationModelFields.userID: userID,
      if (title != null) NotificationModelFields.title: title,
      if (body != null) NotificationModelFields.body: body,
      NotificationModelFields.seen: seen,
      if (date_created != null) NotificationModelFields.date_created: isDateIso8601String ? date_created!.toIso8601String() : SuperDateConverters.toMapConversion(date_created),
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
  NotificationModel copyWith({String? id, String? userID, String? title, String? body, bool? seen, DateTime? date_created}) {
    return NotificationModel()
      ..id = id ?? this.id
      ..userID = userID ?? this.userID
      ..title = title ?? this.title
      ..body = body ?? this.body
      ..seen = seen ?? this.seen
      ..date_created = date_created ?? this.date_created;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({String? id, String? userID, String? title, String? body, bool? seen, DateTime? date_created}) {
    if (id != null) {
      this.id = id;
    }
    if (userID != null) {
      this.userID = userID;
    }
    if (title != null) {
      this.title = title;
    }
    if (body != null) {
      this.body = body;
    }
    if (seen != null) {
      this.seen = seen;
    }
    if (date_created != null) {
      this.date_created = date_created;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required NotificationModel another}) {
    if (another.id != null) {
      id = another.id;
    }
    if (another.userID != null) {
      userID = another.userID;
    }
    if (another.title != null) {
      title = another.title;
    }
    if (another.body != null) {
      body = another.body;
    }
    seen = another.seen;
    if (another.date_created != null) {
      date_created = another.date_created;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[NotificationModelFields.id] != null) {
      id = map[NotificationModelFields.id].toString();
    }
    if (map[NotificationModelFields.userID] != null) {
      userID = map[NotificationModelFields.userID].toString();
    }
    if (map[NotificationModelFields.title] != null) {
      title = map[NotificationModelFields.title].toString();
    }
    if (map[NotificationModelFields.body] != null) {
      body = map[NotificationModelFields.body].toString();
    }
    seen = ['1', 'true'].contains(map[NotificationModelFields.seen].toString().toLowerCase());
    if (map[NotificationModelFields.date_created] != null) {
      date_created = SuperDateConverters.tryParseDateTime(map[NotificationModelFields.date_created]!.toString());
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && id == other.id && userID == other.userID && title == other.title && body == other.body && seen == other.seen && date_created == other.date_created;
  }

  bool isTheSameObjectID(NotificationModel other) => id != null && other.id != null && id == other.id;
  @override
  int get hashCode => id.hashCode ^ userID.hashCode ^ title.hashCode ^ body.hashCode ^ seen.hashCode ^ date_created.hashCode;

  ///endregion Equality
}

///endregion Model NotificationModel
