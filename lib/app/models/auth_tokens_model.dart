import 'dart:convert';

import 'super_date_converters.dart';

///****************************************
///region Model AuthTokensModelFields
class AuthTokensModelFields {
static const String accessToken = 'access_token';
static const String expires = 'expires';
static const String refreshToken = 'refresh_token';
static const String dateTime = 'dateTime';

static const List<String> list=[accessToken,expires,refreshToken,dateTime];
}
///endregion Model AuthTokensModelFields
    

///****************************************
///region Model AuthTokensModel
class AuthTokensModel{
///region Fields
String? accessToken;
int? expires;
String? refreshToken;
DateTime? dateTime = DateTime.now();
///endregion Fields
    
///region FieldsList
List<String> fieldsList = AuthTokensModelFields.list;
List<dynamic> get toArgs => [accessToken,expires,refreshToken,dateTime];
///endregion FieldsList
    
///region newInstance
AuthTokensModel get newInstance => AuthTokensModel();
///endregion newInstance
    
///region default constructor
AuthTokensModel({this.accessToken,this.expires,this.refreshToken,this.dateTime});
///endregion default constructor
    
///region withFields constructor
AuthTokensModel.withFields(this.accessToken,this.expires,this.refreshToken,this.dateTime);
///endregion withFields constructor
    
///region fromMap
AuthTokensModel.fromMap(Map<String, dynamic> map) {updateFromMap(map);}
///endregion fromMap
    
///region fromMapList
static List<AuthTokensModel> fromMapList(List<dynamic> list) {
return list.map((e) => AuthTokensModel.fromMap(e as Map<String, dynamic>)).toList();
}
///endregion fromMapList
    
///region fromJson
AuthTokensModel.fromJson(String jsonInput):this.fromMap(json.decode(jsonInput));
///endregion fromJson
    
///region toMap
Map<String, dynamic> toMap([bool isDateIso8601String = false]) {
return {
if(accessToken != null)AuthTokensModelFields.accessToken : accessToken,
if(expires != null)AuthTokensModelFields.expires : expires,
if(refreshToken != null)AuthTokensModelFields.refreshToken : refreshToken,
if(dateTime != null)AuthTokensModelFields.dateTime : isDateIso8601String?dateTime!.toIso8601String():SuperDateConverters.toMapConversion(dateTime),
};
//return map;
}
///endregion toMap
    
///region toJson
String toJson() => json.encode(toMap());
///endregion toJson
    
///region toString
@override
String toString() => toJson();
///endregion toString

///region copyWith
AuthTokensModel copyWith({String? accessToken,int? expires,String? refreshToken,DateTime? dateTime}){
return AuthTokensModel()
..accessToken=accessToken??this.accessToken
..expires=expires??this.expires
..refreshToken=refreshToken??this.refreshToken
..dateTime=dateTime??this.dateTime;
}
///endregion copyWith

///region updateWith
void updateWith({String? accessToken,int? expires,String? refreshToken,DateTime? dateTime}){
if(accessToken!=null){this.accessToken=accessToken;}
if(expires!=null){this.expires=expires;}
if(refreshToken!=null){this.refreshToken=refreshToken;}
if(dateTime!=null){this.dateTime=dateTime;}
}
///endregion updateWith

///region updateFrom
void updateFrom({required AuthTokensModel another}){
if(another.accessToken!=null){accessToken=another.accessToken;}
if(another.expires!=null){expires=another.expires;}
if(another.refreshToken!=null){refreshToken=another.refreshToken;}
if(another.dateTime!=null){dateTime=another.dateTime;}
}
///endregion updateFrom

///region updateFromMap
void updateFromMap(Map<String,dynamic> map){
if(map[AuthTokensModelFields.accessToken] != null){accessToken = map[AuthTokensModelFields.accessToken] .toString();}
if(map[AuthTokensModelFields.expires] != null){expires = int.tryParse(map[AuthTokensModelFields.expires].toString()) ;}
if(map[AuthTokensModelFields.refreshToken] != null){refreshToken = map[AuthTokensModelFields.refreshToken] .toString();}
if(map[AuthTokensModelFields.dateTime] != null){dateTime = SuperDateConverters.tryParseDateTime(map[AuthTokensModelFields.dateTime]!.toString());}}
///endregion updateFromMap

///region Equality
@override
bool operator ==(Object other) {
  if(identical(this, other)) return true;
  return other is AuthTokensModel && 
  accessToken==other.accessToken&&
expires==other.expires&&
refreshToken==other.refreshToken&&
dateTime==other.dateTime;
}

@override
int get hashCode => accessToken.hashCode ^ 
expires.hashCode ^ 
refreshToken.hashCode ^ 
dateTime.hashCode;
///endregion Equality

}
///endregion Model AuthTokensModel
    