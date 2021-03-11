// import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'localStorage.dart';
// import 'service.dart';

class Car {
  int id;
  String name;
  int kilos;
  Image picture;
  String imageBytes;
  // ServiceList serviceList = new ServiceList();
  // Map<int, Service> serviceMap;

  Car(this.name, this.kilos, this.imageBytes) {
    picture = Utility.imageFromBase64String(imageBytes);
    // serviceMap = serviceList.serviceMap;
  }

  refreshCarData () {
    picture = Utility.imageFromBase64String(imageBytes);
    // serviceList.loadServiceList(serviceMap);
  }

  // List<String> convertListToString() {
  //   List<String> stringList = <String>[];
  //
  //   serviceList.serviceMap.forEach((key, value) {
  //     stringList.add(jsonEncode(value));
  //   });
  //
  //   return stringList;
  // }

  Car.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kilos = json['kilos'],
        imageBytes = json['imageBytes']
  // ,
  //       serviceMap = convertListToMap(json['serviceList'])
  ;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'kilos' : kilos,
    'imageBytes' : imageBytes
    // ,
    // 'serviceList' : convertListToString()
  };

  @override
  String toString() {
    // return 'Car{id: $id, name: $name, kilos: $kilos, picture: $picture, serviceList: $serviceList, serviceMap: $serviceMap}';
    return 'Car{id: $id, name: $name, kilos: $kilos, picture: $picture}';
  }
}

// Map<int, Service> convertListToMap(List<dynamic> jsonList) {
//   Map<int, Service> newServiceMap = Map<int, Service>();
//   jsonList.forEach((element) {
//     Map<String, dynamic> decodedServiceMap = jsonDecode(element);
//     Service c1 = Service.fromJson(decodedServiceMap);
//     newServiceMap[c1.id] = c1;
//   });
//   return newServiceMap;
// }

// class CarList {
//   const CarList();
//   static Map<int,Car> carMap = new Map<int,Car>();
//   static List<Car> carListService;
//   static List<Car> carListAlpha;
//   static int lastCarIndex;
//
//   void sortCarMaps() {
//     carListService = carMap.values.toList();
//     carListAlpha = carListService;
//     carListService.sort((a, b) => b.serviceMap.length.compareTo(a.serviceMap.length));
//     carListAlpha.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
//   }
//
//   void addCarToList(Car car) {
//     if (lastCarIndex == null) {
//       lastCarIndex = 0;
//     } else {
//       lastCarIndex+= 1;
//     }
//
//     car.id = lastCarIndex;
//     carMap[car.id] = car;
//     sortCarMaps();
//   }
//
//   void deleteCarFromList(Car car) {
//     carMap.remove(car.id);
//     sortCarMaps();
//   }
//
//   void updateCarFromList(Car car) {
//     carMap[car.id] = car;
//     sortCarMaps();
//   }
//
//   int getCarMapSize() {
//     return carMap.length;
//   }
// }