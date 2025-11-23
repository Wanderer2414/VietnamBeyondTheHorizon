import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/submit_route_map/main_content.dart';
import '../controllers/map_controller.dart';

class SubmitRouteScreen extends StatefulWidget {
  final MyMapController controller;
  final List<LocationModel> route;
  SubmitRouteScreen({super.key, required this.controller, required this.route}) {
    controller.fetchFullRoute(route: route);
  }

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
    widget.controller.resetMap = () {
      setState(() {});
    };
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
      _content = Content(
        controller: widget.controller, 
        screenSize: screenSize, 
        route: widget.route, 
        onSubmit: (route) {},
        onLocationPress: (location) {
          widget.controller.moveToLocation(LatLng(location.latitude, location.longitude), 15);
          widget.controller.toggleMissionCard(location, context);
        },
        onStart: () {

        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      appBar: _homeBar,
      drawer: _sidePanel,
      body: _content,
      floatingActionButton: _myLocation,
    );
  }
}
