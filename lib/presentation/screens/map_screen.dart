import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/side_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/location_info.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission/mission_card.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/search_bar.dart';
import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final controller = MyMapController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final sideBox = SideBox();

  @override
  void initState() {
    super.initState();
    controller.initialize(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      appBar: HomeAppbar(
        superKey: _key,
        size: Size(screenSize.width, screenSize.height * 0.06),
      ),
      drawer: Drawer(child: sideBox),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: controller.mapController,
                options: controller.mapOptions(
                  onMapReady: controller.onMapReady,
                ),
                children: controller.mapLayers(context),
              ),

              //MISSION CARD
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubicEmphasized,
                top: controller.isMissionCardVisible
                    ? screenSize.height * 0.15
                    : screenSize.height,
                left: screenSize.width * 0.05,
                right: screenSize.width * 0.05,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 600),
                  scale: controller.isMissionCardVisible ? 1 : 0.3,
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: controller.isMissionCardVisible ? 1 : 0,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) {
                        final rotate = Tween(
                          begin: pi,
                          end: 0.0,
                        ).animate(animation);
                        return AnimatedBuilder(
                          animation: rotate,
                          builder: (context, child) {
                            final isUnder =
                                (ValueKey(controller.isCardFlipping) !=
                                child!.key);
                            var tilt = (animation.value - 0.5).abs() - 0.5;
                            tilt *= 0.003;
                            final value = isUnder
                                ? min(rotate.value, pi / 2)
                                : rotate.value;
                            return Transform(
                              transform: Matrix4.rotationY(value)
                                ..setEntry(3, 0, tilt),
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                          child: child,
                        );
                      },
                      child: controller.isCardFlipping
                          ? controller.selectedLocation == null
                                ? const SizedBox()
                                : MissionCard(
                                    location: controller.selectedLocation!,
                                    controller: controller,
                                  )
                          : SizedBox(height: 200, width: 300),
                    ),
                  ),
                ),
              ),

              //LOCATION INFORMATION
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastEaseInToSlowEaseOut,
                top: controller.isLocationInfoPanelVisible
                    ? screenSize.height * 0.5
                    : screenSize.height,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: screenSize.height * 0.5,
                  child: SingleChildScrollView(
                    child: controller.selectedLocation == null
                        ? const SizedBox()
                        : LocationInfoWidget(
                            location: controller.selectedLocation!,
                            onClose: () =>
                                controller.toggleLocationInfoPanel(null),
                            controller: controller,
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SearchBarWidget(controller: controller),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.moveToCurrentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, size: 30, color: Colors.white),
      ),
    );
  }
}

double min(double a, double b) {
  return a < b ? a : b;
}
