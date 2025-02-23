import 'dart:async';

import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_extensions/dart_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/utils.dart';

import '../../../core/utils/app_constants.dart';
import '../../models/admin_data_model.dart';
import '../../models/auth_tokens_model.dart';

import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../processing_queue.dart';

mixin VarsMixin on GetxService {
  ///region Vars
  String verificationIDFromFirebase = '';
  FirebaseAuth mAuth = FirebaseAuth.instance;
  String? newPass;
  String? newIdentityImage;

  Timer? syncTeachersTimer;
  Timer? syncUsersTimer;
  Timer? refreshTokenTimer;

  Timer? refreshStatusTimer;
  Timer? refreshNotifyTimer;
  Timer? refreshChatTimer;

  final _homeTabController = Rxn<TabController>();

  TabController? get homeTabController => _homeTabController.value;

  set homeTabController(TabController? val) => _homeTabController.value = val;

  final _selectedBottomBarIndex = 0.obs;

  int get selectedBottomBarIndex => _selectedBottomBarIndex.value;

  set selectedBottomBarIndex(int val) => _selectedBottomBarIndex.value = val;

  // final _statusToggle = true.obs;
  //
  // bool get statusToggle => _statusToggle.value;
  //
  // set statusToggle(bool val) => _statusToggle.value = val;

  final _notifyAll = (!kDebugMode).obs;

  bool get notifyAll => _notifyAll.value;

  set notifyAll(bool val) => _notifyAll.value = val;

  // Future<void> toggleStatusVisibility() async {
  //   if (isTeacher && selectedBottomBarIndex == 2 && mUser!.userInfo != null) {
  //     statusToggle = false;
  //     await GetNumUtils(10).milliseconds.delay();
  //     statusToggle = true;
  //     // await GetNumUtils(1).milliseconds.delay();
  //     // statusToggle = false;
  //     // await GetNumUtils(5).milliseconds.delay();
  //     // statusToggle = true;
  //
  //     // String temp = UserStatus.UnAvailable;
  //     // String? temp2 = mUser?.avStatus;
  //     // await NumDurationExtensions(1).milliseconds.delay(() {
  //     //   mUser?.avStatus = temp;
  //     //   refreshUser();
  //     // });
  //     // await NumDurationExtensions(3).milliseconds.delay(() {
  //     //   mUser?.avStatus = temp2;
  //     //   refreshUser();
  //     // });
  //     // await NumDurationExtensions(6).milliseconds.delay(() {
  //     //   mUser?.avStatus = temp;
  //     //   refreshUser();
  //     // });
  //   }
  // }

  // final RxString _whatsAppNum = AppConstants.defaultWhatsAppNum.obs;
  //
  // String get whatsAppNum => _whatsAppNum.value;
  //
  // set whatsAppNum(String val) => {_whatsAppNum.value = val};
  //
  // final RxString _whatsAppMsg = AppConstants.defaultWhatsAppMsg.obs;
  //
  // String get whatsAppMsg => _whatsAppMsg.value;
  //
  // set whatsAppMsg(String val) => {_whatsAppMsg.value = val};

  final _adminDataModel = AdminDataModel(
          Donation_WA_Message: AppConstants.defaultWhatsAppMsg,
          Donation_WA_Message_ar: AppConstants.defaultWhatsAppMsg,
          Support_WA_Message: AppConstants.defaultWhatsAppMsg,
          Support_WA_Message_ar: AppConstants.defaultWhatsAppMsg,
          Donation_WA_number: AppConstants.defaultWhatsAppNum,
          Support_WA_number: AppConstants.defaultWhatsAppNum)
      .obs;

  AdminDataModel get adminDataModel => _adminDataModel.value;

  set adminDataModel(AdminDataModel val) => _adminDataModel.value = val;
  final RxString _phoneNum = "".obs;

  String get phoneNum => _phoneNum.value;

  set phoneNum(String val) => {_phoneNum.value = val};

  AuthStates authState = AuthStates.login;
  AuthTokensModel? authTokensModel;
  final Rxn<UserModel> _mUser = Rxn<UserModel>();

  UserModel? get mUser => _mUser.value;

  set mUser(UserModel? val) => {_mUser.value = val, _mUser.refresh()};

  String? get mUserID => mUser?.id;

  void refreshUser() {
    _mUser.refresh();
  }

  final _savePermanently = true.obs;

  bool get saveUserPermanently => _savePermanently.value;

  set saveUserPermanently(bool val) => _savePermanently.value = val;

  // final _allTeachersMap = <String, UserModel>{}.obs;
  //
  // Map<String, UserModel> get allTeachersMap => _allTeachersMap;
  //
  // set allTeachersMap(Map<String, UserModel> val) => _allTeachersMap.value = val;

  final _allUsersMap = <String, UserModel>{}.obs;

  Map<String, UserModel> get allUsersMap => _allUsersMap;

  set allUsersMap(Map<String, UserModel> val) => _allUsersMap.value = val;

  final _myNotificationsList = <NotificationModel>[].obs;

  List<NotificationModel> get myNotificationsList => _myNotificationsList;

  set myNotificationsList(List<NotificationModel> val) => [_myNotificationsList.value = val, _myNotificationsList.refresh()];

  void refreshNotifications() => _myNotificationsList.refresh();

  void refreshUsers() => [_allUsersMap.refresh()];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? fireCallsStream;

  final _myFavouriteIDS = <String>[].obs;

  List<String> get myFavouriteIDS => _myFavouriteIDS;

  set myFavouriteIDS(List<String> val) => _myFavouriteIDS.value = val;

  final _myFavoritePersonsId = 0.obs;

  int get myFavoritePersonsId => _myFavoritePersonsId.value;

  set myFavoritePersonsId(int val) => _myFavoritePersonsId.value = val;

  final _isGuest = false.obs;

  bool get isGuest => _isGuest.value;

  set isGuest(bool val) => _isGuest.value = val;

  final RxBool _isConnected = false.obs;

  bool get isConnected => _isConnected.value;

  set isConnected(bool x) => _isConnected.value = x;

  final _isRealConnected = true.obs;

  bool get isRealConnected => _isRealConnected.value;

  set isRealConnected(bool val) => _isRealConnected.value = val;

  bool get isFullyConnected => isConnected && isRealConnected;

  bool get isAdmin => successfullyLoggedIn && mUser!.isAdmin;

  bool get isTeacher => successfullyLoggedIn && mUser!.isTeacher;

  bool get isStudent => successfullyLoggedIn && mUser!.isStudent;

  bool get successfullyLoggedInFirebase => mAuth.currentUser != null;

  bool get successfullyLoggedIn => !mUserID.isNullOrWhiteSpace;

  // bool get successfullyLoggedIn => successfullyLoggedInFirebase && mUserID != null;

  String? deviceID;

  final _selectedTeachersTabIndex = 0.obs;

  int get selectedTeachersTabIndex => _selectedTeachersTabIndex.value;

  set selectedTeachersTabIndex(int val) => _selectedTeachersTabIndex.value = val;

  final _appVersion = ''.obs;

  String get appVersion => _appVersion.value;

  set appVersion(String val) => _appVersion.value = val;

  DateTime lastNotifyUpdate = DateTime(2000);
  DateTime lastChatUpdate = DateTime(2000);
  DateTime lastMessagesUpdate = DateTime(2000);
  DateTime lastTeacherUpdateTime = DateTime(2000);
  DateTime lastUsersUpdateTime = DateTime(2000);
  DateTime lastUsersInfoUpdateTime = DateTime(2000);
  DateTime lastSessionsUpdateTime = DateTime.now().firstDayOfMonth.toUtc();
  DateTime lastAllSessionsUpdateTime = DateTime.now().firstDayOfMonth.toUtc();

  static final DateTime now = DateTime.now();

  // final _filterMasar = Rxn<String>('All');
  //
  // String? get filterMasar => _filterMasar.value;
  //
  // set filterMasar(String? val) => _filterMasar.value = val;

  final _isInvitationShown = false.obs;

  bool get isInvitationShown => _isInvitationShown.value;

  set isInvitationShown(bool val) => _isInvitationShown.value = val;

  final _meetingInviteAccepted = false.obs;

  bool get meetingInviteAccepted => _meetingInviteAccepted.value;

  set meetingInviteAccepted(bool val) => _meetingInviteAccepted.value = val;

  final _inMeeting = false.obs;

  bool get inMeeting => _inMeeting.value;

  set inMeeting(bool val) => _inMeeting.value = val;

  final _isAudioPlaying = false.obs;

  bool get isAudioPlaying => _isAudioPlaying.value;

  set isAudioPlaying(bool val) => _isAudioPlaying.value = val;

  final _firstLoadOk = Rxn<bool>();

  bool? get firstLoadOk => _firstLoadOk.value;

  set firstLoadOk(bool? val) => _firstLoadOk.value = val;

  final _firstLoading = false.obs;

  bool get firstLoading => _firstLoading.value;

  set firstLoading(bool val) => _firstLoading.value = val;

  ShakeDetector? detector;

  final _adminSelectGender = Rxn<bool>();

  bool? get adminSelectGender => _adminSelectGender.value;

  set adminSelectGender(bool? val) => _adminSelectGender.value = val;

  final _adminSelectSort = 1.obs;

  int get adminSelectSort => _adminSelectSort.value;

  set adminSelectSort(int val) => _adminSelectSort.value = val;

  final _adminSelectAsc = true.obs;

  bool get adminSelectAsc => _adminSelectAsc.value;

  set adminSelectAsc(bool val) => _adminSelectAsc.value = val;

  final GlobalKey<FormBuilderFieldState> statusDropdownState = GlobalKey<FormBuilderFieldState>();
  final GlobalKey<FormBuilderFieldState> statusDropdownStateDialog = GlobalKey<FormBuilderFieldState>();

  ///endregion Vars
}

enum AuthStates {
  login,
  signup,
  otpVerify,
  forgotPass,
  profile,
  loggedIn,
}
