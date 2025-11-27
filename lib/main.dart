import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(ProviderScope(child: const Application()));
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).removePadding(removeTop: true);
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Vietnam: Beyond the Horizon',
      initialRoute: MainRoute.home,
      onGenerateRoute: (settings) => MainRoute.newRoute(settings.name),
      builder: (context, child) {
        return LoadingWrapper(child: child!);
      },
    );
  }
}
