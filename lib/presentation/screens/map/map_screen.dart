import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/home/home_app_bar.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/location_info.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/search_bar.dart';
import 'map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final controller = MyMapController(
    togglePanel: (location) => togglePanel(location),
  );
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  LocationModel? selectedLocation;
  bool isPanelVisible = false;

  @override
  void initState() {
    super.initState();
    controller.initialize(context);
  }

  void togglePanel(LocationModel? location) {
    setState(() {
      if (location == null) {
        isPanelVisible = false;
        selectedLocation = null;
      } else {
        selectedLocation = location;
        isPanelVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: HomeAppbar(
        superKey: _key,
        size: Size(screenSize.width, screenSize.height * 0.06),
      ),
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

              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastEaseInToSlowEaseOut,
                top: isPanelVisible
                    ? screenSize.height * 0.5
                    : screenSize.height,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: screenSize.height * 0.5,
                  child: SingleChildScrollView(
                    child: selectedLocation == null
                        ? const SizedBox()
                        : LocationInfoWidget(
                            location: selectedLocation!,
                            onClose: () => togglePanel(null),
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
        child: const Icon(Icons.my_location, size: 30),
      ),
    );
  }
}
