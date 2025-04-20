import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_mechanic/widgets/carImage.dart';
import 'package:provider/provider.dart';

import '../Data/config.dart';
import '../Data/dataModel.dart';
import '../Data/service.dart';
import '../Data/car.dart';
import 'carAdd.dart';
import 'carServiceAdd.dart';

class CarServiceList extends StatefulWidget {
  const CarServiceList({super.key, required this.car});
  final Car? car;
  @override
  State<CarServiceList> createState() => _CarServiceListState();
}

class _CarServiceListState extends State<CarServiceList> {
  Car? car;
  bool carLoaded = false;

  @override
  void initState() {
    car = widget.car;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, data, child) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(car == null ? "" : car!.name),
            actions:
                car == null
                    ? []
                    : [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Car',
                        onPressed: () {
                          _openAddCarPage();
                        },
                      ),
                    ],
          ),
          body:
              car == null
                  ? Center(child: Text("No car selected!"))
                  : ListView(
                    children: [
                      Hero(
                        tag: car!,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CarImage(carImage: car!.image),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.all(0),
                                    color: Colors.grey.shade900.withAlpha(80),
                                    clipBehavior: Clip.antiAlias,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 4.0,
                                        sigmaY: 4.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                "🛣️ Kilos: ${car!.kilos}\n🛠️ Services : ${data.getCarServiceMapSize(car!)}",
                                                style: TextStyle(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton.icon(
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.grey.shade200,
                                            ),
                                            label: Text(
                                              "Add Service",
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Provider.of<DataModel>(context, listen: false)
                                              //     .currentService = null;
                                              // _openCarServiceAddPage(car, null);
                                              // data.currentService = null;
                                              _openCarServiceAddPage(
                                                car!,
                                                null,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildServiceSlivers(data.getCarServiceMap(car!), data),
                    ],
                  ),
        );
      },
    );
  }

  void _openCarServiceAddPage(Car car, Service? service) {
    Route route = MaterialPageRoute(
      builder: (context) => CarServiceAdd(car: car, service: service),
    );
    Navigator.push(context, route);
  }

  void _openAddCarPage() {
    Route route = MaterialPageRoute(builder: (context) => CarAddPage(car: car));
    Navigator.push(context, route);
  }

  Widget _buildServiceSlivers(Map<int, Service> serviceMap, DataModel data) {
    String currency = context.watch<Config>().currency;
    List<int> serviceKeys = serviceMap.keys.toList();
    return Column(
      children:
          serviceKeys.length == 0
              ? [ListTile(title: Text("No Services added for this car"))]
              : serviceKeys.map((e) {
                Service thisService = serviceMap[e]!;
                return ListTile(
                  title: Text(thisService.name),
                  subtitle: Text("📅 " + thisService.formattedServiceDate),
                  trailing: Text("$currency ${thisService.price}"),
                  onTap: () {
                    data.currentService = thisService;
                    _openCarServiceAddPage(car!, thisService);
                  },
                );
              }).toList(),
    );
  }
}
