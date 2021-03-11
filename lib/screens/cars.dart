import 'dart:ui';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../theme/theme.dart';
import 'carService.dart';

class CarsList extends StatefulWidget {
  CarsList({Key key}) : super(key: key);

  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  // DataModel sd = DataModel();
  DataModel sd;
  double screenWidth;
  double shortestWidth;
  int screenIncrements;
  // bool useMobileLayout;
  // int _currentTab = 0;

  static SortBy _sortBy = SortBy.creating;

  Map<SortBy, String> sortList = {
    SortBy.creating: "Creation",
    SortBy.services: "Services",
    SortBy.name: "Name",
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      screenWidth = MediaQuery.of(context).size.width;
    } else {
      screenWidth = MediaQuery.of(context).size.height;
    }
    shortestWidth = MediaQuery.of(context).size.shortestSide;
    screenIncrements = (screenWidth / 600).ceil().clamp(1, 3);

    // return _carCardList();
    return Consumer<DataModel>(
      builder: (context, data, child) {
        sd = data;
        // if (screenIncrements == 1) {
          return _carCardList(false);
        // } else {
        //   return Row(
        //     children: [
        //       Flexible(
        //         flex: 2,
        //         child: _carCardList(true),
        //       ),
        //       Flexible(
        //         flex: 3,
        //         child: _openCarService(sd.currentCar),
        //       ),
        //     ],
        //   );
        // }
      },
    );
  }

  // // TODO: remove depreciated class
  // @deprecated
  // void _openAddCarPage() {
  //   CarAdd().startAdd(null);
  //   Route route =
  //       MaterialPageRoute(builder: (context) => CarAdd().carAddPage());
  //   Navigator.push(context, route).then(_onGoBack);
  // }
  //
  // // TODO: remove depreciated class
  // @deprecated
  // void _openCarServicePage(Car car, int index) {
  //   CarService.serviceMap = car.serviceList.getServiceMap();
  //   CarService.car = car;
  //   CarService.heroTagIndex = index;
  //   Route route =
  //       MaterialPageRoute(builder: (context) => CarService().servicePage(car));
  //   Navigator.push(context, route).then(_onGoBack);
  // }

  // Widget _openAddCar() {
  //   CarAdd().startAdd(null);
  //   return CarAdd().carAddPage();
  // }

  Widget _openCarService(Car car) {
    sd.currentCar = car;
    // return CarService().servicePage(car);
    return CarService().servicePage();
  }

  _onGoBack(dynamic value) {
    // loadCarList();
    setState(() {});
  }

  Widget _headerSort() {
    return Column(
      // color: Colors.white,
      // elevation: Theme.of(context).cardTheme.elevation,
      children: [
        Row(
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
        Divider(
          height: 2,
          thickness: 2,
        ),
      ],
    );
    // return PhysicalModel(
    //   color: Colors.white,
    //   elevation: Theme.of(context).cardTheme.elevation,
    //   child: Row(
    //     children: [
    //       Flexible(
    //         child: ListTile(
    //           key: Key("carCounter"),
    //           title: Text("Cars: " + sd.getCarMap().length.toString()),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(right: 16.0),
    //         child: _sortDropDownButton(),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _carCardList(bool usePush) {
    List<int> carKeys = <int>[];

    if (_sortBy == SortBy.creating) {
      carKeys = sd.getCarMap().keys.toList();
    } else if (_sortBy == SortBy.name) {
      sd.carListAlpha.forEach((element) {
        carKeys.add(element.id);
      });
    } else if (_sortBy == SortBy.services) {
      sd.carListService.reversed.forEach((element) {
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
            child: SafeArea(
              left: true,
              right: true,
              top: false,
              bottom: false,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: screenIncrements,
                itemCount: sd.getCarMap().length,
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                itemBuilder: (BuildContext context, int index) {
                  if (usePush) {
                    return _carCardPush(
                        sd.getCarMap()[carKeys[index]], context);
                  } else {
                    return _carCard(sd.getCarMap()[carKeys[index]], context);
                  }
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _carCardPush(Car car, BuildContext context) {
    return InkWell(
      onTap: () {
        sd.setCurrentCar(car);
        // print(sd.currentCar.name);
      },
      child: Card(
        elevation: appTheme.cardTheme.elevation,
        margin: EdgeInsets.all(6),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // SizedBox(
            //   height: 200,
            //   width: screenWidth,
            //   child: FadeInImage(
            //     fit: BoxFit.cover,
            //     placeholder: sd.getLoadingImage().image,
            //     image: car.picture.image,
            //   ),
            // ),
            ListTile(
              title: Text(
                car.name,
              ),
              leading: SizedBox(
                width: 70,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: sd.getLoadingImage().image,
                  image: car.picture.image,
                ),
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
                    TextSpan(text: "Kilos: " + car.kilos.toString() + "\n"),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.home_repair_service,
                            color: appTheme.accentColor, size: 20),
                      ),
                    ),
                    TextSpan(
                      text: "services: " +
                          sd.getCarServiceMapSize(car).toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carCard(Car car, BuildContext context) {
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
                width: shortestWidth,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: sd.getLoadingImage().image,
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
                        text: "services: " +
                            sd.getCarServiceMapSize(car).toString(),
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
              // setState(() {
              _sortBy = key;
              // });
            });
          },
        ),
      ));
    });

    if (screenIncrements == 1) {
      return DropdownButton(
        underline: Container(),
        icon: Icon(Icons.sort, color: appTheme.accentColor),
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
