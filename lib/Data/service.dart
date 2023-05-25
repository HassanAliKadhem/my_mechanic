import 'serviceType.dart';

class Service {
  int id;
  int carID;
  String name;
  ServiceType serviceType;
  double price;
  String additionalInfo;
  DateTime serviceDate;
  DateTime nextServiceDate;
  bool remind;

  String get formattedServiceDate {
    return serviceDate.toLocal().toString().split(" ")[0];
  }

  String get formattedNextServiceDate {
    return nextServiceDate.toLocal().toString().split(" ")[0];
  }

  Service(this.name, this.carID, this.serviceType, this.price, this.additionalInfo, this.serviceDate,
      this.nextServiceDate, this.remind);

  Service.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        carID = json['carId'],
        name = json['name'],
        serviceType = ServiceType.fromJson(json['serviceType']),
        price = json['price'],
        additionalInfo = json['additionalInfo'],
        serviceDate = DateTime.parse(json['serviceDate']),
        nextServiceDate = DateTime.parse(json['nextServiceDate']),
        remind = json['remind'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'carId' : carID,
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
    return 'Service{id: $id, carID: $carID, name: $name, serviceType: $serviceType, price: $price, additionalInfo: $additionalInfo, serviceDate: $serviceDate, nextServiceDate: $nextServiceDate, remind: $remind}';
  }
}
//
// class ServiceList {
//   ServiceList();
//   Map<int, Service> serviceMap = new Map<int, Service>();
//   static int lastServiceIndex;
//
//   void loadServiceList(Map<int, Service> newServiceMap) {
//     serviceMap = newServiceMap;
//     newServiceMap.forEach((key, value) {
//       lastServiceIndex = key;
//     });
//   }
//
//   Map<int, Service> getServiceMap() {
//     return serviceMap;
//   }
//
//   void addServiceToList(Service service) {
//     if (lastServiceIndex == null) {
//       lastServiceIndex = 0;
//     } else {
//       lastServiceIndex+= 1;
//     }
//
//     service.id = lastServiceIndex;
//     serviceMap[service.id] = service;
//     CarList().sortCarMaps();
//   }
//
//   void deleteServiceFromList(Service service) {
//     serviceMap.remove(service.id);
//     CarList().sortCarMaps();
//   }
//
//   void updateServiceFromList(Service service) {
//     serviceMap[service.id] = service;
//   }
//
//   int getServiceMapSize() {
//     return serviceMap.length;
//   }
// }