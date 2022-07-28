import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

MaterialColor buildMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red;
  final int g = color.green;
  final int b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (int i = 0; i < strengths.length; i++) {
    double strength = strengths[i];
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

ThemeData getApplicationThemeLight() {
  return ThemeData(
    // Main Colors
    primarySwatch: buildMaterialColor(ColorManager.green),
    scaffoldBackgroundColor: ColorManager.white,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: ColorManager.white, statusBarIconBrightness: Brightness.dark),
      backgroundColor: ColorManager.white,
      elevation: AppSize.s0,
      titleTextStyle: TextStyle(color: ColorManager.black, fontSize: AppSize.s22, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: ColorManager.black),
    ),
  );
}