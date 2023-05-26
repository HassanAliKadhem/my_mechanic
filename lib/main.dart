import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';
import 'Data/config.dart';
import 'Data/dataModel.dart';
import 'screens/cars.dart';
import 'screens/carAdd.dart';
import 'screens/upcoming.dart';
import 'screens/settings.dart';
import 'widgets/myLayoutBuilder.dart';
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
  final String title = "MyMechanic";

  

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

  loadCarList() async {
    DataModel sd = Provider.of<DataModel>(context);
    sd.loadData();
    Config config = Provider.of<Config>(context);
    config.loadConfig();
  }

  Widget _navBar() {
    return BottomNavigationBar(
      onTap: (value) {
        setState(() {
          _currentTab = value;
        });
      },
      currentIndex: _currentTab,
      items: homePageTabs.map((e) {
        return BottomNavigationBarItem(
          icon: e.icon,
          activeIcon: e.selectedIcon,
          label: e.title,
        );
      }).toList(),
    );
  }

  Widget _navRail() {
    return NavigationRail(
      extended: false,
      leading: SizedBox(
        height: kToolbarHeight,
      ),
      onDestinationSelected: (value) {
        setState(() {
          _currentTab = value;
        });
      },
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

  Widget _floatingActionButton(BuildContext context) {
    return OpenContainer(
      closedElevation: 5,
      tappable: false,
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      middleColor: Theme.of(context).scaffoldBackgroundColor,
      closedShape: CircleBorder(),
      transitionDuration: containerTransitionDuration,
      // onClosed: (data) => _onGoBack(""),
      openBuilder: (context, action) {
        // return _openAddCar();
        // CarAdd().startAdd(null);
        Provider.of<DataModel>(context).currentCar = null;
        return CarAddPage();
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
    loadCarList();
    // if (MediaQuery.of(context).orientation == Orientation.portrait) {
    //   screenWidth = MediaQuery.of(context).size.width;
    // } else {
    //   screenWidth = MediaQuery.of(context).size.height;
    // }
    // double screenWidth = MediaQuery.of(context).size.shortestSide;
    // int screenIncrements = (screenWidth / 600).ceil().clamp(1, 3);
    // print(screenWidth);
    // SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    // Widget _navRailDivider() {
    //   return VerticalDivider(
    //     width: 1,
    //     thickness: 2,
    //     // color: Colors.transparent,
    //   );
    // }
    //
    // Widget _getAnimatedPage(int pageNum) {
    //   Widget _child = homePageTabs[pageNum].pageElements;
    //   return PageTransitionSwitcher(
    //     transitionBuilder: (
    //       Widget _child,
    //       Animation<double> animation,
    //       Animation<double> secondaryAnimation,
    //     ) {
    //       return FadeThroughTransition(
    //         animation: animation,
    //         secondaryAnimation: secondaryAnimation,
    //         child: _child,
    //       );
    //     },
    //     child: _child,
    //   );
    // }

    return Consumer<Config>(builder: (context, config, child) {
      return MaterialApp(
        title: 'MyMechanic',
        theme: appThemeLight,
        darkTheme: appThemeDark,
        themeMode: themeModesMap[config.themeMode],
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: MyLayoutBuilder(
          mobileLayout: Scaffold(
            extendBody: true,
            body:
                MyPageAnimation(child: homePageTabs[_currentTab].pageElements),
            // body: _getAnimatedPage(_currentTab),
            bottomNavigationBar: _navBar(),
            floatingActionButton:
                (_currentTab != 0) ? null : _floatingActionButton(context),
          ),
          tabletLayout: Scaffold(
            extendBody: true,
            body: Row(
              children: [
                _navRail(),
                myVerticalDivider,
                Expanded(
                    child: MyPageAnimation(
                        child: homePageTabs[_currentTab].pageElements)),
                // Expanded(child: _getAnimatedPage(_currentTab)),
              ],
            ),
            floatingActionButton:
                (_currentTab != 0) ? null : _floatingActionButton(context),
          ),
        ),
      );
    });
  }
}
