import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/begin_loading_screen.dart';

class MainRoute {
  static const String home = "/";
  static Map<String, WidgetBuilder> routes = {
    home: (context) => BeginLoadingScreen(),
  };
}
