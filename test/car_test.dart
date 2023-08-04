import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_mechanic/Data/car.dart';
import 'package:my_mechanic/Data/dataModel.dart';

void main() {
  final dataModel = DataModel();
  final File image = File("images/placeHolder2.webp");

  group("Car", () {
    test("Adding", () {
      dataModel.getCarMap()[0] =
          Car("Test Car", 12345, base64Encode(image.readAsBytesSync()));
      expect(dataModel.getCarMap().length, 1);

      dataModel.getCarMap()[1] =
          Car("Test Car 2", 12489, base64Encode(image.readAsBytesSync()));
      expect(dataModel.getCarMap().length, 2);

      dataModel.getCarMap()[2] =
          Car("Testsdgsadgr 12", 12489, base64Encode(image.readAsBytesSync()));
      expect(dataModel.getCarMap().length, 3);

      dataModel.getCarMap()[3] =
          Car("Test asdg'r 2", 12489, base64Encode(image.readAsBytesSync()));
      expect(dataModel.getCarMap().length, 4);
    });

    test("Deleting", () {
      expect(dataModel.getCarMap().length, 4);
      dataModel.deleteCarFromList(dataModel.getCarMap().entries.first.value);
      expect(dataModel.getCarMap().length, 3);
    });
  });
}
