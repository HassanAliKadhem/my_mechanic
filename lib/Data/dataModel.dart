import 'package:flutter/material.dart';
import 'package:my_mechanic/Data/car.dart';
import 'package:my_mechanic/Data/service.dart';
import 'package:my_mechanic/Data/serviceType.dart';
import 'package:my_mechanic/Data/localStorage.dart';
import 'package:http/http.dart' as http;

enum SortBy {
  creating,
  services,
  name,
}

const Duration containerTransitionDuration = Duration(milliseconds: 500);

class DataModel {
  static bool loadedData = false;

  loadData() async {
    if (!loadedData) {
      // await loadSampleData();
      await loadDefaultTypes();
      await SharedPrefs.loadData();
      loadedData = true;
    }
  }

  static saveData() async {
    await SharedPrefs.saveData();
  }

  static Image getSampleImage(){
    return Image.asset("images/placeHolder2.webp", fit: BoxFit.cover,);
  }

  static Image getLoadingImage(){
    return Image.asset("images/indicator-large.gif", fit: BoxFit.cover,);
  }

  clearData() {
    CarList.lastIndex = null;
    CarList.carMap.clear();
  }

  loadDefaultTypes() async {
    ServiceTypeList.lastIndex = null;
    ServiceTypeList.serviceMap.clear();
    ServiceType s1 = new ServiceType("Oil Change");
    ServiceTypeList().addServiceType(s1);
    ServiceType s2 = new ServiceType("Brake Change");
    ServiceTypeList().addServiceType(s2);
    ServiceType s3 = new ServiceType("Spark Plugs Change");
    ServiceTypeList().addServiceType(s3);
  }

  loadSampleData() async {
    clearData();

    http.Response imageFile = await http.get("https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Toulousaine_de_l'automobile_-_7425_-_Porsche_911_Carrera_(2011).jpg/1200px-Toulousaine_de_l'automobile_-_7425_-_Porsche_911_Carrera_(2011).jpg");
    // print(Utility.base64String(imageFile.bodyBytes));
    Car c1 = new Car("Porsche 911", 500, Utility.base64String(imageFile.bodyBytes));
    CarList().addCarToList(c1);

    imageFile = await http.get("https://st.motortrend.com/uploads/sites/10/2016/08/2017-Dodge-Viper-GTS-front-three-quarter-in-motion.jpg");
    Car c2 = new Car("Dodge Viper", 900, Utility.base64String(imageFile.bodyBytes));
    CarList().addCarToList(c2);

    imageFile = await http.get("https://i.kinja-img.com/gawker-media/image/upload/s--TWSeA9NH--/c_fill,fl_progressive,g_center,h_900,q_80,w_1600/riufs7rtpk6okzrqiqmy.jpg");
    Car c3 = new Car("Nissan GTR", 1700, Utility.base64String(imageFile.bodyBytes));
    CarList().addCarToList(c3);

    c1.serviceList.addServiceToList(new Service("changed oil and filter", ServiceTypeList.serviceMap[0], 15.0, "", DateTime.now(), DateTime.now().add((new Duration(days: 1))), false));
    c1.serviceList.addServiceToList(new Service("changed Brakes", ServiceTypeList.serviceMap[1], 24.5, "", DateTime.now().add(new Duration(days: 2)), DateTime.now().add((new Duration(days: 3))), true));
  }

  Map<int, Car> getCarMap() {
    return CarList.carMap;
  }

  // Map<int, Service> getServiceMap() {
  //   return ServiceList.serviceMap;
  // }

  Map<int, ServiceType> getServiceTypeMap() {
    return ServiceTypeList.serviceMap;
  }
}
