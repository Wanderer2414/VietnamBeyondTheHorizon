import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/gen_routes_algo_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/input_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/submit_route_map/main_content.dart';
import '../controllers/map_controller.dart';

class SubmitRouteScreen extends StatefulWidget {
  final MyMapController controller;
  final UserInput userInput;
  SubmitRouteScreen({
    super.key,
    required this.controller,
    required this.userInput,
  });

  @override
  State<SubmitRouteScreen> createState() => _SubmitRouteScreenState();
}

class _SubmitRouteScreenState extends State<SubmitRouteScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late Drawer _sidePanel;
  HomeAppbar? _homeBar;
  Content? _content;
  late final FloatingActionButton _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = FloatingActionButton(
      onPressed: widget.controller.moveToCurrentLocation,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.my_location, size: 30, color: Colors.white),
    );
    _sidePanel = Drawer(child: SideBox());

    // LoadingManager.run(context, (context) async {
    //   widget.controller.fetchFullRoute(route: widget.route);
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size screenSize = MediaQuery.of(context).size;
    if (_homeBar == null) {
      _homeBar = HomeAppbar(
        superKey: _key,
        size: Size(screenSize.width, screenSize.height * 0.06),
      );
      // _content = Content(
      //   controller: widget.controller,
      //   screenSize: screenSize,
      //   route: widget.route,
      //   onSubmit: (route) {},
      //   onLocationPress: (location) {
      //     widget.controller.moveToLocation(
      //       LatLng(location.latitude, location.longitude),
      //       15,
      //     );
      //     widget.controller.toggleLocationInfo(context, location, () {
      //       widget.controller.fetchRoute(
      //         widget.controller.currentLocation,
      //         location.coordinates,
      //       );
      //     }, () {});
      //   },
      // onStart: () {
      // widget.controller.userRoute = widget.route;
      // Navigator.of(context).pushReplacement(
      //   TransitionLRPageRoute(
      //     nextScreen: MapScreen(
      //       controller: widget.controller,
      //       route: widget.route,
      //     ),
      //   ),
      // );
      // },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      init: (context) async {
        try {
          if (widget.controller.currentLocation != null) {
            // Cập nhật UserInput với dữ liệu từ các controllers
            // widget.userInput.budget = UserInput.parseBudget(
            //   widget.._budgetController.text,
            // );
            // userInput.durationDays = UserInput.parseDuration(
            //   _durationController.text,
            // );

            // Gọi thuật toán để tạo route
            final locations = await NetworkProxy.locations;
            final route = await RoutePlannerService.generateRouteFromUserInput(
              userGPS: widget.controller.currentLocation!,
              budget: widget.userInput.budget,
              durationDays: widget.userInput.durationDays,
              locations: widget.userInput.getSelectedInterests(locations),
              missions: await NetworkProxy.missions,
            );
          }
        }
        // await widget.controller.fetchFullRoute(
        //   route: widget.route.missions
        //       .map((e) => e.location!.coordinates)
        //       .toList(),
        // );
        catch (e) {
          print(e);
        }
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        appBar: _homeBar,
        drawer: _sidePanel,
        body: _content,
        floatingActionButton: _myLocation,
      ),
    );
  }
}
