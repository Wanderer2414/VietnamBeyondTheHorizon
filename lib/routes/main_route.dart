import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/information_register_screen.dart';

class MainRoute {
  static const String home = "/";
  static Map<String, WidgetBuilder> routes = {
    home: (context) => InformationRegisterStation(),
  };
}
