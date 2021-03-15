import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Duration containerTransitionDuration = Duration(milliseconds: 500);

final ThemeData appThemeLight = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    accentColor: Colors.redAccent[200],
    backgroundColor: Colors.white,
    primarySwatch: Colors.red,
    // cardColor: Colors.grey[200],
    errorColor: Colors.redAccent,
  ),
).copyWith(
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.transparent,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 3,
    // backgroundColor: Colors.grey[100],
    labelType: NavigationRailLabelType.all,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 3,
    // backgroundColor: Colors.grey[100],
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    // selectedItemColor: Colors.red,
    // unselectedItemColor: Colors.black54,
  ),
);

final ThemeData appThemeDark = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
    backgroundColor: Colors.grey[900],
    primaryColorDark: Colors.redAccent[100], // TODO: check this later
    primarySwatch: Colors.red,
    // cardColor: Colors.grey[850],
    errorColor: Colors.tealAccent,
  ),
).copyWith(
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.transparent,
  ),
  cardTheme: CardTheme(
    color: Colors.grey[850],
    elevation: 2,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 3,
    labelType: NavigationRailLabelType.all,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 3,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
);
