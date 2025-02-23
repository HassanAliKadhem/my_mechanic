import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/config.dart';
import '../Data/dataModel.dart';

class UpcomingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upcoming Services")),
      body: Consumer<DataModel>(
        builder: (context, data, child) {
          String currency = context.read<Config>().currency;
          return ListView(
            children:
                data
                    .getUpcomingServiceMap()
                    .entries
                    .map(
                      (entry) => ListTile(
                        title: Text(entry.value.name),
                        trailing: Text(
                          currency + " " + entry.value.price.toString(),
                        ),
                        subtitle: Text(
                          "📅 " +
                              entry.value.formattedServiceDate +
                              " 🛠️ " +
                              entry.value.serviceType.name,
                        ),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }
}
