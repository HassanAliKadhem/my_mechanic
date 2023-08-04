import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';
import 'Data/config.dart';
import 'Data/dataModel.dart';
import 'screens/carList.dart';
import 'screens/carAdd.dart';
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

  loadCarList(BuildContext context) {
    DataModel sd = Provider.of<DataModel>(context);
    sd.loadData();
    Config config = Provider.of<Config>(context);
    config.loadConfig();
  }

  Widget _navBar() {
    return NavigationBar(
      onDestinationSelected: (value) {
        setState(() {
          _currentTab = value;
        });
      },
      selectedIndex: _currentTab,
      destinations: homePageTabs
          .map((e) => NavigationDestination(
                tooltip: e.title,
                label: e.title,
                icon: e.icon,
                selectedIcon: e.selectedIcon,
              ))
          .toList(),
    );
    // return BottomNavigationBar(
    //   onTap: (value) {
    //     setState(() {
    //       _currentTab = value;
    //     });
    //   },
    //   currentIndex: _currentTab,
    //   items: homePageTabs.map((e) {
    //     return BottomNavigationBarItem(
    //       icon: e.icon,
    //       activeIcon: e.selectedIcon,
    //       label: e.title,
    //     );
    //   }).toList(),
    // );
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

  Widget _floatingActionButton(BuildContext context, ThemeMode themeMode) {
    Color _color = Colors.grey.shade900;
    ;
    if (themeMode == ThemeMode.light) {
      _color = Colors.white;
    }
    return OpenContainer(
      closedElevation: 5,
      tappable: false,
      closedColor: _color,
      middleColor: _color,
      openColor: _color,
      closedShape: CircleBorder(),
      transitionDuration: containerTransitionDuration,
      // onClosed: (data) => _onGoBack(""),
      openBuilder: (context, action) {
        // return _openAddCar();
        // CarAdd().startAdd(null);
        // Provider.of<DataModel>(context).currentCar = null;
        return CarAddPage(car: null);
      },
      closedBuilder: (context, action) => FloatingActionButton(
        tooltip: 'Add Car',
        onPressed: () {
          action();
        },
        child: Icon(
          Icons.add,
          // color: Colors.white,
        ),
      ),
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
          floatingActionButtonLocation:
              isSmall ? null : FloatingActionButtonLocation.startTop,
          floatingActionButton: _currentTab == 0
              ? _floatingActionButton(context, themeModesMap[config.themeMode]!)
              : null,
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
