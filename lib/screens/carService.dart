import 'dart:core';

import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../Data/config.dart';
import '../Data/dataModel.dart';
import '../Data/localStorage.dart';
import '../Data/service.dart';
import '../Data/car.dart';
import '../widgets/header.dart';
import 'carAdd.dart';
import 'carServiceAdd.dart';

class CarService {
  // static Map<int, Service> serviceMap = new Map<int, Service>();
  // static Car car;
  // static int heroTagIndex;

  void serviceList(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CarServicePage();
    }));
  }

  Widget servicePage() {
    return CarServicePage();
  }
}

class CarServicePage extends StatefulWidget {
  @override
  State<CarServicePage> createState() => _CarServicePageState();
}

class _CarServicePageState extends State<CarServicePage> {
  Car? car;
  bool carLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, data, child) {
      carLoaded = data.currentCar != null;
      if (carLoaded) {
        car = data.currentCar;
      }
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(data.currentCar!.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Add Car',
              onPressed: () {
                _openAddCarPage();
              },
            ),
          ],
        ),
        body: !carLoaded
            ? Center(
                child: Text("No car selected!"),
              )
            : ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(6.0),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        fit: BoxFit.cover,
                        image: Utility.imageFromBase64String(car!.imageBytes)
                            .image,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Expanded(
                          child: header("Services : " +
                              data.getCarServiceMapSize(car!).toString())),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text("Add Service"),
                          onPressed: () {
                            Provider.of<DataModel>(context, listen: false)
                                .currentService = null;
                            // _openCarServiceAddPage(car, null);
                            // data.currentService = null;
                            _openCarServiceAddPage();
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildServiceSlivers(data.getCurrentCarServiceMap(), data),
                ],
              ),
      );
    });
  }

  void _openCarServiceAddPage() {
    Route route = MaterialPageRoute(
        builder: (context) => CarServiceAdd().carServiceAddPage());
    Navigator.push(context, route);
  }

  void _openAddCarPage() {
    Provider.of<DataModel>(context, listen: false).currentCar = car;
    Route route = MaterialPageRoute(builder: (context) => CarAddPage());
    Navigator.push(context, route);
  }

  Widget _buildServiceSlivers(Map<int, Service> serviceMap, DataModel data) {
    return Consumer<Config>(builder: (context, config, child) {
      List<int> serviceKeys = serviceMap.keys.toList();
      return Column(
        children: serviceKeys.length == 0
            ? [
                ListTile(
                  title: Text("No Services added for this car"),
                ),
              ]
            : serviceKeys.map((e) {
                Service thisService = serviceMap[e]!;
                return ListTile(
                  title: Text(thisService.name),
                  subtitle: Text("📅 " + thisService.formattedServiceDate),
                  trailing: Text("${config.currency} ${thisService.price}"),
                  onTap: () {
                    data.currentService = thisService;
                    _openCarServiceAddPage();
                  },
                );
              }).toList(),
      );
    });
  }
}
