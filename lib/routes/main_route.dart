import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/account_login.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/account_register.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/profile_register_screen.dart';

class MainRoute {
  static const String home = "/";
  static Map<String, WidgetBuilder> routes = {
    home: (context) => ProfileRegister(),
    "login": (context) => AccountLoginScreen(),
    "register": (context) => AccountRegisterScreen(),
  };
}
