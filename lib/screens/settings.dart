import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../theme/theme.dart';
import '../Data/dataModel.dart';
import '../widgets/header.dart';
import '../widgets/myLayoutBuilder.dart';
import '../widgets/snackBar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentTab = 0;

  List<Widget> _tabList = [
    DebuggingOptions(),
    AboutOptions(),
  ];

  List<String> _tabTitleList = [
    "Debugging Options",
    "About",
  ];

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
      body: SafeArea(
        child: MyLayoutBuilderPages(
          mobileLayout: ListView.builder(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: _tabTitleList.length,
            itemBuilder: (context, index) {
              return StickyHeader(
                header: header(_tabTitleList[index]),
                content: _tabList[index],
              );
            },
          ),
          tabletLayout: Row(
            children: [
              SizedBox(
                width: listWidth,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: _tabTitleList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      selected: (_currentTab == index),
                      title: Text(_tabTitleList[index]),
                      onTap: () {
                        setState(() {
                          _currentTab = index;
                        });
                      },
                    );
                  },
                ),
              ),
              myVerticalDivider,
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    MyPageAnimation(
                      child: _tabList[_currentTab],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DebuggingOptions extends StatelessWidget {
  const DebuggingOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Load sample data"),
      leading: Icon(
        Icons.refresh,
      ),
      onTap: () {
        Provider.of<DataModel>(context, listen: false).loadSampleData();
        // DataModel().loadSampleData();
        showSnackBar("Sample data loading");
      },
    );
  }
}

class AboutOptions extends StatelessWidget {
  const AboutOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
