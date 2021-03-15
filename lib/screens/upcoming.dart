import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../theme/theme.dart';
import '../Data/dataModel.dart';
// import '../Data/service.dart';
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
      appBar: AppBar(
        title: Text(
          "Upcoming Service List",
          // style: TextStyle(color: appTheme.primaryColor),
        ),
      ),
      body: SafeArea(
        child: Consumer<DataModel>(
          builder: (context, data, child) {
            data.getUpcomingServiceMap().forEach((key, value) {
              serviceTileListDivided.add(ListTile(
                title: Text(
                  value.name,
                ),
                trailing: Text("\$ " + value.price.toString()),
                subtitle: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2
                        .copyWith(color: Theme.of(context).disabledColor),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.calendar_today,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      TextSpan(
                          text:
                              value.serviceDate.toLocal().toString().split(" ")[0]),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.home_repair_service,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      TextSpan(text: value.serviceType.name),
                    ],
                  ),
                ),
              ));
              // serviceTileListDivided.add(Divider());
            });
            return ListView(
              physics:
                  BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                StickyHeader(
                  header: header(
                      "Upcoming: " + data.getUpcomingServiceMapSize().toString()),
                  content: Column(
                    children: serviceTileListDivided,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}