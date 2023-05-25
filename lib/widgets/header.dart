import 'package:flutter/material.dart';

Widget header(String title) {
  return Builder(
    builder: (context) {
      return Column(
        children: [
          ListTile(
            tileColor: Theme.of(context).canvasColor,
            visualDensity: VisualDensity.compact,
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
            height: 2,
            thickness: 1,
          )
        ],
      );
    },
  );
}
