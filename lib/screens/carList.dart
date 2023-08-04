import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:my_mechanic/widgets/carImage.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';

import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../theme/theme.dart';
import '../widgets/myLayoutBuilder.dart';
import 'carService.dart';

class CarsList extends StatefulWidget {
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  DataModel? sd;
  static SortBy sortBy = SortBy.date;
  var _searchController = TextEditingController();
  var _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, data, child) {
        sd = data;
        sd!.loadData();
        List<int> carKeys = <int>[];
        int itemCount = 0;
        if (_searchController.text.length == 0) {
          if (sortBy == SortBy.date) {
            carKeys = data.getCarMap().keys.toList();
          } else if (sortBy == SortBy.name) {
            data.carListAlpha.forEach((element) {
              carKeys.add(element.id!);
            });
          } else if (sortBy == SortBy.services) {
            data.carListService.reversed.forEach((element) {
              carKeys.add(element.id!);
            });
          }
        } else {
          carKeys = sd == null
              ? []
              : sd!.getSearchCarMap(_searchController.text).keys.toList();
        }
        itemCount = carKeys.length;
        return Scaffold(
          body: MyLayoutBuilderPages(
            mobileLayout: SafeArea(
              child: Column(
                children: [
                  _searchBar(),
                  _headerSort(itemCount),
                  (carKeys.isEmpty && data.getCarMap().isEmpty)
                      ? _noCarsCard()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: itemCount,
                            // physics: BouncingScrollPhysics(
                            //     parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (BuildContext context, int index) {
                              return _carCard(
                                  data.getCarMap()[carKeys[index]]!, context);
                            },
                          ),
                        ),
                ],
              ),
            ),
            tabletLayout: Row(
              children: [
                SizedBox(
                  width: listWidth,
                  child: SafeArea(
                    child: Column(
                      children: [
                        _searchBar(),
                        _headerSort(itemCount),
                        (carKeys.isEmpty && data.getCarMap().isEmpty)
                            ? _noCarsCard()
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: itemCount,
                                  // physics: BouncingScrollPhysics(
                                  //     parent: AlwaysScrollableScrollPhysics()),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _carTile(
                                        data.getCarMap()[carKeys[index]]!);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                myVerticalDivider,
                Expanded(
                  child: MyPageAnimation(
                    child: CarServicePage(key: ValueKey(data.currentCar?.id)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _openCarService(Car car) {
    sd?.setCurrentCar(car);
    return CarServicePage();
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
      ),
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
          contentPadding: EdgeInsets.symmetric(
            vertical: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
          ),
          suffixIcon: (_searchController.text.isNotEmpty)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                  ),
                )
              : null,
          // labelText: "Search",
          hintText: "Search Cars",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _carTile(Car car) {
    return ListTile(
      dense: true,
      selected: (sd != null && sd!.currentCar != null)
          ? (car.id == sd!.currentCar!.id)
          : false,
      onTap: () {
        sd?.setCurrentCar(car);
      },
      title: Text(
        car.name,
      ),
      trailing: ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          width: 70,
          child: CarImage(carImage: car.image),
        ),
      ),
      subtitle: Text(
          "Kilos: ${car.kilos} - services: ${sd == null ? 0 : sd!.getCarServiceMapSize(car)}"),
    );
  }

  Widget _carCard(Car car, BuildContext context) {
    return Card(
      // elevation: Theme.of(context).cardTheme.elevation + 1,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: OpenContainer(
        tappable: false,
        closedColor: Theme.of(context).cardColor,
        middleColor: Theme.of(context).cardColor,
        openColor: Theme.of(context).cardColor,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
              // ListTile(title: Text(car.name,),),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CarImage(carImage: car.image),
              ),
              ListTile(
                title: Text(
                  car.name,
                ),
                subtitle: Text("🛣️ Kilometers: " +
                    car.kilos.toString() +
                    "\n🛠️ Services: " +
                    sd!.getCarServiceMapSize(car).toString()),
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
            "You have not added any cars, please add a car using the floating add button!",
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
          height: 3,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          // thickness: 2,
        ),
      ],
    );
  }

  Widget _sortDropDownButton() {
    final List<DropdownMenuItem<SortBy>> _itemList =
        <DropdownMenuItem<SortBy>>[];
    sortList.forEach((key, value) {
      _itemList.add(
        DropdownMenuItem<SortBy>(
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

    return DropdownButton<SortBy>(
      underline: Container(),
      icon: Icon(
        Icons.sort,
        color: Theme.of(context).colorScheme.secondary,
      ),
      // value: _sortBy,
      hint: Text(
        "Sort: ${sortList[sortBy]}",
      ),
      onChanged: (value) {
        setState(() {
          if (value != null) sortBy = value;
        });
      },
      items: _itemList,
    );
  }
}
