import 'package:flutter/material.dart';
import 'package:my_mechanic/Data/config.dart';
import 'package:my_mechanic/Data/serviceType.dart';
import 'package:provider/provider.dart';

import '../Data/car.dart';
import '../Data/service.dart';
import '../Data/dataModel.dart';
import '../widgets/dateFormat.dart';
import '../widgets/header.dart';
import '../widgets/snackBar.dart';

class CarServiceAdd extends StatefulWidget {
  const CarServiceAdd({super.key, required this.car, required this.service});
  final Car car;
  final Service? service;

  @override
  State<CarServiceAdd> createState() => _CarServiceAddState();
}

class _CarServiceAddState extends State<CarServiceAdd> {
  late DataModel model;
  late Service service;
  bool edit = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _serviceTypeCont = TextEditingController();
  TextEditingController _serviceDateCont = TextEditingController();
  TextEditingController _serviceNextDateCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.service == null) {
      edit = false;
      service = Service(
        "",
        widget.car.id!,
        context.read<DataModel>().getServiceTypeMap().values.first,
        0.0,
        "",
        DateTime.now(),
        DateTime.now().add((new Duration(days: 1))),
        false,
      );
    } else {
      edit = true;
      service = widget.service!;
    }
    _serviceTypeCont.text = service.serviceType.name;
    _serviceDateCont.text = FormatDate(service.serviceDate);
    _serviceNextDateCont.text = FormatDate(service.nextServiceDate);
  }

  Widget _mySizedBox() {
    return SizedBox(
      height: 16.0,
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: service.serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != service.serviceDate)
      //return selectedDate;
      setState(() {
        _serviceDateCont.text = FormatDate(picked);
        service.serviceDate = picked;
      });
  }

  _selectNextDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: service.nextServiceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != service.nextServiceDate)
      //return selectedDate;
      setState(() {
        _serviceNextDateCont.text = FormatDate(picked);
        service.nextServiceDate = picked;
      });
  }

  _saveService(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (edit) {
        model.updateServiceFromList(service);
        // setState(() {
        //   edit = true;
        // });
        showSnackBar("Service Updated");
      } else {
        model.addServiceToList(service);
        showSnackBar("Service Added");
      }
      model.saveData();
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> _serviceTypeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(children: _serviceTypeListTiles());
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
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () {
              model.deleteServiceFromList(service);
              showSnackBar("Service Deleted");
              model.saveData();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.save),
      tooltip: 'Save New Service',
      onPressed: () {
        _saveService(context);
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
    model = Provider.of<DataModel>(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
        title: Text(
          (edit) ? 'Edit Service' : 'Add Service',
        ),
        actions: (edit)
            ? <Widget>[_deleteButton(), _saveButton(context)]
            : [_saveButton(context)],
      ),
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                header("Service Details"),
                _mySizedBox(),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isEmpty) {
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
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                _mySizedBox(),
                DropdownButtonFormField<ServiceType>(
                  value: service.serviceType,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home_repair_service),
                  ),
                  items: model
                      .getServiceTypeMap()
                      .values
                      .map((e) => DropdownMenuItem<ServiceType>(
                            child: Text(e.name),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        service.serviceType = value;
                      });
                    }
                  },
                ),
                _mySizedBox(),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter service cost";
                    } else if (value != null &&
                        double.tryParse(value) == null) {
                      return "Please enter a number";
                    }
                    return null;
                  },
                  initialValue:
                      (service.price != 0) ? service.price.toString() : "",
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    service.price = double.tryParse(text) ?? 0;
                  },
                  decoration: InputDecoration(
                    labelText: 'Service Cost',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FittedBox(
                        child: Text(
                          context.watch<Config>().currency.padRight(2, " "),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                header("Dates"),
                _mySizedBox(),
                TextFormField(
                  readOnly: true,
                  controller: _serviceDateCont,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: "Service Date",
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                _mySizedBox(),
                // TextFormField(
                //   readOnly: true,
                //   onTap: () {
                //     setState(() {
                //       service.remind = !service.remind;
                //     });
                //   },
                //   initialValue: "Remind for future events",
                //   decoration: InputDecoration(
                //     suffixIcon: Switch(
                //       value: service.remind,
                //       activeColor: service.remind
                //           ? Theme.of(context).colorScheme.secondary
                //           : Theme.of(context).disabledColor,
                //       onChanged: (value) {
                //         setState(() {
                //           service.remind = !service.remind;
                //         });
                //       },
                //     ),
                //     prefixIcon: Icon(
                //       service.remind
                //           ? Icons.notifications_on_rounded
                //           : Icons.notifications_off_outlined,
                //       color: service.remind
                //           ? Theme.of(context).colorScheme.secondary
                //           : Theme.of(context).disabledColor,
                //     ),
                //   ),
                // ),
                SwitchListTile(
                  secondary: Icon(
                    service.remind
                        ? Icons.notifications_on_rounded
                        : Icons.notifications_off_outlined,
                    color: service.remind
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).disabledColor,
                  ),
                  title: Text("Remind ?"),
                  value: service.remind,
                  onChanged: (value) {
                    setState(() {
                      service.remind = value;
                    });
                  },
                ),
                _mySizedBox(),
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
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
