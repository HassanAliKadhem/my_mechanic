import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';

class HomePageTab {
  String title;
  AdaptiveScaffoldDestination adaptiveScaffoldDestination;
  Widget pageElements;

  HomePageTab(this.title, this.adaptiveScaffoldDestination, this.pageElements);
}
