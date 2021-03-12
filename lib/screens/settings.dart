import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../theme/theme.dart';
import '../Data/dataModel.dart';
import '../widgets/header.dart';
import '../widgets/snackBar.dart';

class SettingsTabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: appTheme.canvasColor,
        title: Text(
          "Settings Page",
          // style: TextStyle(color: appTheme.primaryColor),
        ),
      ),
      body: SettingsList(),
    );
  }
}

class SettingsPhoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: appTheme.canvasColor,
        title: Text(
          "Settings Page",
          // style: TextStyle(color: appTheme.primaryColor),
        ),
      ),
      body: SettingsList(),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          StickyHeader(
            header: header("Sample Data"),
            content: ListTile(
              title: Text("Load sample data"),
              leading: Icon(
                Icons.refresh,
              ),
              onTap: () {
                Provider.of<DataModel>(context, listen: false).loadSampleData();
                // DataModel().loadSampleData();
                showSnackBar("Sample data loading");
              },
            ),
          ),
          StickyHeader(
            header: header("About"),
            content: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.build,
                  ),
                  title: Text("Developers"),
                  subtitle: Text("Hassan Kadhem"),
                ),
                ListTile(
                  leading: FlutterLogo(),
                  title: Text("Made With"),
                  subtitle: Text("Flutter"),
                ),
                AboutListTile(
                  applicationIcon: Image.asset(
                    "images/icon.webp",
                    width: 40,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  applicationVersion: "Version: 1.0.0",
                  icon: Image.asset(
                    "images/icon.webp",
                    width: 26,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
