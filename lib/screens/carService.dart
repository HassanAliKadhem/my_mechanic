import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../Data/dataModel.dart';
import '../Data/service.dart';
import '../Data/car.dart';
import '../theme/theme.dart';
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
  CarServicePage({Key key}) : super(key: key);
  @override
  State<CarServicePage> createState() => _CarServicePageState();
}

class _CarServicePageState extends State<CarServicePage> {
  Car car;
  // List<Widget> _widgetSlivers = <Widget>[];
  bool carLoaded = false;
  // _CarServicePageState();

  // ScrollController _scrollController;
  //
  // bool lastStatus = true;
  //
  //
  // _scrollListener() {
  //   if (isShrink != lastStatus) {
  //     setState(() {
  //       lastStatus = isShrink;
  //     });
  //   }
  // }
  //
  // bool get isShrink {
  //   return _scrollController.hasClients &&
  //       _scrollController.offset > (200 - kToolbarHeight);
  // }
  //
  // @override
  // void initState() {
  //   _scrollController = ScrollController();
  //   _scrollController.addListener(_scrollListener);
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   _scrollController.removeListener(_scrollListener);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Color isShrinkColor = isShrink ? Colors.red : Colors.white;
    return Scaffold(
      body: Consumer<DataModel>(
        builder: (context, data, child) {
          if (data.currentCar == null) {
            carLoaded = false;
            return Center(
              child: Text("No car selected!"),
            );
          } else {
            carLoaded = true;
            return CustomScrollView(
              // controller: _scrollController,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  actions: CarActions(context),
                  actionsIconTheme: IconThemeData(
                    // color: isShrinkColor,
                  ),
                  stretch: true,
                  expandedHeight: 200,
                  elevation: Theme.of(context).appBarTheme.elevation,
                  forceElevated: true,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: <StretchMode>[
                      StretchMode.zoomBackground,
                    ],
                    title: Text(
                      data.currentCar.name,
                      // style: TextStyle(
                          // color: isShrinkColor,
                      // ),
                    ),
                    // TODO: fix title padding on tablet without breaking mobile
                    // titlePadding:
                    //     EdgeInsetsDirectional.only(start: 12, bottom: 12),
                    background: Image(
                      image: data.currentCar.picture.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _buildServiceSlivers(),
              ],
            );
          }
        },
      ),
    );
  }

  List<Widget> CarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.add,
        ),
        tooltip: 'Add New Service',
        onPressed: () {
          Provider.of<DataModel>(context, listen: false).currentService = null;
          // _openCarServiceAddPage(car, null);
          // data.currentService = null;
          _openCarServiceAddPage();
        },
      ),
      IconButton(
        icon: const Icon(MdiIcons.carCog),
        tooltip: 'Add Car',
        onPressed: () {
          _openAddCarPage();
        },
      ),
    ];
  }

  void _openCarServiceAddPage() {
    Route route = MaterialPageRoute(
        builder: (context) => CarServiceAdd().carServiceAddPage());
    Navigator.push(context, route)
        // .then(_onGoBack)
        ;
  }

  void _openAddCarPage() {
    Provider.of<DataModel>(context, listen: false).currentCar = car;
    // CarAdd().startAdd(car);
    Route route =
        MaterialPageRoute(builder: (context) => CarAdd().carAddPage());
    Navigator.push(context, route)
        // .then(_onGoBack)
        ;
  }

  // _onGoBack(dynamic value) {
  //   setState(() {});
  // }

  Widget _buildServiceSlivers() {
    return Consumer<DataModel>(
      builder: (context, data, child) {
        car = data.currentCar;
        List<int> serviceKeys = data.getCurrentCarServiceMap().keys.toList();
        Map<int, Service> serviceMap = data.getCurrentCarServiceMap();
        return SliverStickyHeader(
          header:
              header("Services : " + data.getCarServiceMapSize(car).toString()),
          sliver: SliverList(
            delegate: (data.getCurrentCarServiceMapSize() > 0)
                ? SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (serviceMap[serviceKeys[index]].carID ==
                          data.currentCar.id) {
                        return ListTile(
                          title: Text(
                            serviceMap[serviceKeys[index]].name,
                          ),
                          isThreeLine: true,
                          subtitle: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2
                                  .copyWith(color: Theme.of(context).disabledColor),
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.calendar_today,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                ),
                                TextSpan(
                                    text: serviceMap[serviceKeys[index]]
                                        .serviceDate
                                        .toLocal()
                                        .toString()
                                        .split(" ")[0]),
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Icon(Icons.home_repair_service,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                ),
                                TextSpan(
                                    text: serviceMap[serviceKeys[index]]
                                        .serviceType
                                        .name),
                              ],
                            ),
                          ),
                          trailing: Text("\$ " +
                              serviceMap[serviceKeys[index]].price.toString()),
                          onTap: () {
                            data.currentService =
                                serviceMap[serviceKeys[index]];
                            _openCarServiceAddPage();
                          },
                        );
                      }
                      return null;
                    },
                    childCount: data.getCurrentCarServiceMapSize(),
                  )
                : SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                            "No Services recorded for this car, add your first service please"),
                        subtitle: Text(""),
                        // trailing: Icon(Icons.add),
                        // onTap: () {
                        //   data.currentService = null;
                        //   _openCarServiceAddPage();
                        // },
                      );
                    },
                    childCount: 1,
                  ),
          ),
        );
      },
    );
  }

  // Widget _serviceSliver(Service service) {
  //   return ListTile(
  //     title: Text(
  //       serviceMap[serviceKeys[index]].name,
  //     ),
  //     isThreeLine: true,
  //     subtitle: Text("Date: " +
  //         serviceMap[serviceKeys[index]].serviceDate
  //             .toLocal()
  //             .toString()
  //             .split(" ")[0] +
  //         // "\nPrice: " +
  //         // serviceMap[serviceKeys[index]].price.toString() +
  //         "\nService Type: " +
  //         serviceMap[serviceKeys[index]].serviceType.name),
  //     leading: Icon(
  //       Icons.car_repair,
  //     ),
  //     trailing: Icon(Icons.navigate_next),
  //     onTap: () {
  //       data.currentService = serviceMap[serviceKeys[index]];
  //       _openCarServiceAddPage();
  //     },
  //   );
  // }
  //
  //   Widget _noServiceSliver() {
  //     return ListTile(
  //       title: Text(
  //           "No Services recorded for this car, add your first service please"),
  //       subtitle: Text(""),
  //       trailing: Icon(Icons.add),
  //       onTap: () {
  //         _openCarServiceAddPage(car, null);
  //       },
  //     );
  //   }
  //
  //   List<int> serviceKeys = data.getServiceMap().keys.toList();
  //   return SliverStickyHeader(
  //     header: header("Services : " + data.getCarServiceMapSize(car).toString()),
  //     sliver: sliverList(_serviceSliver, serviceKeys, _noServiceSliver, data),
  //   );
  // }
  //
  // SliverList sliverList(Widget _serviceSliver(int index), List<int> serviceKeys,
  //     Widget _noServiceSliver(), DataModel data) {
  //   return SliverList(
  //     delegate: (data.getServiceMap().length > 0)
  //         ? SliverChildBuilderDelegate(
  //             (BuildContext context, int index) {
  //               int newIndex = index ~/ 2;
  //               if (index.isEven) {
  //                 return _serviceSliver(serviceKeys[newIndex]);
  //               } else {
  //                 return Divider(
  //                   height: 0,
  //                 );
  //               }
  //             },
  //             childCount: (car.serviceMap.length * 2 - 1),
  //           )
  //         : SliverChildBuilderDelegate(
  //             (BuildContext context, int index) {
  //               return _noServiceSliver();
  //             },
  //             childCount: 1,
  //           ),
  //   );
  // }
  //
  // // TODO: remove depreciated class
  // @deprecated
  // SliverFillRemaining sliverFillRemaining(Widget _serviceSliver(int index),
  //     List<int> serviceKeys, Widget _noServiceSliver()) {
  //   return SliverFillRemaining(
  //     child: (car.serviceMap.length > 0)
  //         ? ListView.separated(
  //             itemBuilder: (context, index) {
  //               return _serviceSliver(serviceKeys[index]);
  //             },
  //             separatorBuilder: (context, index) {
  //               return Divider(
  //                 height: 1,
  //               );
  //             },
  //             itemCount: car.serviceMap.length)
  //         : ListView(children: [_noServiceSliver()]),
  //   );
  // }
}
