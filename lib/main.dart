import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Disable status bar on mobile
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).removePadding(removeTop: true);
    return MaterialApp(
      title: 'Vietnam: Beyond the Horizon',
      initialRoute: MainRoute.home,
      routes: MainRoute.routes,
    );
  }
}
