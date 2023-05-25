import 'package:flutter/cupertino.dart';
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

final ThemeData appThemeLight = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    accentColor: Colors.redAccent,
    backgroundColor: Colors.white,
    primarySwatch: Colors.red,
    cardColor: Colors.grey[100],
    errorColor: Colors.redAccent,
  ),
).copyWith(
  selectedRowColor: Colors.red.withOpacity(0.15),
  pageTransitionsTheme: transitionsThemes,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.transparent,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 2,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 3,
    backgroundColor: Colors.grey[100],
    labelType: NavigationRailLabelType.all,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 3,
    backgroundColor: Colors.grey[100],
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

final ThemeData appThemeDark = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    accentColor: Colors.red[300],
    backgroundColor: Colors.grey[900],
    // primaryColorDark: Colors.red[300],
    primarySwatch: Colors.red,
    cardColor: Colors.white.withOpacity(0.01),
    errorColor: Colors.tealAccent,
  ),
).copyWith(
  selectedRowColor: Colors.red.withOpacity(0.07),
  pageTransitionsTheme: transitionsThemes,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.transparent,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 2,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 3,
    backgroundColor: Colors.grey[850],
    labelType: NavigationRailLabelType.all,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 3,
    backgroundColor: Colors.grey[850],
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  // statusBarColor: Colors.transparent,
  // systemNavigationBarColor: Colors.transparent,
  // systemNavigationBarDividerColor: Colors.transparent,
);
