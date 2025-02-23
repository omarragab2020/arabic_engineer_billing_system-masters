import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/app_isolates.dart';

import '../../app/controllers/app_controller.dart';
import '../../app/models/admin_data_model.dart';
import '../../app/models/api_response.dart';
import '../../app/models/location_model.dart';
import '../../app/models/notification_model.dart';
import '../../app/models/user_model.dart';
import '../services/offline_storage.dart';
import '../utils/app_constants.dart';
import '_base_api_service.dart';

class AppApiService extends BaseApiService implements GetxService {
  static AppApiService get to => Get.find();

  ///region Helpers
  ///************************************************************************************************

  Future<UserModel?> updateUser(String id, Map<String, dynamic> map) async {
    ApiResponse apiResponse = await patchData("users/$id", jsonEncode(map));
    if (apiResponse.success) {
      return await AppIsolates.spawnWithIsolate(UserModel.fromMap, apiResponse.data);
    }
    return null;
  }

  Future<UserModel?> getMyUser() async {
    try {
      if (!AppController.to.successfullyLoggedIn) {
        mPrintError('Not logged in');
        mShowToast('Not logged in');
        return null;
      }
      return await getUser(AppController.to.mUserID!);
    } catch (e) {
      mPrintError("Exception: $e");
    }
    return null;
  }

  Future<bool> checkMyUserExist() async {
    AppController controller = AppController.to;
    if (!controller.successfullyLoggedIn) return false;
    ApiResponse apiResponse = await getData('users/${controller.mUserID}?fields=id');
    if (apiResponse.statusCode == 403) {
      return false;
    }
    return true;
  }

  Future<UserModel?> getUser(String id) async {
    ApiResponse apiResponse = await getData('users/$id?fields=*,UserInfo.*,availability.*');
    if (apiResponse.success) {
      return await AppIsolates.spawnWithIsolate(UserModel.fromMap, apiResponse.data);
    }
    return null;
  }

  Future<String?> getUserFCMByID(String id) async {
    ApiResponse apiResponse = await getData('users/$id?fields=fcm_token');
    if (apiResponse.success) {
      return apiResponse.data['fcm_token'];
    }
    return null;
  }

  Future<UserModel?> getUserWithInfoByPhone(String phone) async {
    phone = phone.replaceAll('+', '');
    ApiResponse apiResponse = await getData("users?fields=*,UserInfo.*,availability.*&filter[phone][_eq]=$phone");
    if (apiResponse.success) {
      List dataList = (apiResponse.data as List);
      if (dataList.length == 1) {
        return await AppIsolates.spawnWithIsolate(UserModel.fromMap, dataList.first);
      } else {
        mPrint('returned list.length = ${dataList.length}');
      }
    }
    return null;
  }

  Future<List<UserModel>> getUsersWithInfoByRole(String role) async {
    List<UserModel> users = [];
    ApiResponse apiResponse = await getData("users?fields=*,UserInfo.*,availability.*&filter[role][_eq]=$role");
    if (apiResponse.success) {
      users = await AppIsolates.spawnListWithIsolate(UserModel.fromMapList, apiResponse.data);
      // users = UserModel.fromMapList(apiResponse.data);
    }
    return users;
  }

  Future<List<UserModel>?> queryAllUsers() async {
    List<UserModel>? users;
    AppController controller = AppController.to;
    DateTime now = DateTime.now().toUtc().subtract(1.seconds);
    String url = "users?fields=*,UserInfo.*,availability.*";
    if (AppController.to.successfullyLoggedIn && !controller.isAdmin) {
      url += "&filter[gender][_eq]=${controller.mUser?.gender ?? true}";
    }
    url += "&filter[role][_in]=${AppConstants.roleStudent},${AppConstants.roleTeacher}"
        "&limit=-1";
    // mPrint('queryAllUsers url = $url');

    ApiResponse apiResponse = await getData(url, printData: false);
    if (apiResponse.success) {
      users = await AppIsolates.spawnListWithIsolate(UserModel.fromMapList, apiResponse.data);
      // users = UserModel.fromMapList(apiResponse.data as List);
      controller.lastUsersUpdateTime = now;
    }
    return users;
  }

