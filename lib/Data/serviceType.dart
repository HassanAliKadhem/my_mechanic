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

class ServiceTypeList {
  const ServiceTypeList();
  static Map<int, ServiceType> serviceMap = new Map<int, ServiceType>();
  static int lastIndex;

  int generateNewIndex() {
    if (lastIndex == null) {
      lastIndex = 0;
    } else {
      lastIndex+= 1;
    }
    return lastIndex;
  }

  void addServiceType(ServiceType type) {
    type.id = generateNewIndex();
    serviceMap[type.id] = type;
  }

  int getMapSize() {
    return serviceMap.length;
  }
}