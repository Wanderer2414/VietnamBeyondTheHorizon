import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'Page2onBoarding.dart';
import 'Page3onBoarding.dart';
import 'Page4onBoarding.dart';
import 'InputPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vietnam Beyond The Horizon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      initialRoute: '/SplashScreen',
      routes: {
        '/SplashScreen': (context) => const SplashScreen(),
        '/Page2onBoarding': (context) => const Page2onBoarding(),
        '/Page3onBoarding': (context) => const Page3onBoarding(),
        '/Page4onBoarding': (context) => const Page4onBoarding(),
        '/InputPage': (context) => const InputPage(),
        
      },
    );
  }
}
