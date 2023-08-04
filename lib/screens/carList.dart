import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../widgets/carImage.dart';
import '../widgets/myPageAnimation.dart';
import '../widgets/verticalDivider.dart';
import 'carServiceList.dart';

class CarsList extends StatefulWidget {
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  DataModel? sd;
  static SortBy sortBy = SortBy.date;
  TextEditingController _searchController = TextEditingController();
  late bool isSmall;
  Car? selectedCar;

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.sizeOf(context).shortestSide < 600;
    return Consumer<DataModel>(
      builder: (context, data, child) {
        sd = data;
        sd!.loadData();
        List<int> carKeys = <int>[];
        int carCount = 0;
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
        carCount = carKeys.length;
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: _searchBar(),
                ),
                body: Column(
                  children: [
                    _headerSort(carCount),
                    carCount == 0
                        ? _noCarsCard()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: carCount,
                              itemBuilder: (context, index) {
                                Car car = data.getCarMap()[carKeys[index]]!;
                                return _carItem(
                                  car,
                                  isSmall,
                                  () {
                                    setState(() {
                                      selectedCar = car;
                                    });
                                    if (isSmall) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            CarServiceList(car: selectedCar),
                                      ));
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
            isSmall ? Container() : myVerticalDivider,
            isSmall
                ? Container()
                : Expanded(
                    flex: 5,
                    child: MyPageAnimation(
                      child: CarServiceList(
                        key: ValueKey(selectedCar?.id),
                        car: selectedCar,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  Widget _carItem(Car car, bool isSmall, VoidCallback action) {
    return GestureDetector(
      onTap: () => action(),
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            isSmall
                ? SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CarImage(carImage: car.image),
                  )
                : Container(),
            ListTile(
              selected: car == selectedCar,
              title: Text(
                car.name,
              ),
              subtitle: Text(
                "🛣️ Kilometers: " +
                    car.kilos.toString() +
                    "\n🛠️ Services: " +
                    sd!.getCarServiceMapSize(car).toString(),
              ),
              trailing: isSmall
                  ? null
                  : SizedBox(
                      width: 80,
                      child: CarImage(carImage: car.image),
                    ),
            ),
          ],
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

  Widget _searchBar() {
    return TextField(
      autofocus: false,
      controller: _searchController,
      onChanged: (value) {
        setState(() {});
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
    );
  }

  Widget _headerSort(int carCount) {
    return Column(
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
