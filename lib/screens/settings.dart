import 'package:flutter/material.dart';
import 'package:my_mechanic/widgets/myPageAnimation.dart';
import 'package:provider/provider.dart';

import '../Data/config.dart';
import '../Data/dataModel.dart';
import '../widgets/verticalDivider.dart';
import '../widgets/snackBar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentTab = 0;
  late bool isSmall;

  List<Widget> _tabList = [Options(), DebuggingOptions(), AboutOptions()];

  List<String> _tabTitleList = ["Options", "Debugging Options", "About"];

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.sizeOf(context).shortestSide < 600;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Settings Page"),
        // title: Text("Settings Page"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: _tabTitleList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      selected: (_currentTab == index),
                      title: Text(_tabTitleList[index]),
                      onTap: () {
                        setState(() {
                          _currentTab = index;
                        });
                      },
                    ),
                    isSmall ? _tabList[index] : Container(),
                  ],
                );
              },
            ),
          ),
          isSmall ? Container() : myVerticalDivider,
          isSmall
              ? Container()
              : Expanded(
                flex: 5,
                child: ListView(
                  children: [MyPageAnimation(child: _tabList[_currentTab])],
                ),
              ),
        ],
      ),
    );
  }
}

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Consumer<Config>(
        builder: (context, config, child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ListTile(
                    title: Text("Dark Mode"),
                    leading: Icon(Icons.dark_mode),
                    trailing: DropdownButton(
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      value: config.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => config.setTheme(value));
                        }
                      },
                      items:
                          themeModesList
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  child: Text(
                                    item[0].toUpperCase() + item.substring(1),
                                  ),
                                  value: item,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  ListTile(
                    title: Text("Currency"),
                    leading: Icon(Icons.money),
                    trailing: DropdownButton(
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      value: config.currency,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => config.setCurrency(value));
                        }
                      },
                      items:
                          currencyList
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  child: Text(item),
                                  value: item,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
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
          leading: Icon(Icons.refresh),
          onTap: () {
            Provider.of<DataModel>(context, listen: false).loadSampleData();
            // DataModel().loadSampleData();
            showSnackBar("Sample data loading");
          },
        ),
        ListTile(
          title: Text("Clear data"),
          leading: Icon(Icons.delete),
          onTap: () {
            Provider.of<DataModel>(context, listen: false).clearData();
            // DataModel().loadSampleData();
            showSnackBar("Cleared Data");
          },
        ),
        ListTile(
          title: Text("Save data"),
          leading: Icon(Icons.save),
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
          leading: Icon(Icons.person),
          title: Text("Developer"),
          subtitle: Text("Hasan Kadhem"),
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text("Made With"),
          subtitle: Text("Flutter"),
        ),
        AboutListTile(
          applicationVersion: "Version: 1.1.1",
          applicationIcon: Image.asset(
            "images/icon.webp",
            width: 40,
            color: Theme.of(context).iconTheme.color,
          ),
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