  Future<List<String>?> getMyFavouriteIDS() async {
    if (!AppController.to.successfullyLoggedIn || AppController.to.myFavoritePersonsId == 0) {
      mPrintError('Not logged in');
      mShowToast('Not logged in');
      return null;
    }
    List<String> favListIDS = [];
    ApiResponse apiResponse = await getData("items/Favorite_Persons/${AppController.to.myFavoritePersonsId}?fields=faviID.directus_users_id");
    if (apiResponse.success) {
      List dataList = (apiResponse.data['faviID'] as List);
      favListIDS = (dataList).map((e) => e['directus_users_id'].toString()).toList();
    }
    return favListIDS;
  }

  Future<List<String>?> queryMyFavouriteIDS() async {
    if (!AppController.to.successfullyLoggedIn) {
      mPrintError('Not logged in');
      mShowToast('Not logged in');
      return null;
    }
    mPrint('queryMyFavouriteIDS');
    List<String> favListIDS = [];
    ApiResponse apiResponse = await getData("items/Favorite_Persons?fields=id,faviID.*&filter[user][id][_eq]=${AppController.to.mUserID!}");
    if (apiResponse.success) {
      List dataList = (apiResponse.data as List);
      if (dataList.length == 1) {
        AppController.to.myFavoritePersonsId = dataList.first['id'];
        OfflineStorage.saveMyFavoritePersonsId(AppController.to.myFavoritePersonsId);

        dataList = (dataList.first['faviID'] as List);
        favListIDS = (dataList).map((e) => e['directus_users_id'].toString()).toList();
      }
    }
    return favListIDS;
  }

  Future<bool> createMyFavouriteIDS() async {
    if (!AppController.to.successfullyLoggedIn) {
      mPrintError('Not logged in');
      mShowToast('Not logged in');
      return false;
    }

    ApiResponse apiResponse = await postData(
        "items/Favorite_Persons?fields=id,faviID.*",
        jsonEncode({
          "user": {
            "id": AppController.to.mUserID!,
          },
          "faviID": []
        }));

    if (apiResponse.success) {
      AppController.to.myFavoritePersonsId = apiResponse.data['id'];
      OfflineStorage.saveMyFavoritePersonsId(AppController.to.myFavoritePersonsId);
    }
    return apiResponse.success;
  }

  Future<List<String>?> updateMyFavouriteIDS() async {
    if (!AppController.to.successfullyLoggedIn || AppController.to.myFavoritePersonsId == 0) {
      mPrintError('Not logged in');
      mShowToast('Not logged in');
      return null;
    }
    List<String>? favListIDS;

    ApiResponse apiResponse = await patchData(
        "items/Favorite_Persons/${AppController.to.myFavoritePersonsId}?fields=faviID.*",
        jsonEncode({
          "faviID": AppController.to.myFavouriteIDS.map((e) => {'directus_users_id': e}).toList()
        }));
    if (apiResponse.success) {
      List dataList = (apiResponse.data['faviID'] as List);
      favListIDS = (dataList).map((e) => e['directus_users_id'].toString()).toList();
    }

    return favListIDS;
  }

  Future<List<NotificationModel>?> getMyNotifications(DateTime lastNotifyUpdate) async {
    if (AppController.to.mUserID == null) {
      return null;
    }

    DateTime now = DateTime.now().toUtc().subtract(5.seconds);
    ApiResponse apiResponse = await getData(
        "items/Notification?fields=*,user_created.*"
        "&filter[_or][0][user][_eq]=${AppController.to.mUserID!}"
        "&filter[_or][1][user][_null]=true"
        "&filter[_and][2][_or][3][date_created][_gt]=${lastNotifyUpdate.toIso8601String()}"
        "&filter[_and][2][_or][4][date_updated][_gt]=${lastNotifyUpdate.toIso8601String()}"
        "&limit=-1",
        printData: false);
    if (apiResponse.success) {
      List<NotificationModel> res = await AppIsolates.spawnListWithIsolate(NotificationModel.fromMapList, apiResponse.data);
      // List<NotificationModel> res = NotificationModel.fromMapList(apiResponse.data);
      AppController.to.lastNotifyUpdate = now;
      return res;
    }
    return null;
  }

