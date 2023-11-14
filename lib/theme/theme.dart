import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Duration containerTransitionDuration = Duration(milliseconds: 500);
const PageTransitionsTheme transitionsThemes =
    PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
  TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
});

final ThemeData appThemeLight = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey.shade100,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.red,
  ),
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: Colors.red.shade100.withOpacity(0.5),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.red.shade50,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final ThemeData appThemeDark = ThemeData(
  useMaterial3: true,
  cardColor: Colors.grey.shade900,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Colors.red,
  ),
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: Colors.red.shade200.withOpacity(0.3),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.red.shade50.withOpacity(0.1),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);
