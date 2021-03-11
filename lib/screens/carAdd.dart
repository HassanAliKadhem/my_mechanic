import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../Data/localStorage.dart';
import '../Data/car.dart';
import '../Data/dataModel.dart';
import '../widgets/header.dart';
import '../widgets/snackBar.dart';

class CarAdd {
  // void addCarPage(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
  //     return CarAddPage();
  //   }));
  // }

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
  DataModel model;
  Car car;
  // String carName;
  // int carKilos;
  // String imageBytes;
  bool edit;
  final _formKey = GlobalKey<FormState>();
  bool imageValid = true;
  bool assigned;

  @override
  void initState() {
    super.initState();
    assigned = false;
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<DataModel>(context);
    if (!assigned) {
      if (model.currentCar == null) {
        edit = false;
        car = Car("", 0, "");
        // carName = car.name;
        // carKilos = car.kilos;
        // imageBytes = car.imageBytes;
      } else {
        edit = true;
        car = model.currentCar;
        // carName = car.name;
        // carKilos = car.kilos;
        // imageBytes = car.imageBytes;
      }
      assigned = true;
    }

    return Scaffold(
      appBar: AppBar(
          title: Text((!edit) ? 'Add Car' : 'Edit Car'),
          actions: (edit
              ? <Widget>[_deleteButton(), _saveButton()]
              : [_saveButton()])),
      body: _buildCarRows(),
    );
  }

  Widget _buildCarRows() {
    // print(car.imageBytes);
    return Form(
      key: _formKey,
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          StickyHeader(
            header: header("Car Details"),
            content: Column(
              children: [
                Padding(
                  padding: _paddingInsets,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter kilometers driven";
                      } else if (int.tryParse(value) == null) {
                        return "Please enter a number";
                      }
                      return null;
                    },
                    initialValue: (car.kilos != 0) ? car.kilos.toString() : "",
                    onChanged: (text) {
                      car.kilos = int.tryParse(text);
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
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card(
                //   elevation: 0,
                //   margin: _paddingInsets,
                //   shape: OutlineInputBorder(
                //       borderSide: BorderSide(
                //           color: (imageValid)
                //               ? appTheme.disabledColor
                //               : appTheme.errorColor)),
                //   child: ListTile(
                //     minLeadingWidth: 30,
                //     title: Text("Click to add an image"),
                //     leading: Icon(Icons.image),
                //     trailing: (imageBytes != null)
                //         ? Utility.imageFromBase64String(imageBytes)
                //         : null,
                //     onTap: () {
                //       _showPicker(context);
                //     },
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 19),
                //   child: Text(
                //     (imageValid) ? "" : "please add a car image",
                //     style: appTheme.textTheme.subtitle2.copyWith(
                //       color: appTheme.errorColor,
                //       fontSize: 13,
                //       fontWeight: FontWeight.w100,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: _paddingInsets,
                  child: TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (car.imageBytes.length == 0) {
                        return "Please add a car image";
                      }
                      return null;
                    },
                    initialValue: (car.imageBytes.length != 0)
                        ? "image added"
                        : "Click to add an image",
                    onTap: () {
                      _showPicker(context);
                    },
                    decoration: InputDecoration(
                      labelText: 'Car Image',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.image,
                      ),
                      suffixIcon: (car.imageBytes.length != 0)
                          ? Image(
                              image:
                                  Utility.imageFromBase64String(car.imageBytes)
                                      .image,
                              fit: BoxFit.fitHeight,
                              height: 15,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      },
    );
  }

  ImagePicker _picker = ImagePicker();

  _imgFromCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    final File image = File(pickedFile.path);

    setState(() {
      car.imageBytes = Utility.base64String(image.readAsBytesSync());
      car.refreshCarData();
    });
  }

  _imgFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File image = File(pickedFile.path);

    setState(() {
      car.imageBytes = Utility.base64String(image.readAsBytesSync());
      car.refreshCarData();
    });
  }

  _saveService() {
    // List<String> errorList = <String>[];
    // if (carName == null) {
    //   errorList.add("Name not entered");
    // } else if (carName.length == 0) {
    //   errorList.add("Name not entered");
    // }
    // if (carKilos == null) {
    //   errorList.add("Price not entered");
    // } else if (carKilos.toString().length == 0) {
    //   errorList.add("Price not entered");
    // }
    if (car.imageBytes == null) {
      setState(() {
        imageValid = false;
      });
    } else {
      setState(() {
        imageValid = true;
      });
    }
    if (_formKey.currentState.validate() && imageValid) {
      imageValid = true;
      // if (errorList.length == 0) {
      if (!edit) {
        // car = new Car(carName, carKilos, imageBytes);
        model.addCarToList(car);
        showSnackBar("Car Added");
      } else {
        // car.name = carName;
        // car.kilos = carKilos;
        // car.imageBytes = imageBytes;
        car.refreshCarData();
        model.updateCarFromList(car);
        showSnackBar("Car Edited");
      }

      // if (!CarAdd.edit) {
      //   CarList().addCarToList(CarAdd.car);
      //   showSnackBar("Car Added");
      //   Navigator.of(context).pop();
      // } else {
      //   CarList().updateCarFromList(CarAdd.car);
      //   showSnackBar("Car Edited");
      //   Navigator.of(context).pop();
      // }
      model.saveData();
    }
    // else {
    //   String errorMessage = "";
    //   errorList.forEach((element) {
    //     errorMessage += element + "\n";
    //   });
    //   _showErrorDialog(errorMessage);
    // }
  }

  // _showErrorDialog(String errorMessage) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => new AlertDialog(
  //             title: new Text("Missing Fields"),
  //             content: Text(errorMessage),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('Ok'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               )
  //             ],
  //           ));
  // }

  _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
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
                    model.deleteCarFromList(car);
                    model.saveData();
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
