import 'package:flutter/widgets.dart';

import 'localStorage.dart';

class Car {
  static int lastCarIndex = 0;
  int? id;
  String name;
  int kilos;
  String imageBytes;
  Image? image;

  Car(this.name, this.kilos, this.imageBytes) {
    lastCarIndex++;
    this.id = lastCarIndex;
    if (imageBytes.isNotEmpty && imageBytes != "") {
      this.image = Utility.imageFromBase64String(imageBytes);
    }
  }

  Car.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      kilos = json['kilos'],
      imageBytes = json['imageBytes'],
      image = Utility.imageFromBase64String(json['imageBytes']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kilos': kilos,
    'imageBytes': imageBytes,
  };

  void carImage(String image_bytes) {
    this.imageBytes = image_bytes;
    this.image = Utility.imageFromBase64String(image_bytes);
  }

  @override
  String toString() {
    return 'Car{id: $id, name: $name, kilos: $kilos, picture: $imageBytes}';
  }
}
