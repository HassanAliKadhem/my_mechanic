import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Data/service.dart';
import '../Data/dataModel.dart';
import '../widgets/myLayoutBuilder.dart';
import '../widgets/header.dart';
import '../widgets/snackBar.dart';

class CarServiceAdd {
  // static Service service;
  // static Car car;

  // void addFields(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
  //     return CarServiceRow();
  //   }));
  // }

  Widget carServiceAddPage() {
    return CarServiceRow();
  }
}

class CarServiceRow extends StatefulWidget {
  @override
  State<CarServiceRow> createState() => _CarServiceRowState();
}

class _CarServiceRowState extends State<CarServiceRow> {
  DataModel model;
  EdgeInsets _paddingInsets = const EdgeInsets.all(8.0);
  bool edit;
  Service service;
  bool assigned;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _serviceTypeCont = TextEditingController();
  TextEditingController _serviceDateCont = TextEditingController();
  TextEditingController _serviceNextDateCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    assigned = false;
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<DataModel>(context);
    if (!assigned) {
      if (model.currentService == null) {
        edit = false;
        service = Service(
            "",
            model.currentCar.id,
            model.getServiceTypeMap().values.first,
            0.0,
            "",
            DateTime.now(),
            DateTime.now().add((new Duration(days: 1))),
            false);
        _serviceTypeCont.text = model.getServiceTypeMap().values.first.name;
      } else {
        edit = true;
        service = model.currentService;
        _serviceTypeCont.text =
            model.getServiceTypeMap()[service.serviceType.id].name;
        _serviceDateCont.text =
            model.currentService.serviceDate.toString().split(" ")[0];
        _serviceNextDateCont.text =
            (model.currentService.nextServiceDate != null)
                ? model.currentService.nextServiceDate.toString().split(" ")[0]
                : "";
      }
      assigned = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (edit) ? 'Edit Service' : 'Add Service',
        ),
        actions:
            (edit) ? <Widget>[_deleteButton(), _saveButton()] : [_saveButton()],
      ),
      body: _buildServiceRows(),
    );
  }

  Widget _buildServiceRows() {
    return Form(
      key: _formKey,
      child: Align(
        alignment: Alignment.center,
        child: myTabletContainer(
          child: ListView(
            padding: _paddingInsets,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              header("Service Details"),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter service name";
                  }
                  return null;
                },
                initialValue: service.name,
                onChanged: (text) {
                  service.name = text;
                },
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.edit,
                  ),
                ),
              ),
              _mySizedBox(),
              TextFormField(
                readOnly: true,
                controller: _serviceTypeCont,
                onTap: () {
                  _serviceTypeBottomSheet(context);
                },
                decoration: InputDecoration(
                  // labelText: 'Car Image',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home_repair_service),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
              _mySizedBox(),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter service cost";
                  } else if (double.tryParse(value) == null) {
                    return "Please enter a number";
                  }
                  return null;
                },
                initialValue:
                    (service.price != 0) ? service.price.toString() : "",
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  service.price = double.tryParse(text);
                },
                decoration: InputDecoration(
                  labelText: 'Service Cost',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.attach_money,
                  ),
                ),
              ),
              _mySizedBox(),
              header("Dates"),
              TextFormField(
                readOnly: true,
                controller: _serviceDateCont,
                onTap: () {
                  _selectDate(context);
                },
                decoration: InputDecoration(
                  labelText: "Service Date",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              // Card(
              //   elevation: 0,
              //   margin: _paddingInsets,
              //   shape: OutlineInputBorder(
              //       borderSide:
              //           BorderSide(color: Theme.of(context).disabledColor)),
              //   child: ListTile(
              //     contentPadding: EdgeInsets.only(left: 12),
              //     minLeadingWidth: 0,
              //     title: Text("Service Date"),
              //     subtitle: Text(
              //         service.serviceDate.toLocal().toString().split(" ")[0]),
              //     leading: Icon(Icons.calendar_today_outlined),
              //     onTap: () {
              //       _selectDate(context);
              //     },
              //   ),
              // ),
              _mySizedBox(),
              // Card(
              //   elevation: 0,
              //   margin: _paddingInsets,
              //   shape: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           color: service.remind
              //               ? Theme.of(context).accentColor
              //               : Theme.of(context).disabledColor)),
              //   child: ListTile(
              //     contentPadding: EdgeInsets.only(left: 12),
              //     minLeadingWidth: 0,
              //     title: Text("Remind for future events"),
              //     leading: Icon(
              //       service.remind
              //           ? Icons.notifications_on_rounded
              //           : Icons.notifications_off_outlined,
              //       color: service.remind
              //           ? Theme.of(context).accentColor
              //           : Theme.of(context).disabledColor,
              //     ),
              //     onTap: () {
              //       setState(() {
              //         service.remind = !service.remind;
              //       });
              //     },
              //     trailing: Switch(
              //       value: service.remind,
              //       activeColor: service.remind
              //           ? Theme.of(context).accentColor
              //           : Theme.of(context).disabledColor,
              //       onChanged: (value) {
              //         setState(() {
              //           service.remind = value;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              TextFormField(
                readOnly: true,
                onTap: () {
                  setState(() {
                    service.remind = !service.remind;
                  });
                },
                initialValue: "Remind for future events",
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Switch(
                    value: service.remind,
                    activeColor: service.remind
                        ? Theme.of(context).accentColor
                        : Theme.of(context).disabledColor,
                    onChanged: (value) {
                      setState(() {
                        service.remind = !service.remind;
                      });
                    },
                  ),
                  prefixIcon: Icon(
                    service.remind
                        ? Icons.notifications_on_rounded
                        : Icons.notifications_off_outlined,
                    color: service.remind
                        ? Theme.of(context).accentColor
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ),
              _mySizedBox(),
              // OpacityAnimatedWidget.tween(
              //   opacityEnabled: 1, //define start value
              //   opacityDisabled: 0, //and end value
              //   duration: Duration(milliseconds: 250),
              //   enabled: service.remind, //bind with the boolean
              //   child: Card(
              //     elevation: 0,
              //     margin: _paddingInsets,
              //     shape: OutlineInputBorder(
              //         borderSide:
              //             BorderSide(color: Theme.of(context).disabledColor)),
              //     child: ListTile(
              //       contentPadding: EdgeInsets.only(left: 12),
              //       minLeadingWidth: 0,
              //       title: Text("Date"),
              //       subtitle: Text(service.nextServiceDate
              //           .toLocal()
              //           .toString()
              //           .split(" ")[0]),
              //       leading: Icon(Icons.calendar_today),
              //       onTap: () {
              //         _selectNextDate(context);
              //       },
              //       enabled: service.remind,
              //     ),
              //   ),
              // ),
              AnimatedOpacity(
                opacity: service.remind ? 1 : 0,
                duration: Duration(milliseconds: 250),
                child: TextFormField(
                  readOnly: true,
                  controller: _serviceNextDateCont,
                  onTap: () {
                    if (service.remind) {
                      _selectNextDate(context);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Reminder Date",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mySizedBox() {
    return SizedBox(
      height: 8,
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: service.serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != service.serviceDate)
      //return selectedDate;
      setState(() {
        _serviceDateCont.text = picked.toLocal().toString().split(" ")[0];
        service.serviceDate = picked;
      });
  }

  _selectNextDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: service.nextServiceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != service.nextServiceDate)
      //return selectedDate;
      setState(() {
        _serviceNextDateCont.text = picked.toLocal().toString().split(" ")[0];
        service.nextServiceDate = picked;
      });
  }

  _saveService() {
    // List<String> errorList = <String>[];
    //
    // if (service.name == null ||
    //     service.name.length == 0) {
    //   errorList.add("Name not entered");
    // }
    //
    // if (service.price == null ||
    //     service.price.toString().length == 0) {
    //   errorList.add("Price not entered");
    // }
    //
    // // if (_ServiceTypeItem().dropdownValue == null) {
    // //   errorList.add("service type not chosen");
    // // }
    //
    // if (service.serviceDate == null) {
    //   errorList.add("Service date not chosen");
    // }
    //
    // if (service.nextServiceDate == null) {
    //   errorList.add("Service date not chosen");
    // }
    //
    // if (errorList.length == 0) {
    if (_formKey.currentState.validate()) {
      // _ServiceTypeItem().serviceMap.forEach((key, serviceValue) {
      //   if (serviceValue.name == _ServiceTypeItem().dropdownValue) {
      //     DataModel sd = new DataModel();

      // sd.getCarMap().forEach((key, carValue) {
      //   if (carValue.id == CarServiceAdd.car.id) {
      if (edit) {
        // DataModel().getCarMap()[CarServiceAdd.car.id].serviceList.addServiceToList(CarServiceAdd.service);
        model.updateServiceFromList(service);
        setState(() {
          edit = true;
        });

        showSnackBar("Service Updated");
        // Navigator.of(context).pop();
      } else {
        // DataModel().getCarMap()[CarServiceAdd.car.id].serviceList.updateServiceFromList(CarServiceAdd.service);
        model.addServiceToList(service);
        showSnackBar("Service Added");
        // Navigator.of(context).pop();
      }
      model.saveData();
      // }
      // });
      //   }
      // });
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
  //     context: context,
  //     builder: (_) => new AlertDialog(
  //       title: new Text("Missing Fields"),
  //       content: Text(errorMessage),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text('Ok'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
    model.getServiceTypeMap().forEach(
      (key, value) {
        _serviceTypesWidgets.add(ListTile(
          title: Text(value.name),
          onTap: () {
            Navigator.pop(context);
            setState(() {
              _serviceTypeCont.text = value.name;
              service.serviceType = value;
            });
          },
          trailing: (service.serviceType == value) ? Icon(Icons.check) : null,
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
              // DataModel sd = new DataModel();
              // sd.getCarMap().forEach((key, value) {
              //   if (value.name == CarServiceAdd.car.name) {
              //     value.serviceList
              //         .deleteServiceFromList(CarServiceAdd.service);
              //   }
              // });
              model.deleteServiceFromList(service);
              showSnackBar("Service Deleted");
              model.saveData();
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
}
