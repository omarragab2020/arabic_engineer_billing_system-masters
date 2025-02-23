import 'dart:convert';

///****************************************
///region Model LocationsInfoModelFields
class LocationsInfoModelFields {
  static const String destination_addresses = 'destination_addresses';
  static const String origin_addresses = 'origin_addresses';
  static const String rows = 'rows';
  static const String status = 'status';

  static const List<String> list = [destination_addresses, origin_addresses, rows, status];
}

///endregion Model LocationsInfoModelFields

///****************************************
///region Model LocationsInfoModel
class LocationsInfoModel {
  ///region Fields
  List<String?>? destination_addresses;
  List<String?>? origin_addresses;
  List<RowModel>? rows;
  String? status;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = LocationsInfoModelFields.list;
  List<dynamic> get toArgs => [destination_addresses, origin_addresses, rows, status];

  ///endregion FieldsList

  ///region newInstance
  LocationsInfoModel get newInstance => LocationsInfoModel();

  ///endregion newInstance

  ///region default constructor
  LocationsInfoModel({this.destination_addresses, this.origin_addresses, this.rows, this.status});

  ///endregion default constructor

  ///region withFields constructor
  LocationsInfoModel.withFields(this.destination_addresses, this.origin_addresses, this.rows, this.status);

  ///endregion withFields constructor

