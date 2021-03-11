class ServiceType {
  int id;
  String name;

  ServiceType(this.name);

  ServiceType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
  };

  @override
  String toString() {
    return 'ServiceType{id: $id, name: $name}';
  }
}

// class ServiceTypeList {
//   const ServiceTypeList();
//   static Map<int, ServiceType> serviceMap = new Map<int, ServiceType>();
//   static int lastTypeIndex;
//
//   void addServiceType(ServiceType type) {
//     if (lastTypeIndex == null) {
//       lastTypeIndex = 0;
//     } else {
//       lastTypeIndex+= 1;
//     }
//     type.id = lastTypeIndex;
//     serviceMap[type.id] = type;
//   }
//
//   int getTypeMapSize() {
//     return serviceMap.length;
//   }
// }