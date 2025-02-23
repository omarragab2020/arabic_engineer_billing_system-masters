import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const Color appBlackBG = Color(0xFF464644);
  static const Color appGreen = Color(0xFF207E6A);
  static const Color appBlue = Color(0xFF1E267A);
  static const Color appBlue2 = Color(0xFF00052D);
  static const Color lightWhite = Color(0xFF8C6E21);
  static const Color surfaceBgColor = Color(0xFFE3EDF7);
  static const Color tertiaryBgColor = Color(0xffD6E3F3);

  static const Color appLightPrimaryColor = Color(0xff21338c);
  static const Color appLightPrimaryColor1 = Color(0xFFFAC303);
  static const Color appLightPrimaryColor2 = Color(0xFFFFDB71);

  static final Color appGrey = Colors.grey[500]!;

  // static const Color appMainColor = appBlue2;
  static Color selectedColor = appMainColor.withOpacity(0.2);

  static Color get appMainColor => Get.theme.primaryColor;
  static Color get appMainTextColor => Get.theme.colorScheme.secondary;
}
