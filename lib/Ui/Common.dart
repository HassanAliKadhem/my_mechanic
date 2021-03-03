import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget header(String title) {
  return PhysicalModel(
    color: Colors.black,
    elevation: appTheme.cardTheme.elevation,
    child:
    ListTile(
      tileColor: Colors.white,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: appTheme.textTheme.bodyText2),
      // subtitle: Divider(),
    ),
  );
}

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.red,
  accentColor: Colors.redAccent[150],
  // platform: TargetPlatform.iOS,
  appBarTheme: AppBarTheme(
    elevation: 3,
    brightness: Brightness.dark
  ),
  cardTheme: CardTheme(
    color: Colors.grey[50],
    elevation: 1,
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

SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
);

class HomePageTab {
  String title;
  AdaptiveScaffoldDestination adaptiveScaffoldDestination;
  Widget pageElements;

  HomePageTab(this.title, this.adaptiveScaffoldDestination, this.pageElements);
}