import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
// import 'dataModel.dart';

import 'car.dart';
import 'config.dart';
import 'service.dart';
// import 'serviceType.dart';

class SharedPrefs {
  static SharedPreferences? _pref;
  // static List<String> _cars = <String>[];
  // static List<String> _services = <String>[];
  // static List<String> _serviceTypes = <String>[];

  static saveConfig(Config config) async {
    SharedPreferences _prefs = _pref?? await SharedPreferences.getInstance();
    _prefs.setString("themeMode", config.themeMode);
    _prefs.setString("currency", config.currency);
  }

  static saveData(
    Map<int, Car> carMap, Map<int, Service> serviceMap) async {
    // _serviceTypes = <String>[];
    List<String> _cars = <String>[];
    List<String> _services = <String>[];

    // DataModel model = Provider.of<DataModel>(context, listen: false);
    carMap.forEach((key, value) {
      _cars.add(jsonEncode(value));
    });

    serviceMap.forEach((key, value) {
      _services.add(jsonEncode(value));
    });

    // ServiceTypeList.serviceMap.forEach((key, value) {
    //   // print(jsonEncode(value));
    //   _serviceTypes.add(jsonEncode(value));
    // });

    SharedPreferences _prefs = _pref?? await SharedPreferences.getInstance();

    _prefs.setStringList('cars', _cars);
    _prefs.setStringList('services', _services);
    // _prefs.setStringList('serviceTypes', _serviceTypes);
    
    // print("saved data to local ----------------");
    // print(carMap.length);
    // print(serviceMap.length);
  }

  static Future<List<Car>> loadCars() async {
    SharedPreferences _prefs = _pref?? await SharedPreferences.getInstance();
    List<Car> _carList = [];

    if (_prefs.getStringList('cars') != null) {
      List<String> _cars = _prefs.getStringList('cars') ?? [];
      List<dynamic> decodedCars = _cars;
      decodedCars.forEach((element) {
        Map<String, dynamic> decodedCarMap = jsonDecode(element);
        Car c1 = Car.fromJson(decodedCarMap);
        // if (c1.picture == null) {
        //   c1.picture = DataModel.getSampleImage();
        // }
        _carList.add(c1);
      });
    }
    // print(_carList.length);
    return _carList;
  }

  static Future<List<Service>> loadServices() async {
    SharedPreferences _prefs = _pref?? await SharedPreferences.getInstance();
    List<Service> _serviceList = [];

    if (_prefs.getStringList('services') != null) {
      List<String> _services = _prefs.getStringList('services') ?? [];
      List<dynamic> decodedServices = _services;
      decodedServices.forEach((element) {
        Map<String, dynamic> decodedMap = jsonDecode(element);
        Service s1 = Service.fromJson(decodedMap);

        _serviceList.add(s1);
      });
    }

    return _serviceList;
  }

  // static loadData() async {
  //   // CarList.lastIndex = null;
  //   // ServiceTypeList.lastIndex = null;
  //   // ServiceTypeList.serviceMap.clear();
  //   // CarList.carMap.clear();
  //
  //   // DataModel model = Provider.of<DataModel>(context, listen: false);
  //
  //   // DataModel().clearData();
  //   // _serviceTypes = <String>[];
  //   // _cars = <String>[];
  //
  //   SharedPreferences _prefs = await _pref;
  //   // _serviceTypes = _prefs.getStringList('serviceTypes');
  //   // List<dynamic> decodedServiceTypes = _serviceTypes;
  //   // decodedServiceTypes.forEach((element) {
  //   //   Map<String, dynamic> decodedServiceTypeMap = jsonDecode(element);
  //   //   ServiceType s1 = ServiceType.fromJson(decodedServiceTypeMap);
  //   //   // print(s1);
  //   //   // print(element);
  //   //   ServiceTypeList().addServiceType(s1);
  //   // });
  //
  //   if (_prefs.getStringList('cars') != null) {
  //   _cars = _prefs.getStringList('cars');
  //     List<dynamic> decodedCars = _cars;
  //     decodedCars.forEach((element) {
  //       Map<String, dynamic> decodedCarMap = jsonDecode(element);
  //       Car c1 = Car.fromJson(decodedCarMap);
  //
  //       c1.refreshCarData();
  //
  //       if (c1.picture == null) {
  //         c1.picture = DataModel.getSampleImage();
  //       }
  //       model.addCarToList(c1);
  //       // CarList().addCarToList(c1);
  //     });
  //   }
  //
  //   if (_prefs.getStringList('services') != null) {
  //   _services = _prefs.getStringList('services');
  //     List<dynamic> decodedServices = _services;
  //     decodedServices.forEach((element) {
  //       Map<String, dynamic> decodedMap = jsonDecode(element);
  //       Service s1 = Service.fromJson(decodedMap);
  //
  //       model.addServiceToList(s1);
  //     });
  //   }
  //
  //   print("loaded data from local ----------------");
  //   print(_prefs.getStringList('cars'));
  //   print(_prefs.getStringList('services'));
  // }
  static Future<Config> loadConfig() async {
    SharedPreferences _prefs = _pref?? await SharedPreferences.getInstance();
    return Config(
        themeMode: _prefs.getString("themeMode") ?? themeModesList.first,
        currency: _prefs.getString("currency") ?? currencyList.first);
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
