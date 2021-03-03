import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:my_mechanic/Data/dataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:my_mechanic/Data/car.dart';
// import 'package:my_mechanic/Data/service.dart';
// import 'package:my_mechanic/Data/serviceType.dart';

class SharedPrefs {
  static Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  static List<String> _cars = <String>[];
  // static List<String> _serviceTypes = <String>[];

  // test() {
  //   // Service Type
  //
  //   // ServiceType st1 = new ServiceType("Oil Change", Icon(Icons.calendar_today, color: Colors.blueGrey,));
  //   ServiceType st1 = ServiceType("Oil Filter");
  //   st1.id = 4;
  //   String encodedServiceType = jsonEncode(st1);
  //   print(encodedServiceType);
  //
  //   Map<String, dynamic> decodedServiceTypeMap = jsonDecode(encodedServiceType);
  //   print(decodedServiceTypeMap);
  //
  //   ServiceType st2 = ServiceType.fromJson(decodedServiceTypeMap);
  //   print(st2);
  //
  //   // Service
  //
  //   Service s1 = new Service(
  //       "changed oil and filter",
  //       ServiceType("Oil Filter"),
  //       15.0,
  //       "",
  //       DateTime.now(),
  //       DateTime.now().add((new Duration(days: 1))),
  //       false);
  //   s1.id = 4;
  //   String encodedService = jsonEncode(s1);
  //   print(encodedService);
  //
  //   Map<String, dynamic> decodedServiceMap = jsonDecode(encodedService);
  //   print(decodedServiceMap);
  //
  //   Service s2 = Service.fromJson(decodedServiceMap);
  //   print(s2);
  //
  //   // Car
  //
  //   Car c1 = new Car(
  //       "Porsche 911",
  //       500,
  //       Image.network(
  //           "https://www.telegraph.co.uk/cars/images/2018/11/28/new-Porsche-911-992-F34-action_trans_NvBQzQNjv4BqEcUH2tohwTQaV3EQGI26iSiiLCuDZSr-wsh1QAORDwc.jpg",
  //           fit: BoxFit.cover));
  //   c1.id = 4;
  //   String encodedCar = jsonEncode(c1);
  //   print(encodedCar);
  //
  //   Map<String, dynamic> decodedCarMap = jsonDecode(encodedCar);
  //   print(decodedCarMap);
  //
  //   Car c2 = Car.fromJson(decodedCarMap);
  //   // c2.refreshCarData();
  //   print(c2);
  //   if (c2.picture == null) {
  //     c2.picture = DataModel.getSampleImage();
  //   }
  //   CarList().addCarToList(c2);
  //   // Service s1 = new Service("changed oil and filter", ServiceType("Oil Filter"), 15.0, "", DateTime.now(), DateTime.now().add((new Duration(days: 1))), false);
  //   c2.serviceList.addServiceToList(s1);
  //
  //   // Doughnut myDoughnut = new Doughnut("Glazed", "None", ["Sprinkles", "Icing"], 2.99);
  //   // Doughnut myDoughnut2 = new Doughnut("Glazed", "None", ["Sprinkles", "Icing"], 2.99);
  //   // DoughnutList list = new DoughnutList([myDoughnut, myDoughnut2]);
  //   // print(list);
  //   //
  //   // String encodedDoughnutlist = jsonEncode(list);
  //   // print(encodedDoughnutlist);
  //   //
  //   // Map<String, dynamic> decodedDoughnutlist = jsonDecode(encodedDoughnutlist);
  //   // print(decodedDoughnutlist);
  //   //
  //   // List<dynamic> decodedJson =  decodedDoughnutlist['doughnuts'];
  //   // decodedJson.map((elem) => jsonDecode(elem));
  //   // print(decodedJson);
  // }

  static saveData() async {
    // _serviceTypes = <String>[];
    _cars = <String>[];

    CarList.carMap.forEach((key, value) {
      _cars.add(jsonEncode(value));
    });

    // ServiceTypeList.serviceMap.forEach((key, value) {
    //   // print(jsonEncode(value));
    //   _serviceTypes.add(jsonEncode(value));
    // });

    SharedPreferences _prefs = await _pref;
    _prefs.setStringList('cars', _cars);
    // _prefs.setStringList('serviceTypes', _serviceTypes);
  }

  static loadData() async {
    // CarList.lastIndex = null;
    // ServiceTypeList.lastIndex = null;
    // ServiceTypeList.serviceMap.clear();
    // CarList.carMap.clear();

    // DataModel().clearData();
    // _serviceTypes = <String>[];
    // _cars = <String>[];

    SharedPreferences _prefs = await _pref;
    // _serviceTypes = _prefs.getStringList('serviceTypes');
    _cars = _prefs.getStringList('cars');

    // List<dynamic> decodedServiceTypes = _serviceTypes;
    // decodedServiceTypes.forEach((element) {
    //   Map<String, dynamic> decodedServiceTypeMap = jsonDecode(element);
    //   ServiceType s1 = ServiceType.fromJson(decodedServiceTypeMap);
    //   // print(s1);
    //   // print(element);
    //   ServiceTypeList().addServiceType(s1);
    // });

    List<dynamic> decodedCars = _cars;
    decodedCars.forEach((element) {
      Map<String, dynamic> decodedCarMap = jsonDecode(element);
      Car c1 = Car.fromJson(decodedCarMap);

      c1.refreshCarData();

      if (c1.picture == null) {
        c1.picture = DataModel.getSampleImage();
      }

      CarList().addCarToList(c1);
    });
  }
}

class Utility {

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }
}
