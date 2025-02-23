import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_edit_text.dart';
import 'package:neuss_utils/widgets/src/super_labeled_check_box.dart';
import 'package:neuss_utils/widgets/src/super_phone_field.dart';
import 'package:neuss_utils/widgets/src/super_radio_group.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../../../../core/routes/app_pages.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/mixins/vars_mixin.dart';
import '../../../models/user_model.dart';

class RegisterPage extends GetView<AppController> {
  RegisterPage({super.key});

  final _phoneNum = ''.obs;

  String get phoneNum => _phoneNum.value;

  set phoneNum(String val) => _phoneNum.value = val;

  final _gender = true.obs;

  bool get gender => _gender.value;

  set gender(bool val) => _gender.value = val;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    phoneNum = controller.phoneNum;
    return SuperScaffold(
      // backgroundColor: AppColors.appBlackBG,
      // gradient: appMainGradient,
      backBtnBgColor: Colors.transparent,
      // showBackBtn: true,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            shrinkWrap: false,
            children: [
              vSpace32,
              Center(
                  child: Txt(
                'Sign Up',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.primaryColor,
              )),
              vSpace32,
              Center(
                child: SuperImageView(
                  imgAssetPath: AppAssets.appIcon,
                  height: Get.height * 0.2,
                  fit: BoxFit.fill,
                ),
              ),
              vSpace32,
              SuperPhoneField(
                controller: phoneController,
                initialDialCode: '+962',
                initialPhone: controller.phoneNum,
                enableDebug: false,
                onPhoneChanged: (phone) {},
                onCountryChanged: (countryCode) {},
                onFullPhoneChanged: (completeNum) {
                  if (completeNum != null) {
                    phoneNum = completeNum;
                    controller.phoneNum = phoneNum;
                  }
                },
              ),
              vSpace16,
              SuperEditText(
                passController,
                hint: AppStrings.passHint,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                prefixIconData: Icons.key_sharp,
                // fillColor: AppColors.authBgColor,
                obscureText: true,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                  FormBuilderValidators.maxLength(50),
                ],
              ),
              vSpace16,
              SuperEditText(
                pass2Controller,
                hint: AppStrings.passConfirmHint,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                prefixIconData: Icons.key_sharp,
                // fillColor: AppColors.authBgColor,
                obscureText: true,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                  FormBuilderValidators.maxLength(50),
                ],
              ),
              vSpace16,
              SuperRadioGroup(
                items: const [true, false],
                itemAsString: (b) => b ? 'Male' : 'Female',
                hint: 'Gender',
                wrapAlignment: WrapAlignment.spaceAround,
                initialValue: gender,
                onChanged: (g) => gender = g,
              ),
              vSpace16,
              Obx(() {
                return SuperLabeledCheckbox(
                  title: 'Save login data',
                  value: controller.saveUserPermanently,
                  onChanged: (s) => controller.saveUserPermanently = s,
                );
              }),
              vSpace32,
              InkWell(
                onTap: submitSignUp,
                child: SuperDecoratedContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: 28,
                  color: AppColors.appMainColor,
                  child: const Center(
                      child: Txt(
                    'Sign up',
                    color: Colors.white,
                    fontSize: 18,
                  )),
                ),
              ),
              vSpace16,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Txt('Already have account', fontSize: 22),
                  TextButton(
                      onPressed: submitLogin,
                      child: Txt(
                        'Log in',
                        fontSize: 22,
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              vSpace96,
              vSpace96,
            ],
          ),
        ),
      ),
    );
  }

  void submitSignUp() {
    controller.continueAsGuest();
    return;
    String password = passController.text.trim();
    String password2 = pass2Controller.text.trim();

    if (password != password2) {
      mShowToast('Passwords must be the same');
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false) ||
        phoneNum.isNullOrEmptyOrWhiteSpace) {
      mPrint('Wrong credentials');
      mShowToast('Wrong credentials');
    } else {
      showConfirmationDialog(
          msg: '${'verify phone'.tr} ${phoneNum.correctPhoneDir} ${'?'.tr}',
          function: () {
            mShowLoading(msg: 'Verifying ...');

            controller.verifyUserPhone(
              UserModel(
                phone: phoneNum,
                password: password,
                gender: gender,
              ),
              AuthStates.signup,
            );
          });
    }
  }

  void submitLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}
