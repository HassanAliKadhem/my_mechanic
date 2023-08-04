import 'package:flutter/material.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';

import '../Data/config.dart';
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
    Options(),
    DebuggingOptions(),
    AboutOptions(),
  ];

  List<String> _tabTitleList = [
    "Options",
    "Debugging Options",
    "About",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          "Settings Page",
        ),
      ),
      body: MyLayoutBuilderPages(
        mobileLayout: ListView.builder(
          // physics:
          //     BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: _tabTitleList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                header(_tabTitleList[index]),
                _tabList[index],
              ],
            );
          },
        ),
        tabletLayout: Row(
          children: [
            SizedBox(
              width: listWidth,
              child: ListView.builder(
                // physics: BouncingScrollPhysics(
                //     parent: AlwaysScrollableScrollPhysics()),
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
              //   physics: BouncingScrollPhysics(
              //       parent: AlwaysScrollableScrollPhysics()),
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
    );
  }
}

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (context, config, child) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                ListTile(
                  title: Text("Dark Mode"),
                  leading: Icon(
                    Icons.dark_mode,
                  ),
                  trailing: DropdownButton(
                    value: config.themeMode,
                    onChanged: (value) {
                      setState(() {
                        config.setTheme(value?? themeModesList.first);
                      },);
                    },
                    items: themeModesList.map((item) => DropdownMenuItem<String>(child: Text(item), value: item,)).toList(),
                  ),
                ),
                ListTile(
                  title: Text("Currency"),
                  leading: Icon(
                    Icons.money,
                  ),
                  trailing: DropdownButton(
                    value: config.currency,
                    onChanged: (value) {
                      setState(() {
                        config.setCurrency(value?? currencyList.first);
                      },);
                    },
                    items: currencyList.map((item) => DropdownMenuItem<String>(child: Text(item), value: item,)).toList(),
                  ),
                ),
              ],
            );
          }
        );
      }
    );
  }
}

class DebuggingOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
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
        ListTile(
          title: Text("Clear data"),
          leading: Icon(
            Icons.delete,
          ),
          onTap: () {
            Provider.of<DataModel>(context, listen: false).clearData();
            // DataModel().loadSampleData();
            showSnackBar("Cleared Data");
          },
        ),
        ListTile(
          title: Text("Save data"),
          leading: Icon(
            Icons.save,
          ),
          onTap: () {
            Provider.of<DataModel>(context, listen: false).saveData();
            // DataModel().loadSampleData();
            showSnackBar("saved data");
          },
        ),
      ],
    );
  }
}

class AboutOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
              leading: Icon(
                Icons.person,
              ),
              title: Text("Developer"),
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
          applicationVersion: "Version: 1.0.5",
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
