import 'package:flutter/material.dart';

import '../theme/theme.dart';

Widget header(String title) {
  return PhysicalModel(
    color: Colors.black,
    elevation: appTheme.cardTheme.elevation,
    child:
    ListTile(
      tileColor: Colors.white,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: appTheme.textTheme.bodyText2),
      // subtitle: Divider(),
    ),
  );
}
