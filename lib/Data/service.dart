import 'package:my_mechanic/Data/car.dart';
import 'package:my_mechanic/Data/serviceType.dart';

class Service {
  int id;
  String name;
  ServiceType serviceType;
  double price;
  String additionalInfo;
  DateTime serviceDate;
  DateTime nextServiceDate;
  bool remind;

  Service(this.name, this.serviceType, this.price, this.additionalInfo, this.serviceDate,
      this.nextServiceDate, this.remind);

  Service.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        serviceType = ServiceType.fromJson(json['serviceType']),
        price = json['price'],
        additionalInfo = json['additionalInfo'],
        serviceDate = DateTime.parse(json['serviceDate']),
        nextServiceDate = DateTime.parse(json['nextServiceDate']),
        remind = json['remind'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'serviceType' : serviceType,
    'price' : price,
    'additionalInfo' : additionalInfo,
    'serviceDate' : serviceDate.toString(),
    'nextServiceDate' : nextServiceDate.toString(),
    'remind' : remind
  };

  @override
  String toString() {
    return 'Service{id: $id, name: $name, serviceType: $serviceType, price: $price, additionalInfo: $additionalInfo, serviceDate: $serviceDate, nextServiceDate: $nextServiceDate, remind: $remind}';
  }
}

class ServiceList {
  ServiceList();
  Map<int, Service> serviceMap = new Map<int, Service>();
  static int lastIndex;

  void loadServiceList(Map<int, Service> newServiceMap) {
    serviceMap = newServiceMap;
    newServiceMap.forEach((key, value) {
      lastIndex = key;
    });
  }

  Map<int, Service> getServiceMap() {
    return serviceMap;
  }

  int generateNewIndex() {
    if (lastIndex == null) {
      lastIndex = 0;
    } else {
      lastIndex+= 1;
    }
    return lastIndex;
  }
  void addServiceToList(Service service) {
    service.id = generateNewIndex();

    serviceMap[service.id] = service;
    CarList().sortMaps();
  }

  void deleteServiceFromList(Service service) {
    serviceMap.remove(service.id);
    CarList().sortMaps();
  }

  void updateServiceFromList(Service service) {
    serviceMap[service.id] = service;
  }

  int getMapSize() {
    return serviceMap.length;
  }
}