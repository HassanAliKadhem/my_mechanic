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

    return Consumer<DataModel>(
      builder: (context, data, child) {
        // print(data.serviceMap);
        data.getUpcomingServiceMap().forEach((key, value) {
          serviceTileListDivided.add(ListTile(
            title: Text(
              value.name,
            ),
            trailing: Text("\$ " + value.price.toString()),
            subtitle: RichText(
              text: TextSpan(
                style: appTheme.textTheme.bodyText2
                    .copyWith(color: appTheme.disabledColor),
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(Icons.calendar_today,
                          color: appTheme.disabledColor),
                    ),
                  ),
                  TextSpan(
                      text:
                          value.serviceDate.toLocal().toString().split(" ")[0]),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.home_repair_service,
                          color: appTheme.disabledColor),
                    ),
                  ),
                  TextSpan(text: value.serviceType.name),
                ],
              ),
            ),
          ));
          serviceTileListDivided.add(Divider());
        });
        // return StickyHeader(
        //   header: header(
        //       "Upcoming: " + data.getUpcomingServiceMapSize().toString()),
        //   content: ListView(
        //     physics:
        //         BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        //     children: serviceTileListDivided,
        //   ),
        // );
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
    );
  }
}

// class ServiceTile extends StatelessWidget {
//   Service service1;
//
//   ServiceTile(Service service) {
//     service1 = service;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         service1.name,
//       ),
//       trailing: Text("\$ " + service1.price.toString()),
//       subtitle: RichText(
//         text: TextSpan(
//           style: appTheme.textTheme.bodyText2
//               .copyWith(color: appTheme.disabledColor),
//           children: [
//             WidgetSpan(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 4.0),
//                 child:
//                     Icon(Icons.calendar_today, color: appTheme.disabledColor),
//               ),
//             ),
//             TextSpan(
//                 text: service1.serviceDate.toLocal().toString().split(" ")[0]),
//             WidgetSpan(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Icon(Icons.home_repair_service,
//                     color: appTheme.disabledColor),
//               ),
//             ),
//             TextSpan(text: service1.serviceType.name),
//           ],
//         ),
//       ),
//     );
//   }
// }
