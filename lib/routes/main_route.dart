import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transitionRL.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/account_login.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/account_register.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/home_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/input_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/introduction_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/log_navigator.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/splash_begin_screen.dart';

class MainRoute {
  static const String home = "/";
  static Route newRoute(String? name) {
    switch (name) {
      case "/":
        return MaterialPageRoute(builder: (builder) => SplashScreen());

      case "intro":
        return TransitionRLPageRoute(nextScreen: IntroScreen());

      case "log_navigator":
        return TransitionRLPageRoute(nextScreen: LogNavigatorScreen());

      case "login":
        return TransitionRLPageRoute(nextScreen: AccountLoginScreen());

      case "register":
        return TransitionRLPageRoute(nextScreen: AccountRegisterScreen());

      case "filter":
        return TransitionRLPageRoute(nextScreen: InputPage());

      case "home":
        return TransitionRLPageRoute(nextScreen: HomeScreen());

      default:
        return newRoute("/");
    }
  }
}
