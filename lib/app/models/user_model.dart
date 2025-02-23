import 'dart:convert';
import 'super_date_converters.dart';

///****************************************
///region Model UserModelFields
class UserModelFields {
  static const String id = 'id';
  static const String first_name = 'first_name';
  static const String last_name = 'last_name';
  static const String email = 'email';
  static const String password = 'password';
  static const String phone = 'phone';
  static const String location = 'location';
  static const String description = 'description';
  static const String avatar = 'avatar';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String role = 'role';
  static const String token = 'token';
  static const String fcm_token = 'fcm_token';
  static const String dob = 'dob';
  static const String gender = 'gender';
  static const String isAndroid = 'isAndroid';
  static const String approved = 'approved';
  static const String loc_id = 'loc_id';
  static const String rate = 'rate';
  static const String point = 'point';
  static const String dateUpdated = 'dateUpdated';

  static const List<String> list = [
    id,
    first_name,
    last_name,
    email,
    password,
    phone,
    location,
    description,
    avatar,
    language,
    theme,
    role,
    token,
    fcm_token,
    dob,
    gender,
    isAndroid,
    approved,
    loc_id,
    rate,
    point,
    dateUpdated
  ];
}

///endregion Model UserModelFields

///****************************************
///region Model UserModel
class UserModel {
  ///region Fields
  String? id;
  String? first_name;
  String? last_name;
  String? email;
  String? password;
  String? phone;
  String? location;
  String? description;
  String? avatar;
  String? language;
  String? theme;
  String? role;
  String? token;
  String? fcm_token;
  DateTime? dob;
  bool gender = true;
  bool isAndroid = true;
  bool approved = false;
  int? loc_id;
  int rate = 1;
  double point = 5.0;
  DateTime? dateUpdated;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = UserModelFields.list;

  List<dynamic> get toArgs => [
        id,
        first_name,
        last_name,
        email,
        password,
        phone,
        location,
        description,
        avatar,
        language,
        theme,
        role,
        token,
        fcm_token,
        dob,
        gender,
        isAndroid,
        approved,
        loc_id,
        rate,
        point,
        dateUpdated
      ];

  ///endregion FieldsList

  ///region newInstance
  UserModel get newInstance => UserModel();

  ///endregion newInstance

  ///region default constructor
  UserModel(
      {this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.password,
      this.phone,
      this.location,
      this.description,
      this.avatar,
      this.language,
      this.theme,
      this.role,
      this.token,
      this.fcm_token,
      this.dob,
      this.gender = true,
      this.isAndroid = true,
      this.approved = false,
      this.loc_id,
      this.rate = 1,
      this.point = 5.0,
      this.dateUpdated});

  ///endregion default constructor

  ///region withFields constructor
  UserModel.withFields(
      this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.password,
      this.phone,
      this.location,
      this.description,
      this.avatar,
      this.language,
      this.theme,
      this.role,
      this.token,
      this.fcm_token,
      this.dob,
      this.gender,
      this.isAndroid,
      this.approved,
      this.loc_id,
      this.rate,
      this.point,
      this.dateUpdated);

  ///endregion withFields constructor

