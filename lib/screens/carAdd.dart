import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_mechanic/widgets/carImage.dart';
import 'package:my_mechanic/widgets/myLayoutBuilder.dart';
import 'package:provider/provider.dart';

import '../Data/localStorage.dart';
import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../widgets/header.dart';
import '../widgets/snackBar.dart';

class CarAddPage extends StatefulWidget {
  @override
  State<CarAddPage> createState() => _CarAddPageState();
}

class _CarAddPageState extends State<CarAddPage> {
  Car? car;
  DataModel? model;
  bool edit = false;
  final _formKey = GlobalKey<FormState>();
  bool assigned = false;

  ImagePicker _picker = ImagePicker();
  bool imageValid = true;

  @override
  void initState() {
    super.initState();
    assigned = false;
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
                      _getCarImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _getCarImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _getCarImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      setState(() {
        car?.carImage(Utility.base64String(image.readAsBytesSync()));
      });
    }
  }

  _saveCar() {
    if (car != null && car?.imageBytes == null) {
      setState(() {
        imageValid = false;
      });
    } else {
      setState(() {
        imageValid = true;
      });
    }
    if (_formKey.currentState!.validate() && imageValid) {
      imageValid = true;
      if (!edit) {
        if (car != null) {
          model?.addCarToList(car!);
        }
        showSnackBar("Car Added");
      } else {
        if (car != null) {
          model?.updateCarFromList(car!);
        }
        showSnackBar("Car Edited");
      }
      model?.saveData();
    }
  }

  _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Delete Car"),
              content: Text("are you sure you want to delete this car?"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Delete'),
                  onPressed: () {
                    model?.deleteCarFromList(car!);
                    model?.saveData();
                    showSnackBar("Car Deleted!");
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.save),
      tooltip: 'Save Car',
      onPressed: () {
        _saveCar();
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    model = Provider.of<DataModel>(context);
    if (!assigned) {
      if (model?.currentCar == null) {
        edit = false;
        car = Car("", 0, "");
      } else {
        edit = true;
        car = model?.currentCar;
      }
      assigned = true;
    }

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
          title: Text((!edit) ? 'Add New Car' : 'Edit Car'),
          actions: (edit
              ? <Widget>[_deleteButton(), _saveButton()]
              : [_saveButton()])),
      body: Align(
        alignment: Alignment.center,
        child: myTabletContainer(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              // physics:
              //     BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                header("Car Details"),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter car name";
                    }
                    return null;
                  },
                  initialValue: car?.name,
                  onChanged: (text) {
                    car?.name = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Car Name',
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter kilometers driven";
                    } else if (value != null &&
                        int.tryParse(value.replaceAll(",", "")) == null) {
                      return "Please enter a number";
                    }
                    return null;
                  },
                  initialValue: car?.kilos.toString(),
                  onChanged: (text) {
                    car?.kilos = int.tryParse(text) ?? 0;
                  },
                  decoration: InputDecoration(
                    labelText: 'Kilometers Driven',
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.speed,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("Click to choose an image"),
                    onPressed: () {
                      _showPicker(context);
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: CarImage(carImage: car?.image),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
