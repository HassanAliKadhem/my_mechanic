import 'dart:developer';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_mechanic/main.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'Data/car.dart';
import 'Data/service.dart';
import 'Data/dataModel.dart';
import 'Data/serviceType.dart';
import 'Ui/Common.dart';

class CarServiceAdd {
  static Service service;
  static Car car;

  void addFields(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CarServiceRow();
    }));
  }

  Widget carServiceAddPage() {
    return CarServiceRow();
  }
}

class CarServiceRow extends StatefulWidget {
  @override
  State<CarServiceRow> createState() => _CarServiceRowState();
}

class _CarServiceRowState extends State<CarServiceRow> {
  DataModel dataModel = DataModel();
  EdgeInsets _paddingInsets = const EdgeInsets.all(8.0);
  bool edit;

  Widget _buildServiceRows() {
    if (CarServiceAdd.service == null) {
      edit = true;
      CarServiceAdd.service = Service(
          "",
          ServiceTypeList.serviceMap[0],
          0.0,
          "",
          DateTime.now(),
          DateTime.now().add((new Duration(days: 1))),
          false);
    } else {
      edit = false;
    }

    return ListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: <Widget>[
        StickyHeader(
          header: header("Service Details"),
          content: Column(
            children: [
              Padding(
                padding: _paddingInsets,
                child: TextFormField(
                  initialValue: CarServiceAdd.service.name,
                  onChanged: (text) {
                    CarServiceAdd.service.name = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 0,
                margin: _paddingInsets,
                shape: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).disabledColor)),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12),
                  minLeadingWidth: 0,
                  onTap: () {
                    _serviceTypeBottomSheet(context);
                  },
                  title: Text(dataModel
                      .getServiceTypeMap()[CarServiceAdd.service.serviceType.id]
                      .name),
                  leading: Icon(Icons.home_repair_service),
                  trailing: Icon(Icons.arrow_drop_down),
                ),
              ),
              Padding(
                padding: _paddingInsets,
                child: TextFormField(
                  initialValue: (CarServiceAdd.service.price != 0)
                      ? CarServiceAdd.service.price.toString()
                      : "",
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    CarServiceAdd.service.price = double.tryParse(text);
                  },
                  decoration: InputDecoration(
                    labelText: 'Service Cost',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.attach_money,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        StickyHeader(
          header: header("Dates"),
          content: Column(
            children: [
              Card(
                elevation: 0,
                margin: _paddingInsets,
                shape: OutlineInputBorder(
                    borderSide: BorderSide(color: appTheme.disabledColor)),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12),
                  minLeadingWidth: 0,
                  title: Text("Service Date"),
                  subtitle: Text(CarServiceAdd.service.serviceDate
                      .toLocal()
                      .toString()
                      .split(" ")[0]),
                  leading: Icon(Icons.calendar_today_outlined),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
              ),
              Card(
                elevation: 0,
                margin: _paddingInsets,
                shape: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CarServiceAdd.service.remind
                            ? appTheme.accentColor
                            : appTheme.disabledColor)),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12),
                  minLeadingWidth: 0,
                  title: Text("Remind for future events"),
                  leading: Icon(
                    CarServiceAdd.service.remind
                        ? Icons.notifications_on_rounded
                        : Icons.notifications_off_outlined,
                    color: CarServiceAdd.service.remind
                        ? appTheme.accentColor
                        : appTheme.disabledColor,
                  ),
                  onTap: () {
                    setState(() {
                      CarServiceAdd.service.remind =
                          !CarServiceAdd.service.remind;
                    });
                  },
                  trailing: Switch(
                    value: CarServiceAdd.service.remind,
                    onChanged: (val) {
                      setState(() {
                        CarServiceAdd.service.remind = val;
                      });
                    },
                  ),
                ),
              ),
              OpacityAnimatedWidget.tween(
                opacityEnabled: 1, //define start value
                opacityDisabled: 0, //and end value
                duration: Duration(milliseconds: 250),
                enabled: CarServiceAdd.service.remind, //bind with the boolean
                child: Card(
                  elevation: 0,
                  margin: _paddingInsets,
                  shape: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor)),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 12),
                    minLeadingWidth: 0,
                    title: Text("Date"),
                    subtitle: Text(CarServiceAdd.service.nextServiceDate
                        .toLocal()
                        .toString()
                        .split(" ")[0]),
                    leading: Icon(Icons.calendar_today),
                    onTap: () {
                      _selectNextDate(context);
                    },
                    enabled: CarServiceAdd.service.remind,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: CarServiceAdd.service.serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != CarServiceAdd.service.serviceDate)
      //return selectedDate;
      setState(() {
        CarServiceAdd.service.serviceDate = picked;
      });
  }

  _selectNextDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: CarServiceAdd.service.nextServiceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != CarServiceAdd.service.nextServiceDate)
      //return selectedDate;
      setState(() {
        CarServiceAdd.service.nextServiceDate = picked;
      });
  }

  _saveService() {
    List<String> errorList = <String>[];
    if (CarServiceAdd.service.name == null ||
        CarServiceAdd.service.name.length == 0) {
      errorList.add("Name not entered");
    }

    if (CarServiceAdd.service.price == null ||
        CarServiceAdd.service.price.toString().length == 0) {
      errorList.add("Price not entered");
    }

    // if (_ServiceTypeItem().dropdownValue == null) {
    //   errorList.add("service type not chosen");
    // }

    if (CarServiceAdd.service.serviceDate == null) {
      errorList.add("Service date not chosen");
    }

    if (CarServiceAdd.service.nextServiceDate == null) {
      errorList.add("Service date not chosen");
    }

    if (errorList.length == 0) {
      // _ServiceTypeItem().serviceMap.forEach((key, serviceValue) {
      //   if (serviceValue.name == _ServiceTypeItem().dropdownValue) {
      //     DataModel sd = new DataModel();

          // sd.getCarMap().forEach((key, carValue) {
          //   if (carValue.id == CarServiceAdd.car.id) {
              if (edit) {
                DataModel().getCarMap()[CarServiceAdd.car.id].serviceList.addServiceToList(CarServiceAdd.service);
                DataModel.saveData();

                setState(() {
                  edit = true;
                });

                showSnackBar("Service Added");
                // Navigator.of(context).pop();
              } else {
                DataModel().getCarMap()[CarServiceAdd.car.id].serviceList.updateServiceFromList(CarServiceAdd.service);
                DataModel.saveData();
                showSnackBar("Service Edited");
                // Navigator.of(context).pop();
              }
            // }
          // });
      //   }
      // });
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
      builder: (_) => new AlertDialog(
        title: new Text("Missing Fields"),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> _serviceTypeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(children: _serviceTypeListTiles());
      },
    );
  }

  List<Widget> _serviceTypeListTiles() {
    List<Widget> _serviceTypesWidgets = <Widget>[];
    dataModel.getServiceTypeMap().forEach(
      (key, value) {
        _serviceTypesWidgets.add(ListTile(
          title: Text(value.name),
          onTap: () {
            Navigator.pop(context);
            setState(() {
              CarServiceAdd.service.serviceType = value;
            });
          },
          trailing: (CarServiceAdd.service.serviceType == value)
              ? Icon(Icons.check)
              : null,
        ));
      },
    );
    return _serviceTypesWidgets;
  }

  _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Delete Service"),
        content: Text("are you sure you want to delete this service?"),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () {
              DataModel sd = new DataModel();
              sd.getCarMap().forEach((key, value) {
                if (value.name == CarServiceAdd.car.name) {
                  value.serviceList
                      .deleteServiceFromList(CarServiceAdd.service);
                }
              });
              showSnackBar("Service Deleted");
              DataModel.saveData();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(Icons.save),
      tooltip: 'Save New Service',
      onPressed: () {
        _saveService();
      },
    );
  }

  Widget _deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Delete Service',
      onPressed: () {
        _showDeleteDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (CarServiceAdd.service == null) ? 'Add Service' : 'Edit Service',
        ),
        actions: (CarServiceAdd.service != null)
            ? <Widget>[_deleteButton(), _saveButton()]
            : [_saveButton()],
      ),
      body: _buildServiceRows(),
    );
  }
}