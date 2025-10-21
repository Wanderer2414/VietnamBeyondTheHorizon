import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vietnam: Beyond the Horizon',
      initialRoute: MainRoute.home,
      routes: MainRoute.routes,
    );
  }
}
