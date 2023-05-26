import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../Data/localStorage.dart';
import 'carService.dart';

@deprecated
void search(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return SearchPhoneView(useMobile: false);
    },
  ));
}

class SearchTabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: SearchPhoneView(useMobile: false),
        ),
        VerticalDivider(
          width: 1.5,
          thickness: 1.5,
        ),
        Flexible(
          flex: 3,
          child: CarService().servicePage(),
        ),
      ],
    );
  }
}


class SearchPhoneView extends StatefulWidget {
  final bool useMobile;

  @override
  _SearchPhoneViewState createState() => _SearchPhoneViewState();

  SearchPhoneView({this.useMobile = true});
}

class _SearchPhoneViewState extends State<SearchPhoneView> {
  List<String> propList = [];
  Car? car1;
  int? heroTagIndex;
  static String searchTerms = "";
  List<Widget> widgetList = <Widget>[];
  // DataModel model;
  // Map<int, Car> carMap;
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // model = Provider.of<DataModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: _searchFieldClear(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(
            height: 2,
            thickness: 2,
          ),
        ),
      ),
      body: _updateList(searchTerms),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.text = searchTerms;
  }

  // _SearchListState() {
  //   // carMap = sd.getCarMap();
  //   // carMap.keys.forEach((index) {
  //   //   widgetList.add(_carTile(carMap[index], index));
  //   // });
  //   _updateList("");
  // }

  Widget _searchFieldClear() {
    return TextField(
      controller: _controller,
      onChanged: (text) {
        // searchTerms = text;
        // _updateList(text);
        setState(() {
          searchTerms = text;
        });
      },
      autofocus: true,
      style: TextStyle(color: Colors.red),
      decoration: InputDecoration(
        // disabledBorder: InputBorder.none,
        // enabledBorder: InputBorder.none,
        hintText: "Enter Car Name",
        hintStyle: TextStyle(color: Colors.red[200]),
        suffixIcon: IconButton(
          onPressed: () {
            _controller.clear();
            // searchTerms = "";
            // _updateList("");
            setState(() {
              searchTerms = "";
            });
          },
          icon: Icon(
            Icons.clear,
          ),
        ),
      ),
    );
  }

  // TODO: fix search
  _updateList(String newSearchTerm) {
    widgetList = [];

    return Consumer<DataModel>(
      builder: (context, data, child) {
        data.getSearchCarMap(newSearchTerm).forEach((key, car) {
          widgetList.add(ListTile(
            onTap: () {
              // CarService.serviceMap = car.serviceList.getServiceMap();
              // CarService.car = car;
              // CarService.heroTagIndex = index;
              data.currentCar = car;
              CarService().serviceList(context);
            },
            leading: car.imageBytes.length == 0 ? null : Image(
              image: Utility.imageFromBase64String(car.imageBytes).image,
              height: 50,
              width: 60,
            ),
            title: Text(
              car.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text("Kilos : " + car.kilos.toString()),
            trailing: Icon(Icons.navigate_next),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ));
        });
        // print(widgetList.length);
        return ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: widgetList,
        );
      },
    );
  }

  // Widget _carTile(Car car, int index) {
  //   return Consumer<DataModel>(
  //     builder: (context, data, child) {
  //       return ListTile(
  //         onTap: () {
  //           // CarService.serviceMap = car.serviceList.getServiceMap();
  //           // CarService.car = car;
  //           // CarService.heroTagIndex = index;
  //           data.currentCar = car;
  //           CarService().serviceList(context);
  //         },
  //         leading: Hero(
  //           tag: 'imageHero' + index.toString(),
  //           child: Image(
  //             image: car.picture.image,
  //             height: 50,
  //             width: 60,
  //           ),
  //         ),
  //         title: Text(
  //           car.name,
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         subtitle: Text("Kilos : " + car.kilos.toString()),
  //         trailing: Icon(Icons.navigate_next),
  //         contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //       );
  //     },
  //   );
  // }
}
