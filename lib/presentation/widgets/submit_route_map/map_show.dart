import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';

class MapShow extends StatefulWidget {
  final Size size;
  const MapShow({super.key, required this.controller, required this.size});

  final MyMapController controller;

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  List<LocationModel?>? _allLocation;
  MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    widget.controller.resetMap = () {
      setState(() {});
    };
    NetworkProxy.quest.then(
      (value) => setState(() {
        _allLocation = value?.locations ?? [];
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
        children: widget.controller.mapLayers(context, [
          LocationLayer(context, widget.controller, _allLocation ?? []),
        ]),
      ),
    );
  }
}
