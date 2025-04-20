import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Duration containerTransitionDuration = Duration(milliseconds: 500);
const PageTransitionsTheme transitionsThemes = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
  },
);

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
    backgroundColor: Colors.red.shade100.withAlpha(128),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
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
    backgroundColor: Colors.red.shade200.withAlpha(80),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.red.shade50.withAlpha(24),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);
