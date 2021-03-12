import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';

class HomePageTab {
  String title;
  Icon icon;
  Widget pageElementsPhone;
  Widget pageElementsTablet;

  HomePageTab(this.title, this.icon, this.pageElementsPhone, this.pageElementsTablet);
}