  ///region fromMap
  UserModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<UserModel> fromMapList(List<dynamic> list) {
    return list
        .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  ///endregion fromMapList

  ///region fromJson
  UserModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (id != null) UserModelFields.id: id,
      if (first_name != null) UserModelFields.first_name: first_name,
      if (last_name != null) UserModelFields.last_name: last_name,
      if (email != null) UserModelFields.email: email,
      if (password != null) UserModelFields.password: password,
      if (phone != null) UserModelFields.phone: phone,
      if (location != null) UserModelFields.location: location,
      if (description != null) UserModelFields.description: description,
      if (avatar != null) UserModelFields.avatar: avatar,
      if (language != null) UserModelFields.language: language,
      if (theme != null) UserModelFields.theme: theme,
      if (role != null) UserModelFields.role: role,
      if (token != null) UserModelFields.token: token,
      if (fcm_token != null) UserModelFields.fcm_token: fcm_token,
      if (dob != null)
        UserModelFields.dob: isDateIso8601String
            ? dob!.toIso8601String()
            : SuperDateConverters.toMapConversion(dob),
      UserModelFields.gender: gender,
      UserModelFields.isAndroid: isAndroid,
      UserModelFields.approved: approved,
      if (loc_id != null) UserModelFields.loc_id: loc_id,
      UserModelFields.rate: rate,
      UserModelFields.point: point,
      if (dateUpdated != null)
        UserModelFields.dateUpdated: isDateIso8601String
            ? dateUpdated!.toIso8601String()
            : SuperDateConverters.toMapConversion(dateUpdated),
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
  UserModel copyWith(
      {String? id,
      String? first_name,
      String? last_name,
      String? email,
      String? password,
      String? phone,
      String? location,
      String? description,
      String? avatar,
      String? language,
      String? theme,
      String? role,
      String? token,
      String? fcm_token,
      DateTime? dob,
      bool? gender,
      bool? isAndroid,
      bool? approved,
      int? loc_id,
      int? rate,
      double? point,
      DateTime? dateUpdated}) {
    return UserModel()
      ..id = id ?? this.id
      ..first_name = first_name ?? this.first_name
      ..last_name = last_name ?? this.last_name
      ..email = email ?? this.email
      ..password = password ?? this.password
      ..phone = phone ?? this.phone
      ..location = location ?? this.location
      ..description = description ?? this.description
      ..avatar = avatar ?? this.avatar
      ..language = language ?? this.language
      ..theme = theme ?? this.theme
      ..role = role ?? this.role
      ..token = token ?? this.token
      ..fcm_token = fcm_token ?? this.fcm_token
      ..dob = dob ?? this.dob
      ..gender = gender ?? this.gender
      ..isAndroid = isAndroid ?? this.isAndroid
      ..approved = approved ?? this.approved
      ..loc_id = loc_id ?? this.loc_id
      ..rate = rate ?? this.rate
      ..point = point ?? this.point
      ..dateUpdated = dateUpdated ?? this.dateUpdated;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith(
      {String? id,
      String? first_name,
      String? last_name,
      String? email,
      String? password,
      String? phone,
      String? location,
      String? description,
      String? avatar,
      String? language,
      String? theme,
      String? role,
      String? token,
      String? fcm_token,
      DateTime? dob,
      bool? gender,
      bool? isAndroid,
      bool? approved,
      int? loc_id,
      int? rate,
      double? point,
      DateTime? dateUpdated}) {
    if (id != null) {
      this.id = id;
    }
    if (first_name != null) {
      this.first_name = first_name;
    }
    if (last_name != null) {
      this.last_name = last_name;
    }
    if (email != null) {
      this.email = email;
    }
    if (password != null) {
      this.password = password;
    }
    if (phone != null) {
      this.phone = phone;
    }
    if (location != null) {
      this.location = location;
    }
    if (description != null) {
      this.description = description;
    }
    if (avatar != null) {
      this.avatar = avatar;
    }
    if (language != null) {
      this.language = language;
    }
    if (theme != null) {
      this.theme = theme;
    }
    if (role != null) {
      this.role = role;
    }
    if (token != null) {
      this.token = token;
    }
    if (fcm_token != null) {
      this.fcm_token = fcm_token;
    }
    if (dob != null) {
      this.dob = dob;
    }
    if (gender != null) {
      this.gender = gender;
    }
    if (isAndroid != null) {
      this.isAndroid = isAndroid;
    }
    if (approved != null) {
      this.approved = approved;
    }
    if (loc_id != null) {
      this.loc_id = loc_id;
    }
    if (rate != null) {
      this.rate = rate;
    }
    if (point != null) {
      this.point = point;
    }
    if (dateUpdated != null) {
      this.dateUpdated = dateUpdated;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required UserModel another}) {
    if (another.id != null) {
      id = another.id;
    }
    if (another.first_name != null) {
      first_name = another.first_name;
    }
    if (another.last_name != null) {
      last_name = another.last_name;
    }
    if (another.email != null) {
      email = another.email;
    }
    if (another.password != null) {
      password = another.password;
    }
    if (another.phone != null) {
      phone = another.phone;
    }
    if (another.location != null) {
      location = another.location;
    }
    if (another.description != null) {
      description = another.description;
    }
    if (another.avatar != null) {
      avatar = another.avatar;
    }
    if (another.language != null) {
      language = another.language;
    }
    if (another.theme != null) {
      theme = another.theme;
    }
    if (another.role != null) {
      role = another.role;
    }
    if (another.token != null) {
      token = another.token;
    }
    if (another.fcm_token != null) {
      fcm_token = another.fcm_token;
    }
    if (another.dob != null) {
      dob = another.dob;
    }
    gender = another.gender;
    isAndroid = another.isAndroid;
    approved = another.approved;
    if (another.loc_id != null) {
      loc_id = another.loc_id;
    }
    rate = another.rate;
    point = another.point;
    if (another.dateUpdated != null) {
      dateUpdated = another.dateUpdated;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[UserModelFields.id] != null) {
      id = map[UserModelFields.id].toString();
    }
    if (map[UserModelFields.first_name] != null) {
      first_name = map[UserModelFields.first_name].toString();
    }
    if (map[UserModelFields.last_name] != null) {
      last_name = map[UserModelFields.last_name].toString();
    }
    if (map[UserModelFields.email] != null) {
      email = map[UserModelFields.email].toString();
    }
    if (map[UserModelFields.password] != null) {
      password = map[UserModelFields.password].toString();
    }
    if (map[UserModelFields.phone] != null) {
      phone = map[UserModelFields.phone].toString();
    }
    if (map[UserModelFields.location] != null) {
      location = map[UserModelFields.location].toString();
    }
    if (map[UserModelFields.description] != null) {
      description = map[UserModelFields.description].toString();
    }
    if (map[UserModelFields.avatar] != null) {
      avatar = map[UserModelFields.avatar].toString();
    }
    if (map[UserModelFields.language] != null) {
      language = map[UserModelFields.language].toString();
    }
    if (map[UserModelFields.theme] != null) {
      theme = map[UserModelFields.theme].toString();
    }
    if (map[UserModelFields.role] != null) {
      role = map[UserModelFields.role].toString();
    }
    if (map[UserModelFields.token] != null) {
      token = map[UserModelFields.token].toString();
    }
    if (map[UserModelFields.fcm_token] != null) {
      fcm_token = map[UserModelFields.fcm_token].toString();
    }
    if (map[UserModelFields.dob] != null) {
      dob = SuperDateConverters.tryParseDateTime(
          map[UserModelFields.dob]!.toString());
    }
    if (map[UserModelFields.gender] != null) {
      gender = ['1', 'true']
          .contains(map[UserModelFields.gender].toString().toLowerCase());
    }
    if (map[UserModelFields.isAndroid] != null) {
      isAndroid = ['1', 'true']
          .contains(map[UserModelFields.isAndroid].toString().toLowerCase());
    }
    if (map[UserModelFields.approved] != null) {
      approved = ['1', 'true']
          .contains(map[UserModelFields.approved].toString().toLowerCase());
    }
    if (map[UserModelFields.loc_id] != null) {
      loc_id = int.tryParse(map[UserModelFields.loc_id].toString());
    }
    if (map[UserModelFields.rate] != null) {
      rate = int.tryParse(map[UserModelFields.rate].toString()) ?? 1;
    }
    if (map[UserModelFields.point] != null) {
      point = double.tryParse(map[UserModelFields.point].toString()) ?? 5.0;
    }
    if (map[UserModelFields.dateUpdated] != null) {
      dateUpdated = SuperDateConverters.tryParseDateTime(
          map[UserModelFields.dateUpdated]!.toString());
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        id == other.id &&
        first_name == other.first_name &&
        last_name == other.last_name &&
        email == other.email &&
        password == other.password &&
        phone == other.phone &&
        location == other.location &&
        description == other.description &&
        avatar == other.avatar &&
        language == other.language &&
        theme == other.theme &&
        role == other.role &&
        token == other.token &&
        fcm_token == other.fcm_token &&
        dob == other.dob &&
        gender == other.gender &&
        isAndroid == other.isAndroid &&
        approved == other.approved &&
        loc_id == other.loc_id &&
        rate == other.rate &&
        point == other.point &&
        dateUpdated == other.dateUpdated;
  }

  bool isTheSameObjectID(UserModel other) =>
      id != null && other.id != null && id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^
      first_name.hashCode ^
      last_name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      phone.hashCode ^
      location.hashCode ^
      description.hashCode ^
      avatar.hashCode ^
      language.hashCode ^
      theme.hashCode ^
      role.hashCode ^
      token.hashCode ^
      fcm_token.hashCode ^
      dob.hashCode ^
      gender.hashCode ^
      isAndroid.hashCode ^
      approved.hashCode ^
      loc_id.hashCode ^
      rate.hashCode ^
      point.hashCode ^
      dateUpdated.hashCode;

  ///endregion Equality
}

///endregion Model UserModel
