import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';

class MapShow extends StatefulWidget {
  final Size size;
  const MapShow({super.key, required this.controller, required this.size});

  final MyMapController controller;

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  List<LocationModel>? _allLocation;
  MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    print("Set reset map");
    widget.controller.resetMap = () {
      print("Reset map");
      setState(() {});
    };
    NetworkProxy.locations.then(
      (value) => setState(() {
        _allLocation = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.mapController = _mapController;
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: widget.controller.mapOptions(
          onMapReady: () => setState(() {}),
          context: context,
        ),
        children: widget.controller.mapLayers(
          context,
          _allLocation ?? [],
          (location) =>
              widget.controller.toggleLocationInfo(context, location, () {
                widget.controller.fetchRoute(
                  widget.controller.currentLocation,
                  location.coordinates,
                );
              }, () {}),
          isGameMode: false,
        ),
      ),
    );
  }
}
