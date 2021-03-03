import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Data/car.dart';
import 'Data/dataModel.dart';
import 'carService.dart';

void search(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return SearchList();
    },
  ));
}

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  List<String> propList = [];
  Car car1;
  int heroTagIndex;
  List<Widget> widgetList = <Widget>[];
  DataModel sd = new DataModel();
  Map<int, Car> carMap;
  var _controller = TextEditingController();

  _SearchListState() {
    carMap = sd.getCarMap();
    carMap.keys.forEach((index) {
      widgetList.add(_carTile(carMap[index], index));
    });
  }

  _updateList(String searchTerm) {
    widgetList.clear();
    carMap.keys.forEach((index) {
      if (carMap[index].name.toLowerCase().contains(searchTerm.toLowerCase())) {
        widgetList.add(_carTile(carMap[index], index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: _searchFieldClear(),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }

  Widget _carTile(Car car, int index) {
    return ListTile(
      onTap: () {
        CarService.serviceMap = car.serviceList.getServiceMap();
        CarService.car = car;
        CarService.heroTagIndex = index;
        CarService().serviceList(context);
      },
      leading: Hero(
        tag: 'imageHero' + index.toString(),
        child: Image(
          image: car.picture.image,
          height: 50,
          width: 60,
        ),
      ),
      title: Text(
        car.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text("Kilos : " + car.kilos.toString()),
      trailing: Icon(Icons.navigate_next),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _searchFieldClear() {
    return TextField(
      controller: _controller,
      onChanged: (text) {
        _updateList(text);
        setState(() {});
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
            _updateList("");
            setState(() {});
          },
          icon: Icon(
            Icons.clear,
          ),
        ),
      ),
    );
  }
}