import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.blumineBlue,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    typography: Typography.material2021(platform: defaultTargetPlatform),
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      textButtonRadius: 22.0,
      filledButtonRadius: 20.0,
      outlinedButtonRadius: 21.0,
      outlinedButtonBorderWidth: 2.0,
      outlinedButtonPressedBorderWidth: 3.5,
      toggleButtonsRadius: 32.0,
      toggleButtonsBorderWidth: 1.5,
      checkboxSchemeColor: SchemeColor.onPrimaryContainer,
      cardRadius: 40.0,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true,
      keepSecondary: true,
      keepTertiary: true,
      keepPrimaryContainer: true,
      keepSecondaryContainer: true,
      keepTertiaryContainer: true,
    ),
    tones: FlexTones.material(Brightness.light).onMainsUseBW(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
// To use the Playground font, add GoogleFonts package and uncomment
// fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blumineBlue,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    typography: Typography.material2021(platform: defaultTargetPlatform),
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      textButtonRadius: 22.0,
      filledButtonRadius: 20.0,
      outlinedButtonRadius: 21.0,
      outlinedButtonBorderWidth: 2.0,
      outlinedButtonPressedBorderWidth: 3.5,
      toggleButtonsRadius: 32.0,
      toggleButtonsBorderWidth: 1.5,
      checkboxSchemeColor: SchemeColor.onPrimaryContainer,
      cardRadius: 40.0,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
// To use the Playground font, add GoogleFonts package and uncomment
// fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}