  Future<bool> deleteMyNotifications() async {
    if (AppController.to.mUserID == null) {
      return false;
    }
    // final List<Map<String, dynamic>> deleteRequests = AppController.to.myNotificationsList.map((notify) {
    //   return {
    //     'method': 'DELETE',
    //     'path': '/${notify.id}',
    //   };
    // }).toList();
    //
    // ApiResponse apiResponse = await postData("items/Notification", jsonEncode(deleteRequests));
    // return (apiResponse.success);

    for (var element in AppController.to.myNotificationsList) {
      ApiResponse apiResponse = await deleteData("items/Notification/${element.id}");
      if (!apiResponse.success) return false;
    }
    return true;
  }

  Future<NotificationModel?> addNotification(NotificationModel notificationModel) async {
    return null;
    if (AppController.to.mUserID == null) {
      return null;
    }
    ApiResponse apiResponse = await postData("items/Notification?fields=*", notificationModel.toJson());
    if (apiResponse.success) {
      return await AppIsolates.spawnWithIsolate(NotificationModel.fromMap, apiResponse.data);
    }
    return null;
  }

  Future<NotificationModel?> updateNotification(int id, Map<String, dynamic> map) async {
    if (AppController.to.mUserID == null) {
      return null;
    }
    ApiResponse apiResponse = await patchData("items/Notification/$id?fields=*", jsonEncode(map));
    if (apiResponse.success) {
      return await AppIsolates.spawnWithIsolate(NotificationModel.fromMap, apiResponse.data);
    }
    return null;
  }

  Future<bool> deleteNotification(int id) async {
    ApiResponse apiResponse = await deleteData("items/Notification/$id");
    return apiResponse.success;
  }

  Future<AdminDataModel?> getAdminConfigData([DateTime? time]) async {
    String url = 'items/Quran_admindata';
    if (time != null) url += "?filter[${AdminDataModelFields.dateUpdated}][_gte]=${time.toIso8601String()}";
    ApiResponse apiResponse = await getData(url, printData: false);
    if (apiResponse.success) {
      return await AppIsolates.spawnWithIsolate(AdminDataModel.fromMap, apiResponse.data);
    }
    return null;
  }

  ///************************************************************************************************
  ///endregion Helpers
  ///
  /// region Location

  Future<LocationModel?> createUserLocation(LocationModel locationModel) async {
    ApiResponse apiResponse = await postData("items/Location", locationModel.toJson());
    if (apiResponse.success) {
      return LocationModel.fromMap(apiResponse.data);
    }
    return null;
  }

  Future<LocationModel?> updateUserLocation(int id, Map<String, dynamic> map) async {
    ApiResponse apiResponse = await patchData("items/Location/$id", jsonEncode(map));
    if (apiResponse.success) {
      return LocationModel.fromMap(apiResponse.data);
    }
    return null;
  }

  Future<LocationModel?> getUserLocationByID(String locID) async {
    ApiResponse apiResponse = await getData("items/Location/$locID");

    if (apiResponse.success) {
      LocationModel model = LocationModel.fromMap((apiResponse.data as List).first);
      mPrint('LocationModel: $model');
      return model;
    }
    return null;
  }

  Future<bool> deleteUserLocation(var id) async {
    ApiResponse apiResponse = await deleteData("items/Location/$id");
    return (apiResponse.success);
  }

  /// endregion Location
  ///
}
