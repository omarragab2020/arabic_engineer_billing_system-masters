import 'dart:async';

import 'package:almuandes_billing_system/app/controllers/mixins/vars_mixin.dart';
import 'package:dart_extensions/dart_extensions.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:ready_extensions/ready_extensions.dart';
import 'package:synchronized/extension.dart';

import '../../../core/repositories/app_api_service.dart';
import '../../../core/repositories/auth_api_service.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/services/location_services.dart';
import '../../../core/services/offline_storage.dart';
import '../../../core/utils/app_enums.dart';
import '../../../core/utils/app_helpers.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/location_model.dart';
import '../../models/user_model.dart';

mixin UsersMixin on VarsMixin {
  Future<void> initUsers() async {
    bool isFirst = allUsersMap.isEmpty;
    List<UserModel>? users = await AppApiService.to.queryAllUsers();
    if (users != null) handleNewUsers(users);
  }

  void handleNewUsers(List<UserModel> users) {
    // mPrint('handleNewUsers (${users.length})');
    bool isFirst = allUsersMap.isEmpty;

    if (users.isNotEmpty) {
      // if (users.length == 1) {
      //   mPrint('handle User (${users.first.toJson()})');
      // }

      // mPrint('handleNewUsers 1');

      // sortUsersByStatus(users);

      // mPrint('initUsers successfullyLoggedIn: $successfullyLoggedIn');
      if (successfullyLoggedIn) {
        UserModel? user = users.firstWhereOrNull((e) => e.isTheSameObjectID(mUser!));
        if (user != null) {
          if (mUser!.approved != user.approved) {
            if (!mUser!.approved && user.approved) {
              if (Get.currentRoute == Routes.NOTACTIAVTED) {
                Get.offAllNamed(Routes.HOME);
              }
            } else if (!user.approved) {
              Get.offAllNamed(Routes.NOTACTIAVTED);
            }
          }
          mUser!.updateFrom(another: user);
          if (saveUserPermanently) {
            OfflineStorage.saveUser(mUser!);
          }
          refreshUser();
        }
        if (isAdmin) {
          allUsersMap.addAll(AppHelpers.listToIDMap<String, UserModel>(users));
        } else {
          allUsersMap.addAll(
            AppHelpers.listToIDMap<String, UserModel>(
              users.where((element) => element.gender == mUser!.gender).toList(),
            ),
          );
        }

        // mPrint('handleNewUsers 2');
        OfflineStorage.saveUsers(allUsersMap.values.toList(), lastUsersUpdateTime, lastUsersInfoUpdateTime);

        refreshUsers();
        refreshUser();
      }
    }
    // mPrint('handleNewUsers Done');
  }

  Future<void> getUserLocation() async {
    Future<void> f() async {
      bool b = await LocationService.to.initAll();
      if (b && mUser!.approved && mUser!.approved) {
        await LocationService.to.getUserLocation();
        LocationModel? loc = await LocationService.to.getFullPlaceDetailsFromLatLng(LocationService.to.userLatLng);

        if (loc != null) {
          if (mUser!.loc_id != null) {
            mPrint('Called updateUserLocation');
            loc = await AppApiService.to.updateUserLocation(mUser!.loc_id!, loc.toMap());
          } else {
            mPrint('Called createUserLocation');
            loc = await AppApiService.to.createUserLocation(loc);
            if (loc != null) {
              updateMyUser({UserModelFields.loc_id: loc.id});
            }
          }
          if (loc != null && saveUserPermanently) {
            OfflineStorage.saveMyDriverLoc(loc);
          }
        } else {
          // OfflineStorage.eraseMyDriverLoc();
        }
      } else {
        mPrintError('Called getUserLocation not ok');
      }
    }

    f();
  }

  Future<void> refreshMyNotifyTimer() async {
    // mPrint('refreshMyNotifyTimer');
    if (!successfullyLoggedIn) return;
    // initNotifications();
    // refreshNotifyTimer?.cancel();
    // refreshNotifyTimer = Timer.periodic(
    //     10.seconds,
    //     (timer) => [
    //           initNotifications(),
    //           // AppController.to.initMySessions(),
    //           // mPrint('refreshMyNotifyTimer call ${timer.tick}')
    //         ]);
  }

  Future<void> refreshMyChatTimer() async {
    // mPrint('refreshMyChatTimer');
    if (!successfullyLoggedIn) return;
    // AppController.to.initMyChats();
    // refreshChatTimer?.cancel();
    // refreshChatTimer = Timer.periodic(
    //     10.seconds,
    //     (timer) => [
    //           AppController.to.initMyChats(),
    //           // mPrint('refreshMyNotifyTimer call ${timer.tick}')
    //         ]);
  }

  Future<void> refreshMyTokenTimer() async {
    // mPrint('refreshMyTokenTimer');
    if (!successfullyLoggedIn) return;
    await UsersMixin.refreshTokenBG();
    refreshTokenTimer?.cancel();
    refreshTokenTimer = Timer.periodic(10.minutes, (timer) => [UsersMixin.refreshTokenBG(), mPrint('refreshMyTokenTimer call ${timer.tick}')]);
  }

  Future<void> initMyFavouriteIDS() async {
    if (successfullyLoggedIn) {
      myFavoritePersonsId = OfflineStorage.getMyFavoritePersonsId() ?? 0;
      List<String>? favouriteIDS;
      mPrint('myFavoritePersonsId = $myFavoritePersonsId');
      if (myFavoritePersonsId == 0) {
        favouriteIDS = await AppApiService.to.queryMyFavouriteIDS();
        if (myFavoritePersonsId == 0) {
          AppApiService.to.createMyFavouriteIDS();
        }
      } else {
        favouriteIDS = await AppApiService.to.getMyFavouriteIDS();
      }
      if (favouriteIDS != null) {
        myFavouriteIDS = [...favouriteIDS];
      }
    }
  }

  Future<void> toggleMyFavouriteIDS(String userID) async {
    if (successfullyLoggedIn && myFavoritePersonsId != 0) {
      myFavouriteIDS.contains(userID) ? myFavouriteIDS.remove(userID) : myFavouriteIDS.add(userID);
      var s = await AppApiService.to.updateMyFavouriteIDS();
      if (s != null) {
        myFavouriteIDS = s;
      }
    }
  }

  // Future<void> initNotifications() async {
  //   List<NotificationModel>? notifications = await AppApiService.to.getMyNotifications(lastNotifyUpdate);
  //   if (!notifications.isEmptyOrNull) {
  //     myNotificationsList.addAllSynced(notifications!);
  //     // mPrint('myNotificationsList len = ${myNotificationsList.length}');
  //     refreshNotifications();
  //   }
  // }

  Future<UserModel?> syncUserOnline(String id) async {
    UserModel? user = await AppApiService.to.getUser(id);
    if (user != null) {
      allUsersMap[id] = user;
      refreshUsers();
    }
    return user;
  }

  Future<bool> syncMyUser() async {
    UserModel? user = await AppApiService.to.getMyUser();
    if (user != null) {
      mPrint('syncMyUser mUser = $mUser');
      mUser = user;
      refreshUser();
      if (saveUserPermanently) {
        OfflineStorage.saveUser(mUser!);
      }
      if (Get.currentRoute == Routes.NOTACTIAVTED && mUser!.approved) {
        Get.offAllNamed(Routes.HOME);
      }

      return true;
    }
    return false;
  }

  Future<bool> updateMyUser(Map<String, dynamic> map) async {
    if (mUser == null) return false;
    try {
      // UserModel? userModel = await DirectusWSManager.to.updateMyUser(map);
      UserModel? userModel = await AuthApiService.to.updateMyUser(map);
      if (userModel != null) {
        mPrint('Updated Successfully');
        mUser!.updateFrom(another: userModel);
        if (saveUserPermanently) {
          OfflineStorage.saveUser(mUser!);
        }
        refreshUser();
        return true;
      } else {
        mPrint('updateMyUser Failed');
        // mShowToast('Failed');
      }
    } on Exception catch (e) {
      mPrintException(e);
    }
    return false;
  }

  Future<void> updateMyFCMToken(String? token) async {
    if (successfullyLoggedIn && mUser?.fcm_token != token) {
      updateMyUser({UserModelFields.fcm_token: token});
    }
  }

  // Future<bool> refreshToken() async {
  //   if (!successfullyLoggedIn) return false;
  //
  //   mPrint('refreshing my Token 1');
  //   authTokensModel = OfflineStorage.getAuthToken();
  //
  //   if (authTokensModel?.refreshToken != null && authTokensModel?.dateTime != null) {
  //     if (DateTime.now().difference(authTokensModel!.dateTime!.toLocal()) < 10.minutes) return true;
  //   }
  //
  //   if (authTokensModel?.refreshToken == null && !OfflineStorage.getMyPassword().isNullOrEmptyOrWhiteSpace) {
  //     // if (!OfflineStorage.getMyPassword().isNullOrEmptyOrWhiteSpace) {
  //     mPrint2('refreshing login');
  //
  //     authTokensModel = (await AuthApiService.to.login(mUser?.email, OfflineStorage.getMyPassword())).$2;
  //   } else if (authTokensModel?.refreshToken != null) {
  //     mPrint2('refreshing refreshToken');
  //     authTokensModel = await AuthApiService.to.refreshToken();
  //   }
  //   mPrint('refreshing my Token 2');
  //   if (saveUserPermanently) {
  //     OfflineStorage.saveAuthToken(authTokensModel);
  //   }
  //   mPrint('authTokensModel = $authTokensModel');
  //   return authTokensModel != null;
  // }

  static bool refreshingToken = false;

  static Future<AuthTokensModel?> refreshTokenBG() async {
    mPrint('refreshing my Token 1');
    if (refreshingToken) {
      mPrint('already refreshing my Token');
      return null;
    }
    refreshingToken = true;
    AuthTokensModel? authTokensModel = OfflineStorage.getAuthToken();

    if (authTokensModel?.refreshToken == null && !OfflineStorage.getMyPassword().isNullOrEmptyOrWhiteSpace) {
      // if (!OfflineStorage.getMyPassword().isNullOrEmptyOrWhiteSpace) {
      // mPrint2('refreshing login');

      authTokensModel = (await AuthApiService.to.login(OfflineStorage.getUser()?.email, OfflineStorage.getMyPassword())).$2;
    } else if (authTokensModel?.refreshToken != null) {
      // mPrint2('refreshing refreshToken');
      authTokensModel = await AuthApiService.to.refreshToken();
    }
    // mPrint('refreshing my Token 2');
    OfflineStorage.saveAuthToken(authTokensModel);

    mPrint('authTokensModel = $authTokensModel');
    refreshingToken = false;
    return authTokensModel;
  }
}
