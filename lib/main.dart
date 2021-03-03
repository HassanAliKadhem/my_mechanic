import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:animations/animations.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Data/dataModel.dart';
import 'Data/car.dart';
import 'Ui/Common.dart';
import 'upcoming.dart';
import 'search.dart';
import 'carService.dart';
import 'settings.dart';
import 'carAdd.dart';

void main() => runApp(MyApp());

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBar(String message) {
  scaffoldMessengerKey.currentState.removeCurrentSnackBar();
  scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'MyMechanic',
      theme: appTheme,
      home: MyHomePage(title: 'MyMechanic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataModel sd;
  double screenWidth;
  int screenIncrements;
  bool useMobileLayout;
  int _currentTab = 0;

  SortBy _sortBy = SortBy.creating;

  Map<SortBy, String> sortList = {
    SortBy.creating: "Creation",
    SortBy.services: "Services",
    SortBy.name: "Name",
  };

  loadCarList() async {
    sd = new DataModel();
    await sd.loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    useMobileLayout = screenWidth < 600;
    screenIncrements = (screenWidth / 600).ceil();
    // print("$screenWidth - " + screenIncrements.toString());

    final List<HomePageTab> homePageTabs = <HomePageTab>[
      HomePageTab(
          (screenIncrements > 2) ? "Cars" : widget.title,
          AdaptiveScaffoldDestination(
              title: 'Cars', icon: Icons.directions_car),
          FutureBuilder(
            future: loadCarList(),
            builder: (context, snapshot) {
              // DataModel data = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  // print("done");
                  return _carCardList();
                // case ConnectionState.none:
                //   // print("none");
                //   return _noCarsCard();
                default:
                  // print("loading");
                  return Center(child: CircularProgressIndicator());
              }
            },
          )),
      HomePageTab(
          "Search",
          AdaptiveScaffoldDestination(title: 'Search', icon: Icons.search),
          SearchList()),
      HomePageTab(
          "Upcoming",
          AdaptiveScaffoldDestination(
              title: 'Upcoming', icon: Icons.calendar_today),
          UpcomingList()),
      HomePageTab(
          "Setting",
          AdaptiveScaffoldDestination(title: 'Settings', icon: Icons.settings),
          SettingsList()),
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
        } else if (screenIncrements == 2) {
          return NavigationType.rail;
        } else {
          return NavigationType.permanentDrawer;
        }
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
                    return _openAddCar();
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

  // TODO: remove depreciated class
  @deprecated
  void _openAddCarPage() {
    CarAdd().startAdd(null);
    Route route =
        MaterialPageRoute(builder: (context) => CarAdd().carAddPage());
    Navigator.push(context, route).then(_onGoBack);
  }

  // TODO: remove depreciated class
  @deprecated
  void _openCarServicePage(Car car, int index) {
    CarService.serviceMap = car.serviceList.getServiceMap();
    CarService.car = car;
    CarService.heroTagIndex = index;
    Route route =
        MaterialPageRoute(builder: (context) => CarService().servicePage(car));
    Navigator.push(context, route).then(_onGoBack);
  }

  Widget _openAddCar() {
    CarAdd().startAdd(null);
    return CarAdd().carAddPage();
  }

  Widget _openCarService(Car car) {
    return CarService().servicePage(car);
  }

  _onGoBack(dynamic value) {
    loadCarList();
    // setState(() {});
  }

  Widget _headerSort() {
    return PhysicalModel(
      color: Colors.white,
      elevation: Theme.of(context).cardTheme.elevation,
      child: Row(
        children: [
          Flexible(
            child: ListTile(
              key: Key("carCounter"),
              title: Text("Cars: " + sd.getCarMap().length.toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _sortDropDownButton(),
          ),
        ],
      ),
    );
  }

  Widget _carCardList() {
    List<int> carKeys = <int>[];

    if (_sortBy == SortBy.creating) {
      carKeys = sd.getCarMap().keys.toList();
    } else if (_sortBy == SortBy.name) {
      CarList.carListAlpha.forEach((element) {
        carKeys.add(element.id);
      });
    } else if (_sortBy == SortBy.services) {
      CarList.carListService.reversed.forEach((element) {
        carKeys.add(element.id);
      });
    }

    if (carKeys.isEmpty) {
      return _noCarsCard();
    } else {
      return Column(
        children: [
          _headerSort(),
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: screenIncrements,
              itemCount: sd.getCarMap().length,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (BuildContext context, int index) {
                return _carCard(
                    sd.getCarMap()[carKeys[index]], carKeys[index], context);
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            ),
          ),
        ],
      );
    }
  }

  Widget _carCard(Car car, int index, BuildContext context) {
    return Card(
      elevation: appTheme.cardTheme.elevation + 1,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: OpenContainer(
        tappable: false,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onClosed: _onGoBack,
        transitionDuration: containerTransitionDuration,
        openBuilder: (_, _a) {
          // return CarService().servicePage(car);
          return _openCarService(car);
        },
        closedBuilder: (_, _action) => InkWell(
          onTap: () {
            _action();
          },
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: screenWidth,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: DataModel.getLoadingImage().image,
                  image: car.picture.image,
                ),
              ),
              ListTile(
                title: Text(
                  car.name,
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: appTheme.textTheme.bodyText2
                        .copyWith(color: appTheme.disabledColor),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.speed,
                            color: appTheme.accentColor,
                            size: 20,
                          ),
                        ),
                      ),
                      TextSpan(text: "Kilos: " + car.kilos.toString()),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.home_repair_service,
                              color: appTheme.accentColor, size: 20),
                        ),
                      ),
                      TextSpan(
                        text: "services: " + car.serviceMap.length.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noCarsCard() {
    return Align(
      alignment: Alignment.topCenter,
      child: const Card(
        margin: EdgeInsets.all(5),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListTile(
          trailing: const Icon(Icons.car_rental),
          title: Text(
            "You have not added any cars, please add a car using the floating button!",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget _sortDropDownButton() {
    final List<DropdownMenuItem> _itemList = <DropdownMenuItem>[];
    final List<Widget> _chipList = <Widget>[];
    _chipList.add(Text("Sort by "));
    sortList.forEach((key, value) {
      _itemList.add(
        DropdownMenuItem(
          value: key,
          child: (_sortBy == key)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(value), Icon(Icons.check)],
                )
              : Text(value),
        ),
      );

      _chipList.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ChoiceChip(
          label: Text(value),
          selected: key == _sortBy,
          onSelected: (bool selected) {
            setState(() {
              setState(() {
                _sortBy = key;
              });
            });
          },
        ),
      ));
    });
    if (screenIncrements == 1) {
      return DropdownButton(
        underline: Container(),
        icon: Icon(Icons.sort, color: appTheme.primaryColor),
        // value: _sortBy,
        hint: Text("Sort by " + sortList[_sortBy]),
        onChanged: (value) {
          setState(() {
            _sortBy = value;
          });
        },
        items: _itemList,
      );
    } else {
      return Row(
        children: _chipList,
      );
    }
  }
}
