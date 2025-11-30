import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  NetworkProxy.gotoLoginScreen = () {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MainRoute.newRoute("log_navigator"),
      (route) => false,
    );
  };

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
      navigatorObservers: [routeObserver],
      navigatorKey: navigatorKey,
      title: 'Vietnam: Beyond the Horizon',
      initialRoute: MainRoute.home,
      onGenerateRoute: (settings) => MainRoute.newRoute(settings.name),
    );
  }
}
