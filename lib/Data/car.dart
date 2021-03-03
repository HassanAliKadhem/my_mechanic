import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:my_mechanic/Data/localStorage.dart';
import 'package:my_mechanic/Data/service.dart';

class Car {
  int id;
  String name;
  int kilos;
  Image picture;
  String imageBytes;
  ServiceList serviceList = new ServiceList();
  Map<int, Service> serviceMap;

  Car(this.name, this.kilos, this.imageBytes) {
    picture = Utility.imageFromBase64String(imageBytes);
    serviceMap = serviceList.serviceMap;
  }

  refreshCarData () {
    picture = Utility.imageFromBase64String(imageBytes);
    serviceList.loadServiceList(serviceMap);
  }

  List<String> convertListToString() {
    List<String> stringList = <String>[];

    serviceList.serviceMap.forEach((key, value) {
      stringList.add(jsonEncode(value));
    });

    return stringList;
  }

  Car.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kilos = json['kilos'],
        imageBytes = json['imageBytes'],
        serviceMap = convertListToMap(json['serviceList']);

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'kilos' : kilos,
    'imageBytes' : imageBytes,
    'serviceList' : convertListToString()
  };

  @override
  String toString() {
    return 'Car{id: $id, name: $name, kilos: $kilos, picture: $picture, serviceList: $serviceList, serviceMap: $serviceMap}';
  }
}

Map<int, Service> convertListToMap(List<dynamic> jsonList) {
  Map<int, Service> newServiceMap = Map<int, Service>();
  jsonList.forEach((element) {
    Map<String, dynamic> decodedServiceMap = jsonDecode(element);
    Service c1 = Service.fromJson(decodedServiceMap);
    newServiceMap[c1.id] = c1;
  });
  return newServiceMap;
}

class CarList {
  const CarList();
  static Map<int,Car> carMap = new Map<int,Car>();
  static List<Car> carListService;
  static List<Car> carListAlpha;
  static int lastIndex;

  void sortMaps() {
    carListService = carMap.values.toList();
    carListAlpha = carListService;
    carListService.sort((a, b) => b.serviceMap.length.compareTo(a.serviceMap.length));
    carListAlpha.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  int generateNewIndex() {
    if (lastIndex == null) {
      lastIndex = 0;
    } else {
      lastIndex+= 1;
    }
    return lastIndex;
  }

  void addCarToList(Car car) {
    car.id = generateNewIndex();
    carMap[car.id] = car;
    sortMaps();
  }

  void deleteCarFromList(Car car) {
    carMap.remove(car.id);
    sortMaps();
  }

  void updateCarFromList(Car car) {
    carMap[car.id] = car;
    sortMaps();
  }

  int getMapSize() {
    return carMap.length;
  }
}