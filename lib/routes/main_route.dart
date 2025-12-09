import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/account_login.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/account_register.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/home_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/input_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/introduction_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/log_navigator.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/map_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/profile_page.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/result_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/splash_begin_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/submit_route_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/waiting_generating_video.dart';

class MainRoute {
  static final GlobalKey<NavigatorState> NavigatorKey =
      GlobalKey<NavigatorState>();
  static Widget start() {
    return SplashScreen();
  }

  static void goHome(UserAccount account) {
    NavigatorKey.currentState?.pushAndRemoveUntil(
      TransitionRLPageRoute(nextScreen: HomeScreen(user: account)),
      (_) => false,
    );
  }

  static void goIntro() {
    NavigatorKey.currentState?.pushReplacement(
      TransitionRLPageRoute(nextScreen: IntroScreen()),
    );
  }

  static void logout() {
    NavigatorKey.currentState?.pushAndRemoveUntil(
      TransitionRLPageRoute(nextScreen: LogNavigatorScreen()),
      (route) => false,
    );
  }

  static void goLogin() {
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(nextScreen: AccountLoginScreen()),
    );
  }

  static void goInputScreen(MyMapController controller, UserAccount account) {
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(
        nextScreen: InputPage(controller: controller, account: account),
      ),
    );
  }

  static void goGameScreen(
    MyMapController controller,
    GameRoute route,
    UserAccount account,
  ) {
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(
        nextScreen: MapScreen(
          controller: controller,
          route: route,
          account: account,
        ),
      ),
    );
  }

  static void goProfilePage(UserAccount user) {
    NavigatorKey.currentState?.push(
      TransitionLRPageRoute(nextScreen: ProfilePage(user: user)),
    );
  }

  static void goResultScreen(GameRoute route, UserAccount account) {
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(
        nextScreen: ResultAutoScreen(route: route, account: account),
      ),
    );
  }

  static void goSignup() {
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(nextScreen: AccountRegisterScreen()),
    );
  }

  static void goSubmitRoute(
    MyMapController controller,
    UserInput input,
    UserAccount account,
  ) {
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(
        nextScreen: SubmitRouteScreen(
          controller: controller,
          userInput: input,
          account: account,
        ),
      ),
    );
  }

  static void goGeneratingVideo(UserAccount account, Future<String?> Function() onGenerate){
    NavigatorKey.currentState?.push(
      TransitionRLPageRoute(nextScreen:  WaitingGeneratingVideoScreen(account: account, onGenerate: onGenerate))
    );
  }
  static void showError(String text) {
    if (NavigatorKey.currentContext != null)
      ScaffoldMessenger.of(
        NavigatorKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(text)));
  }

  static void pop() {
    NavigatorKey.currentState?.pop();
  }


}

// class MainRoute {
//   static const String home = "/";
//   static Route newRoute(String? name) {
//     switch (name) {
//       case "/":
//       case "intro":
//         return TransitionRLPageRoute(nextScreen: IntroScreen());

//       case "log_navigator":
//         return;

//       case "login":
//         return ;

//       case "register":
//         return TransitionRLPageRoute(nextScreen: AccountRegisterScreen());

//       case "home":
//         return TransitionRLPageRoute(nextScreen: HomeScreen());

//       case "test":
//         return TransitionRLPageRoute(nextScreen: TestPage());
//       default:
//         return newRoute("/");
//     }
//   }
// }
