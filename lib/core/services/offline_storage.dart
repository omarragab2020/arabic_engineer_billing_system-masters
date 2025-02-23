import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:neuss_utils/utils/app_isolates.dart';
import 'package:neuss_utils/utils/helpers.dart';

import '../../app/models/admin_data_model.dart';
import '../../app/models/auth_tokens_model.dart';
import '../../app/models/location_model.dart';
import '../../app/models/user_model.dart';

class OfflineStorage {
  static final GetStorage _storage = GetStorage();

  static const String _userKey = "USER_KEY";
  static const String _usersKey = "USERs_KEY";
  static const String _usersInfoKey = "USERsInfo_KEY";
  static const String _usersTimeKey = "USERsTime_KEY";
  static const String _tokenKey = "_tokenKey";
  static const String _myFavoritePersonsIdKey = "FavoritePersonsIdKey";
  static const String _myMyPasswordKey = "MyPasswordKey";
  static const String _authPhoneKey = "authPhoneKey";
  static const String _adminDataKey = "adminDataKey";
  static const String _curQuranPageKey = "curQuranPageKey";
  static const String _myLocationKey = "DriverLocKey";


  static const String _bgCallKey = "bgCallKey";

  ///region Users
  static Future<void> saveUsers(List<UserModel> users,DateTime userTime,DateTime infoTime) async {
    // mPrint('Storing users (${users.length})');
    await _storage.write(_usersKey, (users.map((e)=>e.toMap()).toList()));
    // mPrint2('Storing users times {userTime: ${userTime.toIso8601String()} - infoTime: ${infoTime.toIso8601String()}');
    await _storage.write(_usersTimeKey, userTime.millisecondsSinceEpoch);
    await _storage.write(_usersInfoKey, infoTime.millisecondsSinceEpoch);
    // mPrint('Storing users 3');

  }
  static void eraseUsers() => {/*mPrint('Erasing user'),*/ _storage.remove(_usersKey),_storage.remove(_usersTimeKey),_storage.remove(_usersInfoKey)};

  static bool get hasUsers => _storage.hasData(_usersKey)&&_storage.hasData(_usersTimeKey)&&_storage.hasData(_usersInfoKey);

  static (DateTime,DateTime)? getUsersTime() {
    if (hasUsers)return (DateTime.fromMillisecondsSinceEpoch(_storage.read(_usersTimeKey),isUtc:true),DateTime.fromMillisecondsSinceEpoch(_storage.read(_usersInfoKey),isUtc:true));
    return null;
  }
  static Future<List<UserModel>?> getUsers() async {
    mPrint('Reading users');
    if (_storage.hasData(_usersKey)) {
      mPrint('Reading users 2');
      // mPrint('Reading users 2 ${_storage.read(_usersKey)}');
      List<UserModel> users =
       await AppIsolates.spawnListWithIsolate(UserModel.fromMapList, _storage.read(_usersKey));
      mPrint("Reading Users 3 = (${users.length})");
      return users;
    }
    return null;
  }

  ///endregion User
  ///
  ///region User
  static void saveUser(UserModel userModel) => {/*mPrint('Storing user $userModel'),*/ _storage.write(_userKey, userModel.toMap())};

  static void eraseUser() => {/*mPrint('Erasing user'),*/ _storage.remove(_userKey)};

  static UserModel? getUser() {
    // mPrint('Reading user');
    if (_storage.hasData(_userKey)) {
      UserModel user = UserModel.fromMap(_storage.read(_userKey));
      mPrint("Reading User = $user");
      return user;
    }
    return null;
  }

  ///endregion User

  ///region AdminData
  static void saveAdminData(AdminDataModel adminDataModel) =>
      {/*mPrint('Storing AdminData $adminDataModel'),*/ _storage.write(_adminDataKey, adminDataModel.toMap())};

  static void eraseAdminData() => {/*mPrint('Erasing AdminData'),*/ _storage.remove(_adminDataKey)};

  static AdminDataModel? getAdminData() {
    // mPrint('Reading AdminData');
    if (_storage.hasData(_adminDataKey)) {
      AdminDataModel adminData = AdminDataModel.fromMap(_storage.read(_adminDataKey));
      // mPrint("AdminData = $adminData");
      return adminData;
    }
    return null;
  }

  ///endregion User

