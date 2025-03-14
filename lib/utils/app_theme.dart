import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.cyanM3,
    fontFamily: 'Apple',
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    // )
    //     .copyWith(
    //   textTheme: _customTextTheme(Typography.material2021().black),
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.cyanM3,
    fontFamily: 'Apple',
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    // )
    //     .copyWith(
    //   textTheme: _customTextTheme(Typography.material2021().white),
  );

  // Unified custom text theme for both light and dark modes
  static TextTheme _customTextTheme(TextTheme base) => base.copyWith(
    headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
    headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w500),
    bodyLarge: base.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
    bodyMedium: base.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
    bodySmall: base.bodySmall?.copyWith(fontWeight: FontWeight.w300),
    labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
    labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1.1),
    labelSmall: base.labelSmall?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 1.0),
  );
}
