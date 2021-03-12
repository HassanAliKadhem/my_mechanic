import 'package:flutter/material.dart';

import '../theme/theme.dart';

Widget header(String title) {
  return Builder(
    builder: (context) {
      return ListTile(
        // tileColor: Theme.of(context).canvasColor,
        visualDensity: VisualDensity.compact,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Divider(
          height: 0,
        ),
      );
    },
  );
}