  ///region Token
  static void saveAuthToken(AuthTokensModel? authTokensModel) => {
        mPrint('Storing AuthTokens $authTokensModel'),
        (authTokensModel?.accessToken == null || authTokensModel?.refreshToken == null)
            ? eraseAuthToken()
            : _storage.write(_tokenKey, authTokensModel!.toMap())
      };

  static void eraseAuthToken() => {mPrint('Erasing Token'), _storage.remove(_tokenKey)};

  static AuthTokensModel? getAuthToken() {
    // mPrint('Reading Auth Token');
    if (_storage.hasData(_tokenKey)) {
      AuthTokensModel authTokensModel = AuthTokensModel.fromMap(_storage.read(_tokenKey));

      // mPrint("Cached Auth Token = $authTokensModel");
      return authTokensModel;
    }
    return null;
  }

  ///endregion Token

  ///region FavID
  static void saveMyFavoritePersonsId(int myFavoritePersonsId) =>
      {/*mPrint('Storing FavoritePersonsId $myFavoritePersonsId'),*/ _storage.write(_myFavoritePersonsIdKey, myFavoritePersonsId)};

  static void eraseMyFavoritePersonsId() => {/*mPrint('Erasing MyFavoritePersonsId'),*/ _storage.remove(_myFavoritePersonsIdKey)};

  static int? getMyFavoritePersonsId() {
    // mPrint('Reading MyFavoritePersonsId');
    if (_storage.hasData(_myFavoritePersonsIdKey)) {
      int favID = _storage.read(_myFavoritePersonsIdKey);
      // mPrint("MyFavoritePersonsId = $favID");
      return favID;
    }
    return null;
  }

  ///endregion FavID

  ///region MyPassword
  static void saveMyPassword(String myPassword) => {/*mPrint('Storing MyPassword $myPassword'),*/ _storage.write(_myMyPasswordKey, myPassword)};

  static void eraseMyPassword() => {/*mPrint('Erasing MyPassword'),*/ _storage.remove(_myMyPasswordKey)};

  static String? getMyPassword() {
    // mPrint('Reading MyPassword');
    if (_storage.hasData(_myMyPasswordKey)) {
      String pass = _storage.read(_myMyPasswordKey);
      // mPrint("MyPassword = $pass");
      return pass;
    }
    return null;
  }

  ///endregion MyPassword

  ///region Location
  static void saveMyDriverLoc(LocationModel locationModel) =>
      {mPrint('Storing saveMyDriverLoc $locationModel'), _storage.write(_myLocationKey, locationModel.toJson())};

  static void eraseMyDriverLoc() => {mPrint('Erasing MyDriverLoc'), _storage.remove(_myLocationKey)};

  static LocationModel? getMyDriverLoc() {
    mPrint('Reading MyDriverLoc');
    if (_storage.hasData(_myLocationKey)) {
      LocationModel loc = LocationModel.fromJson(_storage.read(_myLocationKey));
      mPrint("MyDriverLoc = $loc");
      return loc;
    }
    return null;
  }

  ///endregion Location

  ///region Authed Phones
  static void addAuthPhone(String phone) {
    phone = phone.replaceAll("+", "");
    mPrint('Adding AuthPhone $phone');

    Set phones = getAuthPhones() ?? {};
    phones.add(phone);
    mPrint('phones = $phones');
    _storage.write(_authPhoneKey, jsonEncode(<String>[...phones]));
  }

  static bool checkAuthPhone(String phone) {
    phone = phone.replaceAll("+", "");
    mPrint('Checking AuthPhone $phone');
    Set phones = getAuthPhones() ?? {};
    return phones.contains(phone);
  }

  static void removeAuthPhone(String phone) {
    phone = phone.replaceAll("+", "");
    mPrint('Erasing AuthPhone $phone');
    Set phones = getAuthPhones() ?? {};
    phones.remove(phone);
    _storage.write(_authPhoneKey, jsonEncode(<String>[...phones]));
  }

  static void eraseAuthPhones() => {mPrint('Erasing eraseAuthPhones'), _storage.remove(_authPhoneKey)};

  static Set? getAuthPhones() {
    mPrint('Reading AuthPhones');
    if (_storage.hasData(_authPhoneKey)) {
      Set phones = (jsonDecode(_storage.read(_authPhoneKey))).toSet();
      mPrint("phones = $phones");
      return phones;
    }
    return null;
  }

  ///endregion Authed Phones

  static void eraseAll() => {eraseUser(), eraseMyPassword(), eraseAuthToken(), eraseMyFavoritePersonsId(),eraseUsers()};
}
