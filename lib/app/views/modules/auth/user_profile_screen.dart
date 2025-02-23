import 'package:almuandes_billing_system/app/views/modules/home/screens/base_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_image_class.dart';
import 'package:neuss_utils/image_utils/src/super_image_pick_view.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/app_button.dart';
import 'package:neuss_utils/widgets/src/super_d_m_y_picker.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_edit_text.dart';
import 'package:neuss_utils/widgets/src/super_phone_field.dart';
import 'package:neuss_utils/widgets/src/super_radio_group.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_helpers.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/user_info_controller.dart';
import '../../../models/user_model.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({this.user, this.viewOnly = false, super.key});

  final UserModel? user;
  final bool viewOnly;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final UserInfoController userInfoController =
      UserInfoController(widget.user);

  bool viewOnly = false;
  AppController controller = AppController.to;

  String getUserPhone() {
    String? s = userInfoController.user.phone ?? controller.phoneNum;
    if (!s.isNullOrEmptyOrWhiteSpace) {
      s = '+${s.replaceAll('+', '')}';
    }
    return s;
  }

  SuperImageClass avatarImageClass = SuperImageClass();

  @override
  void initState() {
    viewOnly = widget.viewOnly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.create<UserInfoController>(() => userInfoController, permanent: false);

    return BaseMainScreen(
      // backgroundColor: AppColors.appBlackBG,
      // gradient: appMainGradient,
      title: 'Personal details',
      child: Padding(padding: const EdgeInsets.all(24.0), child: userView()),
    );
  }

  Widget userView() {
    return FormBuilder(
      key: userInfoController.formKey1,
      child: ListView(
        // shrinkWrap: true,
        children: [
          if (viewOnly && controller.successfullyLoggedIn)
            AppButton(
              txt: 'Edit',
              fillColor: AppColors.appMainColor,
              txtColor: Colors.white,
              borderRadius: 32,
              onPressed: submitProfile,
            ),
          vSpace32,
          SuperImagePickView(
            avatarImageClass,
            pickLabelTxt: 'Avatar',
            shape: BoxShape.circle,
            width: 0.3.w,
          ),
          vSpace32,
          SuperPhoneField(
            controller: TextEditingController(
              text: (userInfoController.user.phone ?? controller.phoneNum)
                  .correctPhoneDir,
            ),
            initialDialCode: '+962',
            initialPhone: getUserPhone(),
            enableDebug: false,
            enabled: false,
          ),
          vSpace16,
          SuperEditText(
            userInfoController.nameController,
            enabled: !viewOnly,
            hint: 'Full name',
            onChanged: (s) {
              userInfoController.user.first_name = s;
            },
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(2),
              FormBuilderValidators.maxLength(100),
            ],
          ),
          vSpace16,
          SuperEditText(
            userInfoController.emailController,
            enabled: !viewOnly && !controller.successfullyLoggedIn,
            hint: AppStrings.emailHint,
            prefixIconData: Icons.email,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            onChanged: (s) {
              userInfoController.user.email = s;
            },
            // fillColor: AppColors.authBgColor,
            validators: [
              FormBuilderValidators.email(),
            ],
          ),
          vSpace16,
          SuperDMYPicker(
            label: 'Date of Birth',
            enabled: !viewOnly,
            validators: [FormBuilderValidators.required()],
            initialDateTime: userInfoController.user.dob?.copyWith(),
            onChangedDateTime: (DateTime? d) =>
                userInfoController.user.dob = d?.copyWith(),
          ),
          vSpace8,
          SuperRadioGroup(
              items: const [true, false],
              itemAsString: (b) => b ? 'Male' : 'Female',
              enabled: !viewOnly && !controller.successfullyLoggedIn,
              hint: 'Gender',
              wrapAlignment: WrapAlignment.spaceAround,
              initialValue: userInfoController.user.gender,
              onChanged: (g) {
                userInfoController.user.gender = g;
              }),
          vSpace48,
          if (!viewOnly)
            AppButton(
              txt: 'Submit',
              fillColor: AppColors.appMainColor,
              txtColor: Colors.white,
              borderRadius: 32,
              onPressed: submitProfile,
            ),
          // AppHelpers.appDivider(60),
          // if (controller.successfullyLoggedIn)
          //   AppButton(
          //     txt: 'Delete my account!',
          //     fillColor: viewOnly ? Colors.grey : Colors.red,
          //     txtColor: Colors.white,
          //     onPressed: viewOnly ? () {} : deleteProfile,
          //   ),
          vSpace96,
        ],
      ),
    );
  }

  GlobalKey<FormBuilderState> get curFormKey => userInfoController.formKey1;

  void submitProfile() {
    mShowToastError('To be done', displayTime: 1.seconds);
    return;
    if (viewOnly) {
      Get.to(() => UserProfilePage(user: controller.mUser),
          preventDuplicates: false);
      return;
    }
    if (!(curFormKey.currentState?.validate() ?? false)) {
      mPrint('Wrong credentials');
      mShowToast('Please fill all fields!');
    } else {
      mPrint('Logged in: ${controller.successfullyLoggedIn}');
      // return;
      showConfirmationDialog(function: () async {
        if (controller.successfullyLoggedIn) {
          await userInfoController.submitUpdate(() {});
        } else {
          await userInfoController.submitRegistration();
        }
        mHide();
      });
    }
  }

  Future<void> deleteProfile() async {
    showConfirmationDialog(
        msg: 'delete your account',
        function: () {
          mShowLoading(msg: 'Deleting your account...');
          controller.deleteMyAccount();
          mHide();
        });
  }
}
