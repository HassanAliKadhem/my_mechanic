import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:my_mechanic/screens/carService.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';
import 'Data/dataModel.dart';
import 'screens/cars.dart';
import 'screens/upcoming.dart';
import 'screens/settings.dart';
import 'screens/carAdd.dart';
import 'widgets/snackBar.dart';
import 'widgets/homePageTab.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => DataModel(),
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'MyMechanic',
          theme: appThemeLight,
          darkTheme: appThemeDark,
          themeMode: ThemeMode.system,
          home: MyApp(),
        ),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DataModel sd;
  double screenWidth;
  int screenIncrements;
  int _currentTab = 0;
  final String title = "MyMechanic";

  // void _onGoBack(dynamic value) {
  // loadCarList();
  // setState(() {});
  // }

  loadCarList() async {
    // sd = new DataModel();
    sd = Provider.of<DataModel>(context);
    sd.loadData();
  }

  @override
  Widget build(BuildContext context) {
    // if (MediaQuery.of(context).orientation == Orientation.portrait) {
    //   screenWidth = MediaQuery.of(context).size.width;
    // } else {
    //   screenWidth = MediaQuery.of(context).size.height;
    // }
    screenWidth = MediaQuery.of(context).size.shortestSide;
    screenIncrements = (screenWidth / 600).ceil().clamp(1, 3);
    // print(screenWidth);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    // SystemChrome.setEnabledSystemUIOverlays([]);

    final List<HomePageTab> homePageTabs = <HomePageTab>[
      HomePageTab(
        "Cars",
        Icon(Icons.directions_car),
        CarsList(useMobile: true),
        CarsTabletView(),
      ),
      // HomePageTab(
      //   "Search",
      //   Icon(Icons.search),
      //   SearchPhoneView(useMobile: false),
      //   SearchTabletView(),
      // ),
      HomePageTab(
        "Upcoming",
        Icon(Icons.calendar_today),
        UpcomingPhoneView(),
        UpcomingTabletView(),
      ),
      HomePageTab(
        "Settings",
        Icon(Icons.settings),
        SettingsPhoneView(),
        SettingsTabletView(),
      ),
    ];

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
            label: e.title,
          );
        }).toList(),
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
        selectedIndex: _currentTab,
        destinations: homePageTabs.map((e) {
          return NavigationRailDestination(
            icon: e.icon,
            label: Text(e.title),
          );
        }).toList(),
      );
    }

    Widget _navRailDivider() {
      return VerticalDivider(
        width: 1,
        thickness: 2,
        // color: Colors.transparent,
      );
    }

    Widget _getAnimatedPage(int pageNum, bool useMobile) {
      Widget _child;
      if (useMobile) {
        _child = homePageTabs[pageNum].pageElementsPhone;
      } else {
        _child = homePageTabs[pageNum].pageElementsTablet;
      }
      return PageTransitionSwitcher(
        transitionBuilder: (
          Widget _child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: _child,
          );
        },
        child: _child,
      );
    }

    Widget _floatingActionButton() {
      return OpenContainer(
        closedElevation: 0,
        closedColor: Theme.of(context).primaryColor,
        closedShape: CircleBorder(),
        transitionDuration: containerTransitionDuration,
        // onClosed: (data) => _onGoBack(""),
        openBuilder: (context, action) {
          // return _openAddCar();
          // CarAdd().startAdd(null);
          Provider.of<DataModel>(context).currentCar = null;
          return CarAdd().carAddPage();
        },
        closedBuilder: (context, action) => FloatingActionButton(
          tooltip: 'Add Car',
          child: Icon(
            Icons.add,
            // color: Colors.white,
          ),
        ),
      );
    }

    loadCarList();
    bool useMobile;
    return LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                if (constraints.maxWidth < 600) {
                  useMobile = true;
                  return Scaffold(
                    body: _getAnimatedPage(_currentTab, useMobile),
                    bottomNavigationBar: _navBar(),
                    floatingActionButton:
                        (_currentTab != 0) ? null : _floatingActionButton(),
                  );
                } else {
                  useMobile = false;
                  return Scaffold(
                    body: Row(
                      children: [
                        _navRail(),
                        _navRailDivider(),
                        Expanded(
                            child: _getAnimatedPage(_currentTab, useMobile)),
                      ],
                    ),
                    floatingActionButton:
                    (_currentTab != 0) ? null : _floatingActionButton(),
                  );
                }
              } else {
                if (constraints.maxWidth < 800) {
                  useMobile = true;
                  return Scaffold(
                    body: _getAnimatedPage(_currentTab, useMobile),
                    bottomNavigationBar: _navBar(),
                    floatingActionButton:
                    (_currentTab != 0) ? null : _floatingActionButton(),
                  );
                } else {
                  useMobile = false;
                  return Scaffold(
                    body: Row(
                      children: [
                        _navRail(),
                        _navRailDivider(),
                        Expanded(
                            child: _getAnimatedPage(_currentTab, useMobile)),
                      ],
                    ),
                    floatingActionButton:
                    (_currentTab != 0) ? null : _floatingActionButton(),
                  );
                }
              }
            },
          );
        },
      );
  }
}
