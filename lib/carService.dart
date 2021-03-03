import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Data/service.dart';
import 'Data/car.dart';
import 'Ui/Common.dart';
import 'carAdd.dart';
import 'carServiceAdd.dart';

class CarService {
  static Map<int, Service> serviceMap = new Map<int, Service>();
  static Car car;
  static int heroTagIndex;

  void serviceList(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CarServicePage(car: car);
    }));
  }

  Widget servicePage(Car car) {
    return CarServicePage(car: car);
  }
}

class CarServicePage extends StatefulWidget {
  Car car;

  CarServicePage({Key key, @required this.car}) : super(key: key);

  @override
  State<CarServicePage> createState() => _CarServicePageState(car);
}

class _CarServicePageState extends State<CarServicePage> {
  Car car;
  List<Widget> _widgetSlivers = <Widget>[];

  _CarServicePageState(this.car);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add New Service',
                onPressed: () {
                  _openCarServiceAddPage(car, null);
                },
              ),
              IconButton(
                icon: const Icon(MdiIcons.carCog),
                tooltip: 'Add Car',
                onPressed: () {
                  _openAddCarPage();
                },
              ),
            ],
            stretch: true,
            onStretchTrigger: () {
              return;
            },
            expandedHeight: 180,
            elevation: appTheme.appBarTheme.elevation,
            floating: false,
            pinned: true,
            title: Text(
              car.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                // StretchMode.blurBackground,
                // StretchMode.fadeTitle,
              ],
              background: Image(
                image: car.picture.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildServiceSlivers(),
        ],
      ),
    );
  }

  void _openCarServiceAddPage(Car car, Service service) {
    CarServiceAdd.car = car;
    CarServiceAdd.service = service;
    Route route = MaterialPageRoute(
        builder: (context) => CarServiceAdd().carServiceAddPage());
    Navigator.push(context, route).then(_onGoBack);
  }

  void _openAddCarPage() {
    CarAdd().startAdd(car);
    Route route =
        MaterialPageRoute(builder: (context) => CarAdd().carAddPage());
    Navigator.push(context, route).then(_onGoBack);
  }

  _onGoBack(dynamic value) {
    setState(() {});
  }

  Widget _buildServiceSlivers() {
    _widgetSlivers.clear();

    if (car.serviceMap.length > 0) {
      car.serviceMap.forEach((key, service) {
        _widgetSlivers.add(ListTile(
          title: Text(
            service.name,
          ),
          isThreeLine: true,
          subtitle: Text("Date: " +
              service.serviceDate.toLocal().toString().split(" ")[0] +
              "\nPrice: " +
              service.price.toString() +
              "\nService Type: " +
              service.serviceType.name),
          leading: Icon(
            Icons.car_repair,
            color: Colors.blueGrey,
          ),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            _openCarServiceAddPage(car, service);
          },
        ));
      });
    } else {
      _widgetSlivers.add(ListTile(
        title: Text(
            "No Services recorded for this car, add your first service please"),
        subtitle: Text(""),
        trailing: Icon(Icons.add),
        onTap: () {
          _openCarServiceAddPage(car, null);
        },
      ));
    }

    Widget _serviceSliver(int index) {
      return ListTile(
        title: Text(
          car.serviceMap[index].name,
        ),
        subtitle: RichText(
          text: TextSpan(
              style: appTheme.textTheme.bodyText2
                  .copyWith(color: appTheme.disabledColor),
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.calendar_today,
                        color: appTheme.disabledColor),
                  ),
                ),
                TextSpan(
                    text: car.serviceMap[index].serviceDate
                        .toLocal()
                        .toString()
                        .split(" ")[0]),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(Icons.home_repair_service,
                        color: appTheme.disabledColor),
                  ),
                ),
                TextSpan(text: car.serviceMap[index].serviceType.name),
              ]),
        ),
        trailing: Text("\$ " + car.serviceMap[index].price.toString()),
        onTap: () {
          _openCarServiceAddPage(car, car.serviceMap[index]);
        },
      );
    }

    Widget _noServiceSliver() {
      return ListTile(
        title: Text(
            "No Services recorded for this car, add your first service please"),
        subtitle: Text(""),
        trailing: Icon(Icons.add),
        onTap: () {
          _openCarServiceAddPage(car, null);
        },
      );
    }

    var serviceKeys = car.serviceMap.keys.toList();
    return SliverStickyHeader(
      header: header("Services : " + car.serviceMap.length.toString()),
      sliver: sliverList(_serviceSliver, serviceKeys, _noServiceSliver),
    );
  }

  SliverList sliverList(Widget _serviceSliver(int index), List<int> serviceKeys,
      Widget _noServiceSliver()) {
    return SliverList(
      delegate: (car.serviceMap.length > 0)
          ? SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                int newIndex = index ~/ 2;
                if (index.isEven) {
                  return _serviceSliver(serviceKeys[newIndex]);
                } else {
                  return Divider(
                    height: 0,
                  );
                }
              },
              childCount: (car.serviceMap.length * 2 -1),
            )
          : SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _noServiceSliver();
              },
              childCount: 1,
            ),
    );
  }

  // TODO: remove depreciated class
  @deprecated
  SliverFillRemaining sliverFillRemaining(Widget _serviceSliver(int index),
      List<int> serviceKeys, Widget _noServiceSliver()) {
    return SliverFillRemaining(
      child: (car.serviceMap.length > 0)
          ? ListView.separated(
              itemBuilder: (context, index) {
                return _serviceSliver(serviceKeys[index]);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                );
              },
              itemCount: car.serviceMap.length)
          : ListView(children: [_noServiceSliver()]),
    );
  }
}
