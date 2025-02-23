import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:neuss_utils/models/super_date_converters.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../app/controllers/app_controller.dart';
import '../../app/models/api_response.dart';
import '../../app/models/auth_tokens_model.dart';
import '../../app/models/user_model.dart';
import '../services/offline_storage.dart';
import '../utils/app_constants.dart';
import '_base_api_service.dart';

class AuthApiService extends BaseApiService implements GetxService {
  static AuthApiService get to => Get.find();

  ///region Authentication
  ///************************************************************************************************
  Future<(ApiResponse, AuthTokensModel?)> login(var email, var pass) async {
    ApiResponse apiResponse = await postData('auth/login', jsonEncode({"email": email, "password": pass}));
    if (apiResponse.success) {
      AuthTokensModel authTokensModel = AuthTokensModel.fromMap(apiResponse.data);
      mPrint('authTokensModel: $authTokensModel');
      return (apiResponse, authTokensModel);
    }
    return (apiResponse, null);
  }

  Future<AuthTokensModel?> refreshToken() async {
    if (OfflineStorage.getAuthToken()?.refreshToken == null) return null;
    if (OfflineStorage.getAuthToken()!.dateTime != null && DateTime.now().difference(OfflineStorage.getAuthToken()!.dateTime!.toLocal()) < 12.minutes)
      return OfflineStorage.getAuthToken();
    ApiResponse apiResponse =
        await postData('auth/refresh', jsonEncode({"refresh_token": OfflineStorage.getAuthToken()?.refreshToken, 'mode': 'json'}));
    if (apiResponse.success) {
      AuthTokensModel authTokensModel = AuthTokensModel.fromMap(apiResponse.data);
      mPrint('authTokensModel: $authTokensModel');
      return authTokensModel;
    }
    return null;
  }

  Future<bool> deleteMyUser() async {
    if (!AppController.to.successfullyLoggedIn) {
      mPrintError('Not logged in');
      mShowToast('Not logged in');
      return false;
    }
    ApiResponse apiResponse = await getData("files?filter[uploaded_by][_eq]=${AppController.to.mUserID!}");
    if (apiResponse.success) {
      for (var file in (apiResponse.data as List)) {
        apiResponse = await deleteData("files/${file['id']}");
        if (apiResponse.failed) {
          return false;
        }
      }
      apiResponse = await deleteData("users/${AppController.to.mUserID!}");
      return apiResponse.success;
    }
    return false;
  }

  Future<UserModel?> addMyUser(UserModel userModel) async {
    userModel.phone = userModel.phone?.replaceAll('+', '');
    if (userModel.email.isNullOrEmptyOrWhiteSpace) {
      userModel.email = '${userModel.phone}${AppConstants.defaultEmail}';
    }
    ApiResponse apiResponse = await postData("users", userModel.toJson(true));
    if (apiResponse.success) {
      UserModel user = UserModel.fromMap(apiResponse.data);
    }
    return null;
  }

  Future<UserModel?> updateMyUser(Map<String, dynamic> map) async {
    if (!AppController.to.successfullyLoggedIn) {
      mPrintError('Not logged in');
      mShowToast('Not logged in');
      return null;
    }
    map.remove('id');
    if (map[UserModelFields.password] != null && map[UserModelFields.password].toString().contains('*****')) {
      map.remove(UserModelFields.password);
    }
    ApiResponse apiResponse = await patchData("users/${AppController.to.mUserID!}?fields=*,UserInfo.*,availability.*", jsonEncode(map));
    if (apiResponse.success) {
      UserModel user = UserModel.fromMap(apiResponse.data);
      return user;
    }
    return null;
  }

  Future<UserModel?> updateMyPassword(String newPass) async {
    if (newPass.isNullOrEmptyOrWhiteSpace) {
      mPrintError('Password empty');
      mShowToast('Password empty');
      return null;
    }
    ApiResponse apiResponse =
        await patchData("users/${AppController.to.mUserID!}?fields=*,UserInfo.*,availability.*", jsonEncode({UserModelFields.password: newPass}));
    if (apiResponse.success) {
      UserModel user = UserModel.fromMap(apiResponse.data);
      return user;
    }
    return null;
  }

  Future<(ApiResponse?, UserModel?)> queryUserByPhone(String phone) async {
    phone = phone.replaceAll('+', '');
    ApiResponse apiResponse = await getData("users?filter[phone][_eq]=$phone&fields=*,UserInfo.*,availability.*");

    if (apiResponse.success) {
      try {
        List dataList = (apiResponse.data as List);
        if (dataList.length == 1) {
          return (apiResponse, UserModel.fromMap(dataList.first));
        } else {
          mPrint('returned list.length = ${dataList.length}');
          return (apiResponse, null);
        }
      } catch (e) {
        mPrintError("Exception: $e");
      }
    }

    return (apiResponse, null);
  }

  ///************************************************************************************************
  ///endregion Authentication
}
