import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';
import 'Data/dataModel.dart';
import 'screens/cars.dart';
import 'screens/upcoming.dart';
import 'screens/search.dart';
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
          theme: appTheme,
          // darkTheme: appThemeDark,
          // themeMode: ThemeMode.dark,
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
  // bool useMobileLayout;
  int _currentTab = 0;
  final String title = "MyMechanic";

  void _onGoBack(dynamic value) {
    // loadCarList();
    // setState(() {});
  }

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

    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    final List<HomePageTab> homePageTabs = <HomePageTab>[
      HomePageTab(
        (screenIncrements > 2) ? "Cars" : title,
        AdaptiveScaffoldDestination(title: 'Cars', icon: Icons.directions_car),
        CarsList(),
      ),
      HomePageTab(
        "Search",
        AdaptiveScaffoldDestination(title: 'Search', icon: Icons.search),
        SearchList(),
      ),
      HomePageTab(
        "Upcoming",
        AdaptiveScaffoldDestination(
            title: 'Upcoming', icon: Icons.calendar_today),
        UpcomingList(),
      ),
      HomePageTab(
        "Setting",
        AdaptiveScaffoldDestination(title: 'Settings', icon: Icons.settings),
        SettingsList(),
      ),
    ];

    Widget _getAnimatedPage(int pageNum) {
      return PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: homePageTabs[pageNum].pageElements,
      );
    }

    Widget adaptiveNav() {
      return AdaptiveNavigationScaffold(
        appBar: AdaptiveAppBar(
          title: Text(homePageTabs[_currentTab].title),
        ),
        selectedIndex: _currentTab,
        onDestinationSelected: (value) {
          setState(() {
            _currentTab = value;
          });
        },
        body: _getAnimatedPage(_currentTab),
        destinations: [
          homePageTabs[0].adaptiveScaffoldDestination,
          homePageTabs[1].adaptiveScaffoldDestination,
          homePageTabs[2].adaptiveScaffoldDestination,
          homePageTabs[3].adaptiveScaffoldDestination,
        ],
        navigationTypeResolver: (context) {
          if (screenIncrements == 1) {
            return NavigationType.bottom;
          } else {
            return NavigationType.rail;
          }
          // } else if (screenIncrements == 2) {
          //   return NavigationType.rail;
          // } else {
          //   return NavigationType.permanentDrawer;
          // }
        },
        drawerHeader: AdaptiveAppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "MyMechanic",
            style: TextStyle(color: appTheme.primaryColor),
          ),
        ),
        fabInRail: false,
        floatingActionButton: (_currentTab > 1)
            ? null
            : FloatingActionButton(
                backgroundColor: appTheme.primaryColor,
                elevation: appTheme.cardTheme.elevation + 1,
                tooltip: 'Add Car',
                onPressed: () {},
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: OpenContainer(
                    closedElevation: 0,
                    closedColor: appTheme.primaryColor,
                    closedShape: CircleBorder(),
                    transitionDuration: containerTransitionDuration,
                    onClosed: (data) => _onGoBack(""),
                    openBuilder: (context, action) {
                      // return _openAddCar();
                      // CarAdd().startAdd(null);
                      Provider.of<DataModel>(context).currentCar = null;
                      return CarAdd().carAddPage();
                    },
                    closedBuilder: (context, action) => const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      );
    }

    loadCarList();
    return adaptiveNav();
    // if (Provider.of<DataModel>(context).loadedData) {
    //   return adaptiveNav();
    // } else {
    //   return FutureBuilder(
    //     future: loadCarList(),
    //     builder: (context, snapshot) {
    //       // DataModel data = snapshot.data;
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           // print("done");
    //           return adaptiveNav();
    //         default:
    //           // print("loading");
    //           return Center(child: CircularProgressIndicator());
    //       }
    //     },
    //   );
    // }
  }
}
