import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Data/localStorage.dart';
import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../widgets/carImage.dart';
import '../widgets/header.dart';
import '../widgets/snackBar.dart';

class CarAddPage extends StatefulWidget {
  const CarAddPage({super.key, required this.car});
  final Car? car;
  @override
  State<CarAddPage> createState() => _CarAddPageState();
}

class _CarAddPageState extends State<CarAddPage> {
  late Car car;
  DataModel? model;
  bool edit = false;
  final _formKey = GlobalKey<FormState>();

  ImagePicker _picker = ImagePicker();
  bool imageValid = true;

  @override
  void initState() {
    super.initState();
    if (widget.car == null) {
      edit = false;
      car = Car("", 0, "");
    } else {
      edit = true;
      car = widget.car!;
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _getCarImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
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

  void _getCarImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      setState(() {
        car.carImage(Utility.base64String(image.readAsBytesSync()));
      });
    }
  }

  bool _saveCar() {
    imageValid = car.imageBytes != "";
    if (_formKey.currentState!.validate() && imageValid) {
      if (!edit) {
        model?.addCarToList(car);
        showSnackBar("Car Added");
      } else {
        model?.updateCarFromList(car);
        showSnackBar("Car Edited");
      }
      model?.saveData();
      return true;
    } else {
      return false;
    }
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.save),
      tooltip: 'Save Car',
      onPressed: () {
        if (_saveCar()) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Delete Car',
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Delete Car"),
                  content: Text("are you sure you want to delete this car?"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () {
                        model?.deleteCarFromList(car);
                        model?.saveData();
                        showSnackBar("Car Deleted!");
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<DataModel>(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
        title: Text(edit ? 'Edit Car' : 'Add New Car'),
        actions: edit
            ? <Widget>[_deleteButton(), _saveButton()]
            : <Widget>[_saveButton()],
      ),
      body: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                header("Car Details"),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter car name";
                    }
                    return null;
                  },
                  initialValue: car.name,
                  onChanged: (text) {
                    car.name = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Car Name',
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
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
                  initialValue: car.kilos.toString(),
                  onChanged: (text) {
                    car.kilos = int.tryParse(text) ?? 0;
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
                  height: 16.0,
                ),
                FilledButton.tonalIcon(
                  icon: Icon(Icons.image),
                  label: Text("Click to choose an image"),
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  width: double.infinity,
                  child: CarImage(carImage: car.image),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
