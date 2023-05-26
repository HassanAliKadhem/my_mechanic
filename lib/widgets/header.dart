import 'package:flutter/material.dart';

Widget header(String title) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          title: Text(title),
        ),
      ),
      // Divider(
      //   indent: 16,
      //   endIndent: 16,
      //   height: 2,
      //   thickness: 1,
      // )
    ],
  );
}
