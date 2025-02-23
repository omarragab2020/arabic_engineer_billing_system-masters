import 'dart:convert';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:neuss_utils/utils/utils.dart';

///****************************************
///region Model ApiResponseFields
class ApiResponseFields {
  static const String success = 'success';
  static const String msg = 'msg';
  static const String data = 'data';
  static const String errors = 'errors';

  static const List<String> list = [success, msg, data, errors];
}

///endregion Model ApiResponseFields

///****************************************
///region Model ApiResponse
class ApiResponse {
  ///region Fields
  bool success = true;
  String? msg;
  dynamic data;
  String? errors;
  int? statusCode;
  String? statusText;

  bool get failed => !success;

  ///endregion Fields

  ApiResponse.success({this.msg = "Success", this.data});

  ApiResponse.failed({this.msg = "Failed", this.errors = 'Failed'}) {
    success = false;
  }

  ApiResponse.exception({this.msg = "Exception", this.errors = 'Exception'}) {
    success = false;
  }

  ApiResponse.fromResponse(Response<dynamic> response) {
    statusCode = response.statusCode;
    statusText = response.statusText;
    if (response.statusCode != null && (response.statusCode! ~/ 100).toInt() == 2) {
      success = true;
      msg = "Success";
      data = ((response.body))?['data'] ?? ((response.body));
    } else {
      success = false;
      msg = "Failed - ${jsonEncode({'statusCode': statusCode, 'statusText': statusText})}";
      data = ((response.body))?['data'] ?? ((response.body));

      if (response.body is Map && (response.body as Map)['errors'] != null) {
        var errorsResp = (response.body as Map)['errors'];

        if (errorsResp is List && !errorsResp.isEmptyOrNull) {
          errors = errorsResp[0]['message'].toString();
        } else {
          errors = ((response.body))['errors'].toString();
        }
      }
    }
  }

  print([String? tag]) {
    if (success) {
      mPrint2('${tag == null ? '' : '$tag\n'}${toString()}');
    } else {
      mPrintError('${tag == null ? '' : '$tag\n'}${toString()}');
    }
  }

  bool get notSuccess => !success;

  ///region FieldsList
  List<String> fieldsList = ApiResponseFields.list;
  List<dynamic> get toArgs => [success, msg, data, errors];

  ///endregion FieldsList

  ///region newInstance
  ApiResponse get newInstance => ApiResponse();

  ///endregion newInstance

  ///region default constructor
  ApiResponse({this.success = true, this.msg, this.data, this.errors});

  ///endregion default constructor

  ///region withFields constructor
  ApiResponse.withFields(this.success, this.msg, this.data, this.errors);

  ///endregion withFields constructor

  ///region fromMap
  ApiResponse.fromMap(Map<String, dynamic> map) {
    updateFromMap(map);
  }

  ///endregion fromMap

  ///region fromMapList
  static List<ApiResponse> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((e) => ApiResponse.fromMap(e)).toList();
  }

  ///endregion fromMapList

  ///region fromJson
  ApiResponse.fromJson(String jsonInput) : this.fromMap(json.decode(jsonInput));

  ///endregion fromJson

  ///region toMap
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[ApiResponseFields.success] = success;
    if (msg != null) {
      map[ApiResponseFields.msg] = msg;
    }
    map[ApiResponseFields.data] = data;
    if (errors != null) {
      map[ApiResponseFields.errors] = errors;
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
  ApiResponse copyWith({bool? success, String? msg, dynamic data, String? errors}) {
    return ApiResponse()
      ..success = success ?? this.success
      ..msg = msg ?? this.msg
      ..data = data ?? this.data
      ..errors = errors ?? this.errors;
  }

  ///endregion copyWith

  ///region updateWith
  void updateWith({bool? success, String? msg, dynamic data, String? errors}) {
    if (success != null) {
      this.success = success;
    }
    if (msg != null) {
      this.msg = msg;
    }
    if (data != null) {
      this.data = data;
    }
    if (errors != null) {
      this.errors = errors;
    }
  }

  ///endregion updateWith

  ///region updateFrom
  void updateFrom({required ApiResponse another}) {
    success = another.success;
    if (another.msg != null) {
      msg = another.msg;
    }
    data = another.data;
    if (another.errors != null) {
      errors = another.errors;
    }
  }

  ///endregion updateFrom

  ///region updateFromMap
  void updateFromMap(Map<String, dynamic> map) {
    success = ['1', 'true'].contains(map[ApiResponseFields.success].toString().toLowerCase());
    if (map[ApiResponseFields.msg] != null) {
      msg = map[ApiResponseFields.msg].toString();
    }
    data = map[ApiResponseFields.data];
    if (map[ApiResponseFields.errors] != null) {
      errors = map[ApiResponseFields.errors].toString();
    }
  }

  ///endregion updateFromMap

  ///region Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse && success == other.success && msg == other.msg && data == other.data && errors == other.errors;
  }

  @override
  int get hashCode => success.hashCode ^ msg.hashCode ^ data.hashCode ^ errors.hashCode;

  ///endregion Equality
}

///endregion Model ApiResponse