  ///region fromMap
  LocationsInfoModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<LocationsInfoModel> fromMapList(List<dynamic> list) {
    return list.map((e) => LocationsInfoModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  LocationsInfoModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (destination_addresses != null) LocationsInfoModelFields.destination_addresses: destination_addresses!,
      if (origin_addresses != null) LocationsInfoModelFields.origin_addresses: origin_addresses!,
      if (rows != null) LocationsInfoModelFields.rows: rows!.map((e) => e.toMap()).toList(),
      if (status != null) LocationsInfoModelFields.status: status,
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
  LocationsInfoModel copyWith({List<String?>? destination_addresses, List<String?>? origin_addresses, List<RowModel>? rows, String? status}) {
    return LocationsInfoModel()
      ..destination_addresses = destination_addresses ?? this.destination_addresses
      ..origin_addresses = origin_addresses ?? this.origin_addresses
      ..rows = rows ?? this.rows
      ..status = status ?? this.status;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({List<String?>? destination_addresses, List<String?>? origin_addresses, List<RowModel>? rows, String? status}) {
    if (destination_addresses != null) {
      this.destination_addresses = destination_addresses;
    }
    if (origin_addresses != null) {
      this.origin_addresses = origin_addresses;
    }
    if (rows != null) {
      this.rows = rows;
    }
    if (status != null) {
      this.status = status;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required LocationsInfoModel another}) {
    if (another.destination_addresses != null) {
      destination_addresses = another.destination_addresses;
    }
    if (another.origin_addresses != null) {
      origin_addresses = another.origin_addresses;
    }
    if (another.rows != null) {
      rows = another.rows;
    }
    if (another.status != null) {
      status = another.status;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[LocationsInfoModelFields.destination_addresses] != null) {
      destination_addresses = (map[LocationsInfoModelFields.destination_addresses] as List).map((e) => (e.toString())).toList();
    }
    if (map[LocationsInfoModelFields.origin_addresses] != null) {
      origin_addresses = (map[LocationsInfoModelFields.origin_addresses] as List).map((e) => (e.toString())).toList();
    }
    if (map[LocationsInfoModelFields.rows] != null) {
      rows = RowModel.fromMapList(map[LocationsInfoModelFields.rows] as List);
    }
    if (map[LocationsInfoModelFields.status] != null) {
      status = map[LocationsInfoModelFields.status].toString();
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationsInfoModel &&
        destination_addresses == other.destination_addresses &&
        origin_addresses == other.origin_addresses &&
        rows == other.rows &&
        status == other.status;
  }

  @override
  int get hashCode => destination_addresses.hashCode ^ origin_addresses.hashCode ^ rows.hashCode ^ status.hashCode;

  ///endregion Equality
}

///endregion Model LocationsInfoModel

///****************************************
///region Model DistanceModelFields
class DistanceModelFields {
  static const String text = 'text';
  static const String value = 'value';

  static const List<String> list = [text, value];
}

///endregion Model DistanceModelFields

///****************************************
///region Model DistanceModel
class DistanceModel {
  ///region Fields
  String? text;
  int? value;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = DistanceModelFields.list;
  List<dynamic> get toArgs => [text, value];

  ///endregion FieldsList

  ///region newInstance
  DistanceModel get newInstance => DistanceModel();

  ///endregion newInstance

  ///region default constructor
  DistanceModel({this.text, this.value});

  ///endregion default constructor

  ///region withFields constructor
  DistanceModel.withFields(this.text, this.value);

  ///endregion withFields constructor

  ///region fromMap
  DistanceModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<DistanceModel> fromMapList(List<dynamic> list) {
    return list.map((e) => DistanceModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  DistanceModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (text != null) DistanceModelFields.text: text,
      if (value != null) DistanceModelFields.value: value,
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
  DistanceModel copyWith({String? text, int? value}) {
    return DistanceModel()
      ..text = text ?? this.text
      ..value = value ?? this.value;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({String? text, int? value}) {
    if (text != null) {
      this.text = text;
    }
    if (value != null) {
      this.value = value;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required DistanceModel another}) {
    if (another.text != null) {
      text = another.text;
    }
    if (another.value != null) {
      value = another.value;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[DistanceModelFields.text] != null) {
      text = map[DistanceModelFields.text].toString();
    }
    if (map[DistanceModelFields.value] != null) {
      value = int.tryParse(map[DistanceModelFields.value].toString());
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DistanceModel && text == other.text && value == other.value;
  }

  @override
  int get hashCode => text.hashCode ^ value.hashCode;

  ///endregion Equality
}

///endregion Model DistanceModel

///****************************************
///region Model DurationModelFields
class DurationModelFields {
  static const String text = 'text';
  static const String value = 'value';

  static const List<String> list = [text, value];
}

///endregion Model DurationModelFields

///****************************************
///region Model DurationModel
class DurationModel {
  ///region Fields
  String? text;
  int? value;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = DurationModelFields.list;
  List<dynamic> get toArgs => [text, value];

  ///endregion FieldsList

  ///region newInstance
  DurationModel get newInstance => DurationModel();

  ///endregion newInstance

  ///region default constructor
  DurationModel({this.text, this.value});

  ///endregion default constructor

  ///region withFields constructor
  DurationModel.withFields(this.text, this.value);

  ///endregion withFields constructor

  ///region fromMap
  DurationModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<DurationModel> fromMapList(List<dynamic> list) {
    return list.map((e) => DurationModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  DurationModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (text != null) DurationModelFields.text: text,
      if (value != null) DurationModelFields.value: value,
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
  DurationModel copyWith({String? text, int? value}) {
    return DurationModel()
      ..text = text ?? this.text
      ..value = value ?? this.value;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({String? text, int? value}) {
    if (text != null) {
      this.text = text;
    }
    if (value != null) {
      this.value = value;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required DurationModel another}) {
    if (another.text != null) {
      text = another.text;
    }
    if (another.value != null) {
      value = another.value;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[DurationModelFields.text] != null) {
      text = map[DurationModelFields.text].toString();
    }
    if (map[DurationModelFields.value] != null) {
      value = int.tryParse(map[DurationModelFields.value].toString());
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DurationModel && text == other.text && value == other.value;
  }

  @override
  int get hashCode => text.hashCode ^ value.hashCode;

  ///endregion Equality
}

///endregion Model DurationModel

///****************************************
///region Model DurationInTrafficModelFields
class DurationInTrafficModelFields {
  static const String text = 'text';
  static const String value = 'value';

  static const List<String> list = [text, value];
}

///endregion Model DurationInTrafficModelFields

///****************************************
///region Model DurationInTrafficModel
class DurationInTrafficModel {
  ///region Fields
  String? text;
  int? value;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = DurationInTrafficModelFields.list;
  List<dynamic> get toArgs => [text, value];

  ///endregion FieldsList

  ///region newInstance
  DurationInTrafficModel get newInstance => DurationInTrafficModel();

  ///endregion newInstance

  ///region default constructor
  DurationInTrafficModel({this.text, this.value});

  ///endregion default constructor

  ///region withFields constructor
  DurationInTrafficModel.withFields(this.text, this.value);

  ///endregion withFields constructor

  ///region fromMap
  DurationInTrafficModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<DurationInTrafficModel> fromMapList(List<dynamic> list) {
    return list.map((e) => DurationInTrafficModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  DurationInTrafficModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (text != null) DurationInTrafficModelFields.text: text,
      if (value != null) DurationInTrafficModelFields.value: value,
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
  DurationInTrafficModel copyWith({String? text, int? value}) {
    return DurationInTrafficModel()
      ..text = text ?? this.text
      ..value = value ?? this.value;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({String? text, int? value}) {
    if (text != null) {
      this.text = text;
    }
    if (value != null) {
      this.value = value;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required DurationInTrafficModel another}) {
    if (another.text != null) {
      text = another.text;
    }
    if (another.value != null) {
      value = another.value;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[DurationInTrafficModelFields.text] != null) {
      text = map[DurationInTrafficModelFields.text].toString();
    }
    if (map[DurationInTrafficModelFields.value] != null) {
      value = int.tryParse(map[DurationInTrafficModelFields.value].toString());
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DurationInTrafficModel && text == other.text && value == other.value;
  }

  @override
  int get hashCode => text.hashCode ^ value.hashCode;

  ///endregion Equality
}

///endregion Model DurationInTrafficModel

///****************************************
///region Model ElementModelFields
class ElementModelFields {
  static const String distance = 'distance';
  static const String duration = 'duration';
  static const String duration_in_traffic = 'duration_in_traffic';
  static const String status = 'status';

  static const List<String> list = [distance, duration, duration_in_traffic, status];
}

///endregion Model ElementModelFields

///****************************************
///region Model ElementModel
class ElementModel {
  ///region Fields
  DistanceModel? distance;
  DurationModel? duration;
  DurationInTrafficModel? duration_in_traffic;
  String? status;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = ElementModelFields.list;
  List<dynamic> get toArgs => [distance, duration, duration_in_traffic, status];

  ///endregion FieldsList

  ///region newInstance
  ElementModel get newInstance => ElementModel();

  ///endregion newInstance

  ///region default constructor
  ElementModel({this.distance, this.duration, this.duration_in_traffic, this.status});

  ///endregion default constructor

  ///region withFields constructor
  ElementModel.withFields(this.distance, this.duration, this.duration_in_traffic, this.status);

  ///endregion withFields constructor

  ///region fromMap
  ElementModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<ElementModel> fromMapList(List<dynamic> list) {
    return list.map((e) => ElementModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  ElementModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (distance != null) ElementModelFields.distance: distance!.toMap(),
      if (duration != null) ElementModelFields.duration: duration!.toMap(),
      if (duration_in_traffic != null) ElementModelFields.duration_in_traffic: duration_in_traffic!.toMap(),
      if (status != null) ElementModelFields.status: status,
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
  ElementModel copyWith({DistanceModel? distance, DurationModel? duration, DurationInTrafficModel? duration_in_traffic, String? status}) {
    return ElementModel()
      ..distance = distance ?? this.distance
      ..duration = duration ?? this.duration
      ..duration_in_traffic = duration_in_traffic ?? this.duration_in_traffic
      ..status = status ?? this.status;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({DistanceModel? distance, DurationModel? duration, DurationInTrafficModel? duration_in_traffic, String? status}) {
    if (distance != null) {
      this.distance = distance;
    }
    if (duration != null) {
      this.duration = duration;
    }
    if (duration_in_traffic != null) {
      this.duration_in_traffic = duration_in_traffic;
    }
    if (status != null) {
      this.status = status;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required ElementModel another}) {
    if (another.distance != null) {
      distance = another.distance;
    }
    if (another.duration != null) {
      duration = another.duration;
    }
    if (another.duration_in_traffic != null) {
      duration_in_traffic = another.duration_in_traffic;
    }
    if (another.status != null) {
      status = another.status;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[ElementModelFields.distance] != null) {
      distance = DistanceModel.fromMap(map[ElementModelFields.distance] as Map<String, dynamic>);
    }
    if (map[ElementModelFields.duration] != null) {
      duration = DurationModel.fromMap(map[ElementModelFields.duration] as Map<String, dynamic>);
    }
    if (map[ElementModelFields.duration_in_traffic] != null) {
      duration_in_traffic = DurationInTrafficModel.fromMap(map[ElementModelFields.duration_in_traffic] as Map<String, dynamic>);
    }
    if (map[ElementModelFields.status] != null) {
      status = map[ElementModelFields.status].toString();
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ElementModel &&
        distance == other.distance &&
        duration == other.duration &&
        duration_in_traffic == other.duration_in_traffic &&
        status == other.status;
  }

  @override
  int get hashCode => distance.hashCode ^ duration.hashCode ^ duration_in_traffic.hashCode ^ status.hashCode;

  ///endregion Equality
}

///endregion Model ElementModel

///****************************************
///region Model RowModelFields
class RowModelFields {
  static const String elements = 'elements';

  static const List<String> list = [elements];
}

///endregion Model RowModelFields

///****************************************
///region Model RowModel
class RowModel {
  ///region Fields
  List<ElementModel>? elements;

  ///endregion Fields

  ///region FieldsList
  List<String> fieldsList = RowModelFields.list;
  List<dynamic> get toArgs => [elements];

  ///endregion FieldsList

  ///region newInstance
  RowModel get newInstance => RowModel();

  ///endregion newInstance

  ///region default constructor
  RowModel({this.elements});

  ///endregion default constructor

  ///region withFields constructor
  RowModel.withFields(this.elements);

  ///endregion withFields constructor

  ///region fromMap
  RowModel.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<RowModel> fromMapList(List<dynamic> list) {
    return list.map((e) => RowModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  RowModel.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
    return {
      if (elements != null) RowModelFields.elements: elements!.map((e) => e.toMap()).toList(),
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
  RowModel copyWith({List<ElementModel>? elements}) {
    return RowModel()..elements = elements ?? this.elements;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({List<ElementModel>? elements}) {
    if (elements != null) {
      this.elements = elements;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required RowModel another}) {
    if (another.elements != null) {
      elements = another.elements;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    if (map[RowModelFields.elements] != null) {
      elements = ElementModel.fromMapList(map[RowModelFields.elements] as List);
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RowModel && elements == other.elements;
  }

  @override
  int get hashCode => elements.hashCode;

  ///endregion Equality
}

///endregion Model RowModel
