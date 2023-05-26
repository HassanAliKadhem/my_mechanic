import 'package:flutter/material.dart';

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
  primarySwatch: Colors.red,
  colorScheme:
      ColorScheme.fromSeed(brightness: Brightness.light, seedColor: Colors.red),
  appBarTheme: AppBarTheme(scrolledUnderElevation: 0, elevation: 0, backgroundColor: Colors.transparent.withAlpha(125)),
  scaffoldBackgroundColor: Colors.grey.shade100,
);

// ThemeData.from(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSwatch(
//     brightness: Brightness.light,
//     // accentColor: Colors.redAccent,
//     // backgroundColor: Colors.grey.shade200,
//     primarySwatch: Colors.red,
//     // cardColor: Colors.grey[100],
//     // errorColor: Colors.redAccent,
//   ),
// ).copyWith(
//   pageTransitionsTheme: transitionsThemes,
//   dividerColor: Colors.grey.shade700,
//   appBarTheme: AppBarTheme(
//     elevation: 0,
//     // backgroundColor: Colors.white.withAlpha(125),
//     // iconTheme: IconThemeData(
//     //   color: Colors.grey.shade800,
//     // ),
//     // toolbarTextStyle: TextTheme(
//     //   titleLarge: TextStyle(
//     //     color: Colors.grey.shade800,
//     //     fontWeight: FontWeight.bold
//     //   ),
//     // ).bodyMedium,
//     // titleTextStyle: TextTheme(
//     //   titleLarge: TextStyle(
//     //     color: Colors.grey.shade800,
//     //     fontWeight: FontWeight.bold
//     //   ),
//     // ).titleLarge,
//   ),
//   cardTheme: CardTheme(
//     elevation: 2,
//   ),
//   navigationRailTheme: NavigationRailThemeData(
//     elevation: 3,
//     // backgroundColor: Colors.grey.shade200,
//     labelType: NavigationRailLabelType.all,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     elevation: 3,
//     // backgroundColor: Colors.grey.shade200,
//     showUnselectedLabels: true,
//     type: BottomNavigationBarType.fixed,
//   ),
// );

final ThemeData appThemeDark = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.red,
  colorScheme:
      ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.red),
  appBarTheme: AppBarTheme(scrolledUnderElevation: 0, elevation: 0, backgroundColor: Colors.transparent.withAlpha(160)),
  // scaffoldBackgroundColor: Colors.grey.shade900,
  cardColor: Colors.grey.shade800,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 3,
    backgroundColor: Colors.grey.shade800,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 3,
    backgroundColor: Colors.grey.shade800,
  ),
);

// ThemeData.from(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSwatch(
//     brightness: Brightness.dark,
//     // accentColor: Colors.red.shade300,
//     // backgroundColor: Colors.grey.shade900,
//     // primaryColorDark: Colors.red[300],
//     primarySwatch: Colors.red,
//     // cardColor: Colors.white.withOpacity(0.01),
//     // errorColor: Colors.tealAccent,
//   ),
// ).copyWith(
//   pageTransitionsTheme: transitionsThemes,
//   dividerColor: Colors.grey,
//   appBarTheme: AppBarTheme(
//     elevation: 0,
//     // backgroundColor: Colors.grey.shade900.withAlpha(160),
//     // iconTheme: IconThemeData(
//     //   color: Colors.white,
//     // ),
//     // toolbarTextStyle: TextTheme(
//     //   titleLarge: TextStyle(
//     //     color: Colors.grey.shade200,
//     //     fontWeight: FontWeight.bold,
//     //   ),
//     // ).bodyMedium,
//     // titleTextStyle: TextTheme(
//     //   titleLarge: TextStyle(
//     //     color: Colors.grey.shade200,
//     //     fontWeight: FontWeight.bold,
//     //   ),
//     // ).titleLarge,
//   ),
//   cardTheme: CardTheme(
//     elevation: 2,
//   ),
//   navigationRailTheme: NavigationRailThemeData(
//     elevation: 3,
//     // backgroundColor: Colors.grey.shade800,
//     labelType: NavigationRailLabelType.all,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     elevation: 3,
//     // backgroundColor: Colors.grey.shade800,
//     showUnselectedLabels: true,
//     type: BottomNavigationBarType.fixed,
//   ),
// );
