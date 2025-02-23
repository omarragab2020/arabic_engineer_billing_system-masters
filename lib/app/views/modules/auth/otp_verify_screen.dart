import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../controllers/app_controller.dart';

class OTPVerifyPage extends GetView<AppController> {
  OTPVerifyPage({super.key});

  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SuperScaffold(
        // gradient: appMainGradient,
        showBackBtn: false,
        body: SizedBox(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FormBuilder(
              key: _formKey,
              child: ListView(shrinkWrap: true, children: [
                // Center(
                //   child: SuperImageView(
                //     imgAssetPath: 'assets/images/app_logo.png',
                //     height: Get.width * 0.4,
                //     width: Get.width * 0.7,
                //     fit: BoxFit.fill,
                //   ),
                // ),
                // vSpace32,
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Txt(
                    'Phone Number Verification',
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    fontSize: 22,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: context.height * 0.3,
                  child: const FlareActor(
                    AppAssets.otp,
                    animation: "otp",
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  ),
                ),
                vSpace16,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                        text: "Enter the code sent to ".tr,
                        children: [
                          TextSpan(
                              text: AppController.to.phoneNum.correctPhoneDir,
                              style: const TextStyle(color: Colors.yellow, locale: Locale('en'), fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                        style: const TextStyle(color: Colors.white, fontSize: 15)),
                    textAlign: TextAlign.center,
                  ),
                ),
                // const Txt("Enter the OTP code sent to your number..."),
                vSpace16,
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    backgroundColor: Colors.transparent,
                    useHapticFeedback: true,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: Get.width * 0.153846,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.grey[200],
                      errorBorderColor: Colors.yellow,
                      selectedColor: Colors.white,
                      inactiveColor: Colors.white,
                    ),
                    pastedTextStyle: const TextStyle(color: Colors.black),
                    animationDuration: const Duration(milliseconds: 300),
                    cursorColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 20, height: 1.6, color: Colors.black),
                    // backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    // errorAnimationController: errorController,
                    controller: codeController,
                    onCompleted: (v) {
                      mPrint("Completed");
                      verifyPressed();
                    },
                    onChanged: (value) {
                      // mPrint(value);
                    },
                    beforeTextPaste: (text) {
                      mPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                vSpace16,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(text: "Didn't receive the code".tr, style: const TextStyle(color: Colors.white, fontSize: 15), children: [
                    TextSpan(
                      text: ' ${"RESEND".tr}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                      style: const TextStyle(color: Color(0xFF91D3B3), fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ]),
                ),
                vSpace16,
                // SuperEditText(codeController, hint: AppStrings.otpCodeHint, prefixIconData: Icons.key, onSubmitted: verifyPressed),
                vSpace32,
                Center(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                    )),
                    onPressed: verifyPressed,
                    icon: const Icon(Icons.login),
                    label: Txt(
                      'Verify',
                      color: AppColors.appMainColor,
                    ),
                  ),
                ),
                vSpace16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Txt('Not correct number', color: Colors.white),
                    hSpace8,
                    InkWell(
                      onTap: changeNumPressed,
                      child: Txt(
                        'Change It',
                        color: AppColors.appMainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                vSpace48
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPressed() async {
    mShowLoading(msg: 'Verifying');
    controller.verifyOTP(codeController.text.trim());
  }

  void changeNumPressed() {
    Get.back();
  }
}
