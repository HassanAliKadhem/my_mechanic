import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';
import 'Data/config.dart';
import 'Data/dataModel.dart';
import 'screens/carList.dart';
import 'screens/upcomingList.dart';
import 'screens/settings.dart';
import 'widgets/verticalDivider.dart';
import 'widgets/snackBar.dart';
import 'widgets/homePageTab.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DataModel>(create: (context) => DataModel()),
          ChangeNotifierProvider<Config>(create: (context) => Config())
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentTab = 0;
  final List<HomePageTab> homePageTabs = <HomePageTab>[
    HomePageTab(
      "Cars",
      Icon(Icons.directions_car_outlined),
      Icon(Icons.directions_car),
      CarsList(),
    ),
    HomePageTab(
      "Upcoming",
      Icon(Icons.calendar_today_outlined),
      Icon(Icons.calendar_today),
      UpcomingList(),
    ),
    HomePageTab(
      "Settings",
      Icon(Icons.settings_outlined),
      Icon(Icons.settings),
      SettingsPage(),
    ),
  ];

  void loadCarList(BuildContext context) {
    DataModel sd = Provider.of<DataModel>(context);
    sd.loadData();
    Config config = Provider.of<Config>(context);
    config.loadConfig();
  }

  double navButtonSize = 58;
  Widget _navBar() {
    double sideMargin = (MediaQuery.sizeOf(context).width -
            (navButtonSize * homePageTabs.length)) /
        2;
    return Container(
      clipBehavior: Clip.hardEdge,
      margin:
          EdgeInsets.only(bottom: 28.0, left: sideMargin, right: sideMargin),
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(100),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: homePageTabs
              .map((e) => AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: homePageTabs.indexOf(e) != _currentTab
                          ? null
                          : Colors.red.shade100.withOpacity(0.5),
                    ),
                    child: FloatingActionButton(
                      shape: CircleBorder(),
                      backgroundColor: Colors.transparent,
                      heroTag: null,
                      elevation: 0,
                      disabledElevation: 0,
                      highlightElevation: 0,
                      focusElevation: 0,
                      hoverElevation: 0,
                      tooltip: e.title,
                      child: homePageTabs.indexOf(e) != _currentTab
                          ? e.icon
                          : e.selectedIcon,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          _currentTab = homePageTabs.indexOf(e);
                        });
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _navRail() {
    return NavigationRail(
      leading: SizedBox(
        height: kToolbarHeight,
      ),
      onDestinationSelected: (value) {
        setState(() {
          _currentTab = value;
        });
      },
      labelType: NavigationRailLabelType.all,
      selectedIndex: _currentTab,
      destinations: homePageTabs.map((e) {
        return NavigationRailDestination(
          icon: e.icon,
          selectedIcon: e.selectedIcon,
          label: Text(e.title),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadCarList(context);
    bool isSmall = MediaQuery.sizeOf(context).shortestSide < 600;
    return Consumer<Config>(builder: (context, config, child) {
      return MaterialApp(
        title: 'My Mechanic',
        theme: appThemeLight,
        darkTheme: appThemeDark,
        themeMode: themeModesMap[config.themeMode],
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: Scaffold(
          extendBody: true,
          bottomNavigationBar: isSmall ? _navBar() : null,
          body: isSmall
              ? MyPageAnimation(child: homePageTabs[_currentTab].pageElements)
              : Row(
                  children: [
                    _navRail(),
                    myVerticalDivider,
                    Expanded(
                      child: MyPageAnimation(
                        child: homePageTabs[_currentTab].pageElements,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
