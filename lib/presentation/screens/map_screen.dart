import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/common/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/main_content.dart';
import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final controller = MyMapController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late Drawer _sidePanel;
  HomeAppbar? _homeBar;
  Content? _content;
  late final FloatingActionButton _myLocation;

  @override
  void initState() {
    super.initState();
    controller.initialize(context);
    _myLocation = FloatingActionButton(
      onPressed: () => controller.moveToCurrentLocation(),
      backgroundColor: Colors.blue,
      child: const Icon(Icons.my_location, size: 30, color: Colors.white),
    );
    _sidePanel = Drawer(child: SideBox());
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
      _content = Content(controller: controller, screenSize: screenSize);
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
