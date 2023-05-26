import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Data/car.dart';
import '../Data/service.dart';
import '../Data/serviceType.dart';
import '../Data/localStorage.dart';

enum SortBy {
  date,
  services,
  name,
}

Map<SortBy, String> sortList = {
  SortBy.date: "Date",
  SortBy.services: "Services",
  SortBy.name: "Name",
};

class DataModel extends ChangeNotifier {
  bool loadedData = false;
  final Map<int, Car> carMap = new Map<int, Car>();
  final Map<int, ServiceType> serviceTypeMap = new Map<int, ServiceType>();
  final Map<int, Service> serviceMap = new Map<int, Service>();
  final List<Car> carListService = <Car>[];
  final List<Car> carListAlpha = <Car>[];

  Car? currentCar;
  Service? currentService;

  loadData() async {
    if (!loadedData) {
      // print("run");
      clearData();
      await _loadDefaultServiceTypes();

      List<Car> carList = await SharedPrefs.loadCars();
      carList.forEach((car) {
        addCarToList(car);
      });

      List<Service> serviceList = await SharedPrefs.loadServices();
      serviceList.forEach((service) {
        addServiceToList(service);
      });

      loadedData = true;
      // print(loadedData);
    }
  }

  saveData() async {
    await SharedPrefs.saveData(carMap, serviceMap);
  }

  Image getSampleImage() {
    return Image.asset(
      "images/placeHolder2.webp",
      fit: BoxFit.cover,
    );
  }

  clearData() {
    carMap.clear();
    serviceMap.clear();
  }

  _loadDefaultServiceTypes() {
    serviceTypeMap.clear();
    ServiceType s1 = new ServiceType("Oil Change", 0);
    addServiceType(s1);
    ServiceType s2 = new ServiceType("Brake Change", 1);
    addServiceType(s2);
    ServiceType s3 = new ServiceType("Spark Plugs Change", 2);
    addServiceType(s3);
  }

  loadSampleData() async {
    clearData();
    await _loadDefaultServiceTypes();
    http.Response imageFile = await http.get(Uri(
        path:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Toulousaine_de_l'automobile_-_7425_-_Porsche_911_Carrera_(2011).jpg/1200px-Toulousaine_de_l'automobile_-_7425_-_Porsche_911_Carrera_(2011).jpg"));
    // print(Utility.base64String(imageFile.bodyBytes));
    Car c1 =
        new Car("Porsche 911", 500, Utility.base64String(imageFile.bodyBytes));
    addCarToList(c1);

    imageFile = await http.get(Uri(
        path:
            "https://st.motortrend.com/uploads/sites/10/2016/08/2017-Dodge-Viper-GTS-front-three-quarter-in-motion.jpg"));
    Car c2 =
        new Car("Dodge Viper", 900, Utility.base64String(imageFile.bodyBytes));
    addCarToList(c2);

    imageFile = await http.get(Uri(
        path:
            "https://i.kinja-img.com/gawker-media/image/upload/s--TWSeA9NH--/c_fill,fl_progressive,g_center,h_900,q_80,w_1600/riufs7rtpk6okzrqiqmy.jpg"));
    Car c3 =
        new Car("Nissan GTR", 1700, Utility.base64String(imageFile.bodyBytes));
    addCarToList(c3);

    addServiceToList(new Service(
        "changed oil and filter",
        carMap.values.first.id!,
        serviceTypeMap[1]!,
        15.0,
        "",
        DateTime.now(),
        DateTime.now().add((new Duration(days: 1))),
        false));
    addServiceToList(new Service(
        "changed Brakes",
        carMap.values.first.id!,
        serviceTypeMap[2]!,
        24.5,
        "",
        DateTime.now().add(new Duration(days: 2)),
        DateTime.now().add((new Duration(days: 3))),
        true));
    // print("sample loaded ----------------");
    // print(carMap);
    // print(serviceMap);
    notifyListeners();
  }

  // Car
  Map<int, Car> getCarMap() {
    return carMap;
  }

  void setCurrentCar(Car car) {
    currentCar = car;
    // notifyListeners();
  }

  int getCarMapSize() {
    return carMap.length;
  }

  int getSearchCarMapSize(String name) {
    return carMap.values.where((car) {
      return car.name.toLowerCase().contains(name.toLowerCase());
    }).length;
  }

  Map<int, Car> getSearchCarMap(String name) {
    Map<int, Car> newCarMap = Map<int, Car>();
    carMap.forEach((key, car) {
      if (car.name.toLowerCase().contains(name.toLowerCase())) {
        newCarMap[car.id!] = car;
      }
    });
    return newCarMap;
  }

  void sortCarMaps() {
    carListService.clear();
    carListAlpha.clear();
    carListService.addAll(carMap.values);
    carListAlpha.addAll(carMap.values);

    carListService.sort(
        (a, b) => getCarServiceMapSize(a).compareTo(getCarServiceMapSize(b)));
    carListAlpha
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // String carList = "cars ";
    // carListService.forEach((element) {
    //   carList += " - " + element.name;
    // });
    // print(carList);
  }

  void addCarToList(Car car) {
    carMap[car.id!] = car;
    sortCarMaps();
    notifyListeners();
  }

  void deleteCarFromList(Car car) {
    carMap.remove(car.id);
    sortCarMaps();
    notifyListeners();
  }

  void updateCarFromList(Car car) {
    carMap[car.id!] = car;
    sortCarMaps();
    notifyListeners();
  }

  Map<int, Service> getServiceMap() {
    return serviceMap;
  }

  Map<int, Service> getUpcomingServiceMap() {
    Map<int, Service> newServiceMap = Map<int, Service>();
    serviceMap.forEach((key, service) {
      if (service.remind) {
        newServiceMap[service.id!] = service;
      }
    });
    return newServiceMap;
  }

  Map<int, Service> getCurrentCarServiceMap() {
    Map<int, Service> newServiceMap = Map<int, Service>();
    serviceMap.forEach((key, service) {
      if (service.carID == currentCar!.id) {
        newServiceMap[service.id!] = service;
      }
    });
    return newServiceMap;
  }

  void addServiceToList(Service service) {
    serviceMap[service.id!] = service;
    sortCarMaps();
    notifyListeners();
  }

  void deleteServiceFromList(Service service) {
    serviceMap.remove(service.id);
    sortCarMaps();
    notifyListeners();
  }

  void updateServiceFromList(Service service) {
    serviceMap[service.id!] = service;
    notifyListeners();
  }

  int getServiceMapSize() {
    return serviceMap.length;
  }

  int getCurrentCarServiceMapSize() {
    return serviceMap.values.where((service) {
      return service.carID == currentCar!.id;
    }).length;
  }

  int getCarServiceMapSize(Car car) {
    return serviceMap.values.where((service) {
      return service.carID == car.id;
    }).length;
  }

  int getUpcomingServiceMapSize() {
    return serviceMap.values.where((service) {
      return service.remind == true;
    }).length;
  }

  // Service type
  Map<int, ServiceType> getServiceTypeMap() {
    return serviceTypeMap;
  }

  int getTypeMapSize() {
    return serviceTypeMap.length;
  }

  void addServiceType(ServiceType type) {
    serviceTypeMap[type.id!] = type;
    // notifyListeners();
  }
}
