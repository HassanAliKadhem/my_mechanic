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
  dataModel.addCarToList(
      Car("Test Car", 12345, base64Encode(image.readAsBytesSync())));
  final int carID = dataModel.getCarMap().values.first.id!;
  ServiceType type = ServiceType("Oil Filter", 1);
  dataModel.addServiceType(type);

  group("Service", () {
    test("service list should be increased", () {
      Service service = Service(
        "new Service",
        carID,
        dataModel.getServiceTypeMap().entries.first.value,
        155.5,
        "no additional info",
        DateTime.now(),
        DateTime.now(),
        true,
      );
      dataModel.addServiceToList(service);
      expect(dataModel.getServiceMapSize(), 1);

      service = Service(
        "filter changes",
        carID,
        dataModel.getServiceTypeMap().entries.first.value,
        2016,
        "no additional info",
        DateTime.now(),
        DateTime.now(),
        true,
      );
      dataModel.addServiceToList(service);
      expect(dataModel.getServiceMapSize(), 2);

      service = Service(
        "new Service",
        carID,
        dataModel.getServiceTypeMap().entries.first.value,
        456.498,
        "no additional info",
        DateTime.now(),
        DateTime.now(),
        true,
      );
      dataModel.addServiceToList(service);
      expect(dataModel.getServiceMapSize(), 3);

      expect(dataModel.getCarMap().length, 1);
    });
    test("service list should not grow when updated", () {
      Service service = Service(
          "new Service",
          carID,
          dataModel.getServiceTypeMap().entries.first.value,
          155.5,
          "no additional info",
          DateTime.now(),
          DateTime.now(),
          true);
      dataModel.addServiceToList(service);
      expect(dataModel.getServiceMapSize(), 4);

      service = dataModel.getServiceMap().entries.last.value;
      service.name = "test service";
      service.price = 480;
      dataModel.updateServiceFromList(service);
      expect(dataModel.getServiceMapSize(), 4);
      expect(dataModel.getServiceMap().entries.last.value.name, "test service");
      expect(dataModel.getServiceMap().entries.last.value.price, 480);

      service = dataModel.getServiceMap().entries.last.value;
      service.additionalInfo = "additional information for the test service";
      service.price = 480.48;
      dataModel.updateServiceFromList(service);
      expect(dataModel.getServiceMapSize(), 4);
      expect(dataModel.getServiceMap().entries.last.value.additionalInfo,
          "additional information for the test service");
      expect(dataModel.getServiceMap().entries.last.value.price, 480.48);

      expect(dataModel.getCarMap().length, 1);
    });
    test("service list should shrink when services deleted", () {
      Service service = dataModel.getServiceMap().entries.last.value;
      dataModel.deleteServiceFromList(service);
      expect(dataModel.getServiceMapSize(), 3);

      service = dataModel.getServiceMap()[1]!;
      dataModel.deleteServiceFromList(service);
      expect(dataModel.getServiceMapSize(), 2);

      service = dataModel.getServiceMap()[2]!;
      dataModel.deleteServiceFromList(service);
      expect(dataModel.getServiceMapSize(), 1);

      service = dataModel.getServiceMap().entries.last.value;
      dataModel.deleteServiceFromList(service);
      expect(dataModel.getServiceMapSize(), 0);

      expect(dataModel.getCarMap().length, 1);
    });
  });
}
