import 'package:flutter/material.dart';
import 'package:fun_math/core/theme/widgets/text_theme.dart';

import '../constant/colors_constant.dart';

class AppTheme{

  // get the light theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: ColorsConstant.primaryLight,
      colorScheme: ColorScheme.light(
        primary: ColorsConstant.primaryLight,
        secondary: ColorsConstant.secondaryLight,
        surface: ColorsConstant.surfaceLight,
        error: ColorsConstant.errorLight,
        onPrimary: ColorsConstant.onPrimaryLight,
        onSecondary: ColorsConstant.onSecondaryLight,
        onSurface: ColorsConstant.onSurfaceLight,
      ),
      scaffoldBackgroundColor: ColorsConstant.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsConstant.primaryLight,
        iconTheme: IconThemeData(color: ColorsConstant.onPrimaryLight),
      ),
      textTheme: AppTextTheme.getTextTheme(ColorsConstant.onSurfaceLight),
    );
  }

  // get the dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: ColorsConstant.primaryDark,
      colorScheme: ColorScheme.dark(
        primary: ColorsConstant.primaryDark,
        secondary: ColorsConstant.secondaryDark,
        surface: ColorsConstant.surfaceDark,
        error: ColorsConstant.errorDark,
        onPrimary: ColorsConstant.onPrimaryDark,
        onSecondary: ColorsConstant.onSecondaryDark,
        onSurface: ColorsConstant.onSurfaceDark,
      ),
      scaffoldBackgroundColor: ColorsConstant.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsConstant.backgroundDark,
        iconTheme: IconThemeData(color: ColorsConstant.onPrimaryDark),
      ),
      textTheme: AppTextTheme.getTextTheme(ColorsConstant.onSurfaceDark),
    );
  }
}