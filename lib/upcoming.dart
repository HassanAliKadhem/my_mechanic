import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Data/dataModel.dart';
import 'Data/service.dart';
import 'Ui/Common.dart';

void upcoming(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('UpComing'),
        ),
        body: UpcomingList(),
      );
    },
  ));
}

class UpcomingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Service> serviceMap = Map<int, Service>();

    DataModel().getCarMap().forEach((key, carValue) {
      carValue.serviceList.serviceMap.forEach((key2, serviceValue) {
        if (serviceValue.remind) {
          serviceMap[serviceMap.length] = serviceValue;
        }
      });
    });

    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: serviceMap.length,
      itemBuilder: (context, index) {
        return ServiceTile(serviceMap[index]);
      },
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    );
  }
}

class ServiceTile extends StatelessWidget {
  Service service1;

  ServiceTile(Service service) {
    service1 = service;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        service1.name,
      ),
      trailing: Text("\$ " + service1.price.toString()),
      subtitle: RichText(
        text: TextSpan(
          style: appTheme.textTheme.bodyText2
              .copyWith(color: appTheme.disabledColor),
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child:
                    Icon(Icons.calendar_today, color: appTheme.disabledColor),
              ),
            ),
            TextSpan(
                text: service1.serviceDate.toLocal().toString().split(" ")[0]),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(Icons.home_repair_service,
                    color: appTheme.disabledColor),
              ),
            ),
            TextSpan(text: service1.serviceType.name),
          ],
        ),
      ),
    );
  }
}
