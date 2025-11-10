import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/onboarding4.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/information_register_screen.dart';
import 'package:vietnambeyondthehorizon/osm_page.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/profile_page.dart';

class MainRoute {
  static const String home = "/";
  static Map<String, WidgetBuilder> routes = {
    home: (context) => const ProfilePage(),
    "register": (context) => const InformationRegisterScreen(),
    "map": (context) => const OpenStreetMapScreen(),
  };
}

