import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/gen_routes_algo_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/input_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/map_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/submit_route_map/main_content.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';
import '../controllers/map_controller.dart';

class SubmitRouteScreen extends StatefulWidget {
  final MyMapController controller;
  final UserInput userInput;
  final UserAccount account;
  SubmitRouteScreen({
    super.key,
    required this.controller,
    required this.userInput,
    required this.account,
  });

  @override
  State<SubmitRouteScreen> createState() => _SubmitRouteScreenState();
}

class _SubmitRouteScreenState extends State<SubmitRouteScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late Drawer _sidePanel;
  HomeAppbar? _homeBar;
  Content? _content;

  @override
  void initState() {
    super.initState();
    _sidePanel = Drawer(child: SideBox());

    // LoadingManager.run(context, (context) async {
    //   widget.controller.fetchFullRoute(route: widget.route);
    // });
  }

  void init(GameRoute route) {
    final Size screenSize = MediaQuery.of(context).size;
    if (_homeBar == null) {
      _homeBar = HomeAppbar(
        superKey: _key,
        size: Size(screenSize.width, screenSize.height * 0.06),
      );

      _content = Content(
        controller: widget.controller,
        screenSize: screenSize,
        route: route,
        onLocationPress: (location) {
          widget.controller.moveToLocation(
            LatLng(location.latitude, location.longitude),
          );
          widget.controller.toggleLocationInfo(context, location, () {
            widget.controller.fetchRoute(
              widget.controller.currentLocation,
              location.coordinates,
            );
          }, () {});
        },
        onStart: (route) {
          Navigator.of(context).pushReplacement(
            TransitionLRPageRoute(
              nextScreen: MapScreen(
                controller: widget.controller,
                account: widget.account,
                route: route,
              ),
            ),
          );
        },
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      init: (context) async {
        if (widget.controller.currentLocation != null) {
          final quest = (await NetworkProxy.quest);
          if (quest == null)
            MainRoute.showError("No quest response!");
          else {
            final route = await RoutePlannerService.generateRouteFromUserInput(
              userGPS: widget.controller.currentLocation!,
              budget: widget.userInput.budget,
              durationDays: widget.userInput.durationDays,
              quest: quest.UncompletedQuest(),
            );
            print("Route length ${route.missions.length}");
            route.sort(widget.controller.currentLocation!);

            init(route);
            await widget.controller.fetchFullRoute(
              route: route.missions
                  .map((e) => e.location!.coordinates)
                  .toList(),
            );
          }
        }
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        appBar: _homeBar,
        drawer: _sidePanel,
        body: _content,
      ),
    );
  }
}
