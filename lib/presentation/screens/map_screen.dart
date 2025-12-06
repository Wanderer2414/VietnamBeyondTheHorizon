import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/main_content.dart';
import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  final MyMapController controller;
  final UserAccount account;
  final GameRoute route;
  MapScreen({
    super.key,
    required this.controller,
    required this.route,
    required this.account,
  }) {}

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
  }

  void init() {
    final Size screenSize = MediaQuery.of(context).size;
    _homeBar = HomeAppbar(
      superKey: _key,
      size: Size(screenSize.width, screenSize.height * 0.06),
    );
    _content = Content(
      controller: widget.controller,
      screenSize: screenSize,
      account: widget.account,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      init: (context) async {
        await GameProgressManager.startGame(widget.route);
        init();
        widget.controller.fetchRoute(
          widget.controller.currentLocation,
          widget.route.missions[0].location!.coordinates,
        );
        setState(() {});
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        appBar: _homeBar,
        drawer: _sidePanel,
        body: _content ?? Container(),
        floatingActionButton: _myLocation,
      ),
    );
  }
}
