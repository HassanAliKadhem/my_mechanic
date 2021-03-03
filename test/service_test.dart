import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_mechanic/Data/car.dart';
import 'package:my_mechanic/Data/service.dart';
import 'package:my_mechanic/Data/dataModel.dart';
import 'package:my_mechanic/Data/serviceType.dart';

void main() {
  final dataModel = DataModel();
  final File image = File("images/placeHolder2.webp");
  dataModel.getCarMap()[0] =
      Car("Test Car", 12345, base64Encode(image.readAsBytesSync()));
  ServiceType type = ServiceType("Oil Filter");
  dataModel.getServiceTypeMap()[0] = type;

  group("Service", () {
    test("service list should be increased", () {
      Service service = Service("new Service", dataModel.getServiceTypeMap()[0], 155.5, "no additional info", DateTime.now(), DateTime.now(), true);
      dataModel.getCarMap()[0].serviceList.addServiceToList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 1);

      service = Service("filter changes", dataModel.getServiceTypeMap()[0], 2016, "no additional info", DateTime.now(), DateTime.now(), true);
      dataModel.getCarMap()[0].serviceList.addServiceToList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 2);

      service = Service("new Service", dataModel.getServiceTypeMap()[0], 456.498, "no additional info", DateTime.now(), DateTime.now(), true);
      dataModel.getCarMap()[0].serviceList.addServiceToList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 3);

      expect(dataModel.getCarMap().length, 1);
    });
    test("service list should not grow when updated", () {
      Service service = Service("new Service", dataModel.getServiceTypeMap()[0], 155.5, "no additional info", DateTime.now(), DateTime.now(), true);
      dataModel.getCarMap()[0].serviceList.addServiceToList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 4);

      service = dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value;
      service.name = "test service";
      service.price = 480;
      dataModel.getCarMap()[0].serviceList.updateServiceFromList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 4);
      expect(dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value.name, "test service");
      expect(dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value.price, 480);

      service = dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value;
      service.additionalInfo = "additional information for the test service";
      service.price = 480.48;
      dataModel.getCarMap()[0].serviceList.updateServiceFromList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 4);
      expect(dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value.additionalInfo, "additional information for the test service");
      expect(dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value.price, 480.48);

      expect(dataModel.getCarMap().length, 1);
    });
    test("service list should shrink when services deleted", () {
      Service service = dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value;
      dataModel.getCarMap()[0].serviceList.deleteServiceFromList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 3);

      service = dataModel.getCarMap()[0].serviceList.serviceMap[1];
      dataModel.getCarMap()[0].serviceList.deleteServiceFromList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 2);

      service = dataModel.getCarMap()[0].serviceList.serviceMap[0];
      dataModel.getCarMap()[0].serviceList.deleteServiceFromList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 1);

      service = dataModel.getCarMap()[0].serviceList.serviceMap.entries.last.value;
      dataModel.getCarMap()[0].serviceList.deleteServiceFromList(service);
      expect(dataModel.getCarMap()[0].serviceList.getMapSize(), 0);

      expect(dataModel.getCarMap().length, 1);
    });
  });
}
