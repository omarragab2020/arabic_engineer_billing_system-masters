import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_image_class.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../core/repositories/app_api_service.dart';
import '../../core/repositories/auth_api_service.dart';
import '../../core/routes/app_pages.dart';
import '../../core/services/offline_storage.dart';
import '../../core/utils/app_constants.dart';
import '../../core/utils/app_enums.dart';
import '../../core/utils/app_helpers.dart';
import '../models/user_model.dart';
import 'app_controller.dart';
import 'mixins/users_mixin.dart';

class UserInfoController extends GetxService {
  static UserInfoController get to => Get.find();

  GlobalKey<FormBuilderState> formKey1 = GlobalKey();
  GlobalKey<FormBuilderState> formKey2 = GlobalKey();

  UserInfoController([UserModel? model]) {
    model ??= (AppController.to.mUser?.copyWith());
    if (model != null) {
      originalData = model.toMap();
      isEdit = true;
      user = model.copyWith();
      userRole = user.role ?? AppConstants.roleStudent;
      nameController.text = user.first_name ?? '';
      // if (user.email?.contains(AppConstants.defaultEmail) == false) {
      //   emailController.text = user.email ?? '';
      // }

      avatarImage.setImgString(AppHelpers.getServerImageUrl(user.avatar));
    } else {
      user.phone = AppController.to.phoneNum;
    }
  }

  ///region Vars

  Map<String, dynamic> originalData = {};

  bool get isDirtyFull => imagesChanged || isDirty;

  bool get isDirty => updatedUserData.hasData;

  bool get imagesChanged => sanadImage.changed || avatarImage.changed;

  Iterable<MapEntry<String, dynamic>> get updatedUserData => (user
      .toMap()
      .entries
      .where((entry) => entry.value != originalData[entry.key]));

  final _isEdit = false.obs;

  bool get isEdit => _isEdit.value;

  set isEdit(bool val) => _isEdit.value = val;

  final Rx<UserModel> _user = (UserModel()).obs;

  UserModel get user => _user.value;

  set user(UserModel val) => {_user.value = val, _user.refresh()};

  final GlobalKey<FormBuilderState> formKeyStudent =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeyTeacher =
      GlobalKey<FormBuilderState>();

  GlobalKey<FormBuilderState> get curFormKey =>
      isTeacher ? formKeyTeacher : formKeyStudent;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // final TextEditingController emailController = TextEditingController();
  final TextEditingController workingPlaceController = TextEditingController();
  final TextEditingController workingYearsController = TextEditingController();
  final TextEditingController workingAppsController = TextEditingController();
  final TextEditingController childrenTeachingController =
      TextEditingController();
  final TextEditingController countryOfResidenceController =
      TextEditingController();
  final TextEditingController countryOfNationalityController =
      TextEditingController();

  final SuperImageClass sanadImage = SuperImageClass();
  final SuperImageClass avatarImage = SuperImageClass();

  final _userRole = AppConstants.roleStudent.obs;

  String get userRole => _userRole.value;

  set userRole(String val) => _userRole.value = val;

  bool get isStudent => userRole == AppConstants.roleStudent;

  bool get isTeacher => userRole == AppConstants.roleTeacher;

  ///endregion

  void refreshUser() {
    _user.refresh();
  }

  Future<bool> submitRegistration() async {
    mShowLoading(msg: 'Registering...');
    UserModel submitUser = user.copyWith(
      phone: AppController.to.phoneNum,
      password: AppController.to.authModel.password,
      role: userRole,
      approved: AppController.to.otpVerified,
    );
    if (user.first_name.isNullOrEmptyOrWhiteSpace) {
      mShowToast('Name is mandatory');
      return false;
    } else if (user.first_name!.length < 5) {
      mShowToast('Name is too short');
      return false;
    }

    // return false;
    UserModel? userModel = await AuthApiService.to.addMyUser(submitUser);
    if (userModel == null) {
      mShowToast('User not created');
      mPrintError('User not created');
      return false;
    }
    mPrint('User Created: *******/n ${userModel.toJson()}    /n*******');

    mShowLoading();
    AppController.to.mUser =
        userModel.copyWith(password: AppController.to.authModel.password);
    OfflineStorage.saveMyPassword(AppController.to.authModel.password!);

    await UsersMixin.refreshTokenBG();

    if (sanadImage.changed || avatarImage.changed) {
      String? sanadID, avatarID;
      if (sanadImage.changed && sanadImage.file != null)
        sanadID =
            await AppApiService.to.uploadImage(sanadImage.file!, type: 'Sanad');
      if (avatarImage.changed && avatarImage.file != null)
        avatarID = await AppApiService.to.uploadImage(avatarImage.file!);

      if (avatarID != null) {
        await AppController.to.updateMyUser({UserModelFields.avatar: avatarID});
      }
      if (sanadID != null) {
        // await AppController.to.updateMyUserInfo({UserInfoModelFields.sanadImageUrl: sanadID});
      }
    }

    bool b = await AppController.to.syncMyUser();
    if (b) {
      await AppController.to.afterOtpPassed('Registered Successfully');
      10.milliseconds.delay(() {
        mHide();
        Get.toNamed(Routes.HOME);
      });
      return true;
    }
    mHide();
    return false;
  }

  Future<bool> submitUpdate(Function() onDone) async {
    if (!isDirtyFull) {
      mShowToastError('No Changes');
      return false;
    }
    if (user.first_name.isNullOrEmptyOrWhiteSpace) {
      mShowToast('Name is mandatory');
      return false;
    } else if (user.first_name!.length < 5) {
      mShowToast('Name is too short');
      return false;
    }

    Map<String, dynamic> userMap =
        Map<String, dynamic>.fromEntries(updatedUserData);
    mShowLoading(msg: 'Updating...');
    mPrintMap({'userMap': userMap});
    if (imagesChanged) {
      String? sanadID, avatarID;
      if (sanadImage.changed && sanadImage.file != null)
        sanadID =
            await AppApiService.to.uploadImage(sanadImage.file!, type: 'Sanad');
      if (avatarImage.changed && avatarImage.file != null)
        avatarID = await AppApiService.to.uploadImage(avatarImage.file!);
      if (avatarID != null) userMap[UserModelFields.avatar] = avatarID;

      // return false;

      bool b1 = true, b2 = true;
      if (userMap.isNotEmpty) {
        b1 = await AppController.to.updateMyUser(userMap);
      }

      if (b1 && b2) {
        user.updateFrom(another: AppController.to.mUser!);
        refreshUser();
        b1 = await AppController.to.syncMyUser();
        user.updateFrom(another: AppController.to.mUser!);
        refreshUser();

        originalData = user.toMap();

        mHide();

        mPrint('Updated Successfully, $originalData');
        mShowToast('Updated Successfully');

        hideKeyboard(Get.context);
        onDone();
      } else {
        mShowToast('Failed updating ${b1 ? '' : '[user data]'}');
      }
    }
    return true;
  }
}
