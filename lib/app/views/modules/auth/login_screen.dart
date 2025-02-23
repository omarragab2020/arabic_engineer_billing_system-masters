import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/image_utils/src/super_imageview.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/country_model.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_edit_text.dart';
import 'package:neuss_utils/widgets/src/super_labeled_check_box.dart';
import 'package:neuss_utils/widgets/src/super_phone_field.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:ready_extensions/ready_extensions.dart';

import '../../../../../core/routes/app_pages.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/mixins/vars_mixin.dart';
import '../../../models/user_model.dart';

class LoginPage extends GetView<AppController> {
  LoginPage({super.key});

  final _phoneNum = ''.obs;
  String get phoneNum => _phoneNum.value;
  set phoneNum(String val) => _phoneNum.value = val;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
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
                'Login',
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
                  // shape: BoxShape.circle,
                ),
              ),
              vSpace48,
              vSpace32,
              SuperPhoneField(
                controller: phoneController,
                enableDebug: false,
                useSimIfAvailable: true,
                initialPhone: controller.phoneNum,
                initialDialCode: '+962',
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: submitForgotPassword,
                        child: Txt(
                          'Forgot password',
                          fontSize: 16,
                          color: Get.theme.primaryColor,
                        )),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SuperLabeledCheckbox(
                        title: 'Save login data',
                        value: controller.saveUserPermanently,
                        onChanged: (s) => controller.saveUserPermanently = s,
                      );
                    }),
                  ),
                ],
              ),
              vSpace32,
              InkWell(
                onTap: submitLogin,
                child: SuperDecoratedContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: 28,
                  color: AppColors.appMainColor,
                  child: const Center(
                      child: Txt(
                    'Login',
                    color: Colors.white,
                    fontSize: 18,
                  )),
                ),
              ),
              vSpace16,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Txt("Don't have account", fontSize: 20),
                  hSpace4,
                  TextButton(
                      onPressed: submitSignUp,
                      child: Txt(
                        'Sign up',
                        fontSize: 20,
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              vSpace96,
            ],
          ),
        ),
      ),
    );
  }

  void submitSignUp() {
    Get.offNamed(Routes.SIGNUP);
  }

  void submitLogin() {
    controller.continueAsGuest();
    return;
    String password = passController.text.trim();

    if (!(_formKey.currentState?.validate() ?? false) || phoneNum.isNullOrEmptyOrWhiteSpace) {
      mPrint('Wrong credentials');
      // mShowToast('Wrong credentials');
    } else {
      showConfirmationDialog(
          msg: '${'verify phone'.tr} ${phoneNum.correctPhoneDir} ${'?'.tr}',
          function: () {
            mShowLoading(msg: 'Verifying ...');

            controller.verifyUserPhone(
              UserModel(
                phone: phoneNum,
                password: password,
              ),
              AuthStates.login,
            );
          });
    }
  }

  void submitForgotPassword() {
    mShowToast('Not enabled now');
    return;
    CountryModel? country = getCountryFromPhoneNum(phoneNum);
    if (country != null) {
      if (phoneNum.length > country.dialCode.length + 1 + country.minLength || phoneNum.length < country.dialCode.length + 1 + country.maxLength) {
        mShowToast('Wrong phone number');
        return;
      }
    } else {
      mShowToast('Wrong phone number');
      return;
    }
    controller.verifyUserPhone(
      UserModel(phone: phoneNum),
      AuthStates.forgotPass,
    );
  }
}
