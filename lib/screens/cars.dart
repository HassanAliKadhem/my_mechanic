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

class CarsTabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: CarsList(useMobile: false),
        ),
        VerticalDivider(
          width: 1.5,
          thickness: 1.5,
        ),
        Expanded(
          child: CarService().servicePage(),
        ),
      ],
    );
  }
}

class CarsList extends StatefulWidget {
  CarsList({Key key, this.useMobile}) : super(key: key);
  final bool useMobile;
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  // DataModel sd = DataModel();
  DataModel sd;
  // double screenWidth;
  // double shortestWidth;
  // int screenIncrements;
  // bool useMobileLayout;
  // int _currentTab = 0;
  static SortBy sortBy = SortBy.date;

  @override
  void initState() {
    super.initState();
    // _controller.text = searchTerms;
  }

  @override
  Widget build(BuildContext context) {
    // if (MediaQuery.of(context).orientation == Orientation.portrait) {
    //   screenWidth = MediaQuery.of(context).size.width;
    // } else {
    //   screenWidth = MediaQuery.of(context).size.height;
    // }
    // shortestWidth = MediaQuery.of(context).size.shortestSide;
    // screenIncrements = (screenWidth / 600).ceil().clamp(1, 3);

    // return _carCardList();
    return Consumer<DataModel>(
      builder: (context, data, child) {
        sd = data;
        // sd.setCurrentCar(sd.getCarMap().values.first);
        // if (screenIncrements == 1) {
        return _carCardList(widget.useMobile);
        // } else {
        //   return Row(
        //     children: [
        //       Flexible(
        //         flex: 2,
        //         child: _carCardList(true),
        //       ),
        //       VerticalDivider(
        //         width: 1.5,
        //         thickness: 1.5,
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

  Widget _openCarService(Car car) {
    sd.setCurrentCar(car);
    return CarService().servicePage();
  }

  _onGoBack(dynamic value) {
    // loadCarList();
    setState(() {});
  }

  var _searchController = TextEditingController();
  var _searchFocusNode = FocusNode();
  // static String searchTerms = "";

  Widget _carCardList(bool useMobile) {
    List<int> carKeys = <int>[];
    int itemCount = 0;
    if (_searchController.text.length == 0) {
      if (sortBy == SortBy.date) {
        carKeys = sd.getCarMap().keys.toList();
      } else if (sortBy == SortBy.name) {
        sd.carListAlpha.forEach((element) {
          carKeys.add(element.id);
        });
      } else if (sortBy == SortBy.services) {
        sd.carListService.reversed.forEach((element) {
          carKeys.add(element.id);
        });
      }
    } else {
      carKeys = sd.getSearchCarMap(_searchController.text).keys.toList();
    }
    itemCount = carKeys.length;

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Theme.of(context).canvasColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: false,
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      _searchFocusNode.unfocus();
                    },
                    decoration: InputDecoration(
                      suffixIcon: (_searchController.text.isNotEmpty) ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.clear,
                        ),
                      ) : null,
                      // labelText: "Search",
                      hintText: "Search Cars",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     _controller.clear();
                //     setState(() {});
                //   },
                //   icon: Icon(
                //     Icons.clear,
                //   ),
                // ),
              ],
            ),

            // ListTile(
            //   title: TextField(
            //     autofocus: false,
            //     controller: _controller,
            //     onChanged: (value) {
            //       setState(() {});
            //     },
            //     decoration: InputDecoration(
            //       hintText: "Search Cars",
            //       border: InputBorder.none,
            //       hintStyle:
            //           TextStyle(color: appTheme.accentColor.withAlpha(150)),
            //     ),
            //   ),
            //   trailing: (_controller.text.isNotEmpty)
            //       ? IconButton(
            //           onPressed: () {
            //             _controller.clear();
            //             setState(() {});
            //           },
            //           icon: Icon(
            //             Icons.clear,
            //           ),
            //         )
            //       : null,
          ),
          _headerSort(itemCount),
          (carKeys.isEmpty && sd.getCarMap().isEmpty)
              ? _noCarsCard()
              : Expanded(
                  child: ListView.builder(
                    itemCount: itemCount,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (BuildContext context, int index) {
                      if (useMobile) {
                        return _carCard(
                            sd.getCarMap()[carKeys[index]], context);
                      } else {
                        return ListTileTheme(
                          selectedTileColor:
                              Theme.of(context).accentColor.withOpacity(0.2),
                          child:
                              _carTile(sd.getCarMap()[carKeys[index]], context),
                        );
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _carTile(Car car, BuildContext context) {
    bool selected =
        (sd.currentCar != null) ? (car.id == sd.currentCar.id) : false;
    return ListTile(
      dense: true,
      selected: selected,
      onTap: () {
        sd.setCurrentCar(car);
      },
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
      subtitle: Text(
          "Kilos: ${car.kilos} - services: ${sd.getCarServiceMapSize(car)}"),
    );
  }

  Widget _carCard(Car car, BuildContext context) {
    return Card(
      elevation: Theme.of(context).cardTheme.elevation + 1,
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
                width: double.infinity,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Theme.of(context).disabledColor),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.speed,
                            color: Theme.of(context).accentColor,
                            size: 20,
                          ),
                        ),
                      ),
                      TextSpan(text: "Kilos: " + car.kilos.toString()),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.home_repair_service,
                              color: Theme.of(context).accentColor, size: 20),
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

  Widget _headerSort(int carCount) {
    return Column(
      // color: Colors.white,
      // elevation: Theme.of(context).cardTheme.elevation,
      children: [
        ListTile(
          key: Key("carCounter"),
          title: Text("Cars: $carCount"),
          trailing: _sortDropDownButton(),
        ),
        Divider(
          height: 2,
          indent: 16,
          endIndent: 16,
          // thickness: 2,
        ),
      ],
    );
  }

  Widget _sortDropDownButton() {
    final List<DropdownMenuItem> _itemList = <DropdownMenuItem>[];
    sortList.forEach((key, value) {
      _itemList.add(
        DropdownMenuItem(
          value: key,
          child: (sortBy == key)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(value), Icon(Icons.check)],
                )
              : Text(value),
        ),
      );
    });

    return DropdownButton(
      underline: Container(),
      icon: Icon(
        Icons.sort,
        color: Theme.of(context).accentColor,
      ),
      // value: _sortBy,
      hint: Text(
        "Sort: ${sortList[sortBy]}",
      ),
      onChanged: (value) {
        setState(() {
          sortBy = value;
        });
      },
      items: _itemList,
    );
  }
}
