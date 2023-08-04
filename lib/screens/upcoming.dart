import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/config.dart';
import '../Data/dataModel.dart';
import '../widgets/header.dart';

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
    List<Widget> serviceTileListDivided = [];  
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Upcoming Service List",
        ),
      ),
      body: Consumer<Config>(
        builder: (context, config, child) {
          return Consumer<DataModel>(
            builder: (context, data, child) {
              serviceTileListDivided.add(header(
                  "Upcoming: " + data.getUpcomingServiceMapSize().toString()));
              data.getUpcomingServiceMap().forEach((key, value) {
                serviceTileListDivided.add(ListTile(
                  title: Text(
                    value.name,
                  ),
                  trailing: Text(config.currency + " " + value.price.toString()),
                  subtitle: Text("📅 " +
                      value.formattedServiceDate +
                      " 🛠️ " +
                      value.serviceType.name),
                ));
                // serviceTileListDivided.add(Divider());
              });
              return ListView(
                // physics:
                //     BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: serviceTileListDivided,
              );
            },
          );
        }
      ),
    );
  }
}
