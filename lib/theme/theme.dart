import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Duration containerTransitionDuration = Duration(milliseconds: 500);

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.red,
  primaryColorDark: Colors.red,
  primaryColorLight: Colors.red,
  primaryColor: Colors.red,
  accentColor: Colors.redAccent[150],
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    elevation: 3,
    brightness: Brightness.dark,
  ),
  cardTheme: CardTheme(
    // color: Colors.grey[50],
    elevation: 1,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 3,
    // backgroundColor: Colors.grey[100],
    labelType: NavigationRailLabelType.all,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 3,
    // backgroundColor: Colors.grey[200],
    // showUnselectedLabels: true,
    // type: BottomNavigationBarType.shifting,
  ),
);

// final ThemeData appThemeDark = ThemeData(
//   primarySwatch: Colors.red,
//   primaryColorDark: Colors.red,
//   primaryColorLight: Colors.red,
//   primaryColor: Colors.red,
//   accentColor: Colors.redAccent[150],
//   brightness: Brightness.dark,
//   accentColorBrightness: Brightness.dark,
//   primaryColorBrightness: Brightness.dark,
//   cardTheme: CardTheme(
//     color: Colors.grey[850],
//   ),
// );

SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
);
