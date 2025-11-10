import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_begin_screen.dart';
import 'screens/introduction_screen.dart';
import 'screens/input_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vietnam Beyond The Horizon',
      debugShowCheckedModeBanner: false,
      initialRoute: '/SplashScreen',
      routes: {
        '/SplashScreen': (context) => SplashScreen(),
        '/Page2onBoarding': (context) => IntroScreen(),
        '/InputPage': (context) => const InputPage(),
      },
    );
  }
}
