import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_mechanic/Data/localStorage.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'Data/car.dart';
import 'Data/dataModel.dart';
import 'Ui/Common.dart';
import 'main.dart';

class CarAdd {
  static Car car;
  static String carName;
  static int carKilos;
  static String imageBytes;
  static bool edit;

  void startAdd(Car newCar) {
    if (newCar != null) {
      car = newCar;
      edit = true;
      carName = car.name;
      carKilos = car.kilos;
      imageBytes = car.imageBytes;
    } else {
      car = null;
      edit = false;
      carName = "";
      carKilos = 0;
      imageBytes = null;
    }
  }

  void addCarPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CarAddPage();
    }));
  }

  Widget carAddPage() {
    return CarAddPage();
  }
}

class CarAddPage extends StatefulWidget {
  @override
  State<CarAddPage> createState() => _CarAddPageState();
}

class _CarAddPageState extends State<CarAddPage> {
  EdgeInsets _paddingInsets = const EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text((CarAdd.car == null) ? 'Add Car' : 'Edit Car'),
          actions: (CarAdd.edit
              ? <Widget>[_deleteButton(), _saveButton()]
              : [_saveButton()])),
      body: _buildServiceRows(),
    );
  }

  Widget _buildServiceRows() {
    return ListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: <Widget>[
        StickyHeader(
          header: header("Car Details"),
          content: Column(
            children: [
              Padding(
                padding: _paddingInsets,
                child: TextFormField(
                  initialValue: CarAdd.carName,
                  onChanged: (text) {
                    CarAdd.carName = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Car Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: _paddingInsets,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue:
                  (CarAdd.carKilos != 0) ? CarAdd.carKilos.toString() : "",
                  onChanged: (text) {
                    CarAdd.carKilos = int.tryParse(text);
                  },
                  decoration: InputDecoration(
                    labelText: 'Kilometers Driven',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.speed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        StickyHeader(
          header: header("Car Image"),
          content: Card(
            elevation: 0,
            margin: _paddingInsets,
            shape: OutlineInputBorder(
                borderSide: BorderSide(color: Theme
                    .of(context)
                    .disabledColor)),
            child: ListTile(
              title: Text("Please select an image"),
              leading: Icon(Icons.image),
              trailing: (CarAdd.imageBytes != null)
                  ? Utility.imageFromBase64String(CarAdd.imageBytes)
                  : DataModel.getSampleImage(),
              onTap: () {
                _showPicker(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  ImagePicker _picker = ImagePicker();

  _imgFromCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    final File image = File(pickedFile.path);

    setState(() {
      CarAdd.imageBytes = Utility.base64String(image.readAsBytesSync());
    });
  }

  _imgFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File image = File(pickedFile.path);

    setState(() {
      CarAdd.imageBytes = Utility.base64String(image.readAsBytesSync());
    });
  }

  _saveService() {
    List<String> errorList = <String>[];
    if (CarAdd.carName == null) {
      errorList.add("Name not entered");
    } else if (CarAdd.carName.length == 0) {
      errorList.add("Name not entered");
    }
    if (CarAdd.carKilos == null) {
      errorList.add("Price not entered");
    } else if (CarAdd.carKilos
        .toString()
        .length == 0) {
      errorList.add("Price not entered");
    }

    if (errorList.length == 0) {
      if (!CarAdd.edit) {
        CarAdd.car =
        new Car(CarAdd.carName, CarAdd.carKilos, CarAdd.imageBytes);
      } else {
        CarAdd.car.name = CarAdd.carName;
        CarAdd.car.kilos = CarAdd.carKilos;
        CarAdd.car.imageBytes = CarAdd.imageBytes;
        CarAdd.car.refreshCarData();
      }

      if (!CarAdd.edit) {
        CarList().addCarToList(CarAdd.car);
        showSnackBar("Car Added");
        Navigator.of(context).pop();
      } else {
        CarList().updateCarFromList(CarAdd.car);
        showSnackBar("Car Edited");
        Navigator.of(context).pop();
      }
      DataModel.saveData();
    } else {
      String errorMessage = "";
      errorList.forEach((element) {
        errorMessage += element + "\n";
      });
      _showErrorDialog(errorMessage);
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog(
          title: new Text("Missing Fields"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog(
          title: new Text("Delete Car"),
          content: Text("are you sure you want to delete this car?"),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () {
                CarList().deleteCarFromList(CarAdd.car);
                DataModel.saveData();
                showSnackBar("Car Deleted!");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.save),
      tooltip: 'Save Car',
      onPressed: () {
        _saveService();
      },
    );
  }

  Widget _deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Delete Car',
      onPressed: () {
        _showDeleteDialog();
      },
    );
  }

}