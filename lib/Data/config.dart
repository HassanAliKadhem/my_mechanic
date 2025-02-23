import 'package:flutter/material.dart';

import 'localStorage.dart';

List<String> currencyList = ["\$", "BD", "£", "€", "₹", "¥"];

List<String> themeModesList = ["auto", "light", "dark"];

Map<String, ThemeMode> themeModesMap = {
  "auto": ThemeMode.system,
  "light": ThemeMode.light,
  "dark": ThemeMode.dark,
};

class Config extends ChangeNotifier {
  bool _isLoaded = false;
  String themeMode;
  String currency;

  Config({this.themeMode = "auto", this.currency = "\$"}) {
    // loadConfig();
  }

  void saveData() async {
    await SharedPrefs.saveConfig(this);
  }

  void loadConfig() async {
    if (!_isLoaded) {
      Config config = await SharedPrefs.loadConfig();
      this.themeMode = config.themeMode;
      this.currency = config.currency;
      _isLoaded = true;
    }
  }

  void setTheme(String newThemeMode) {
    this.themeMode = newThemeMode;
    saveData();
    notifyListeners();
  }

  void setCurrency(String newCurrency) {
    this.currency = newCurrency;
    saveData();
    notifyListeners();
  }
}
