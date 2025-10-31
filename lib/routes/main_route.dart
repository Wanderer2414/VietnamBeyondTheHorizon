import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/map/map_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/home_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/information_register_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/location_info.dart';
import 'package:vietnambeyondthehorizon/test_page.dart';

class MainRoute {
  static const String home = "/";
  static const String test = "";
  static const String mapScreen = "";
  static Map<String, WidgetBuilder> routes = {
    "register": (context) => InformationRegisterScreen(),
    home: (context) => HomeScreen(),
    test: (context) => TestPage(),
    mapScreen: (context) => MapScreen(),
  };
}
