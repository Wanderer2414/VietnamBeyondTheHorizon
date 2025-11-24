import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class MapShow extends StatefulWidget {
  final Size size;
  const MapShow({super.key, required this.controller, required this.size});

  final MyMapController controller;

  @override
  State<MapShow> createState() => _MapShowState();
}

class _MapShowState extends State<MapShow> {
  @override
  void initState() {
    super.initState();
    widget.controller.resetMap = () {
      setState(() {
        
      });
    };
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: widget.controller.map(
        context: context, 
        locations: widget.controller.allLocationn,
        onReady:() => setState(() {}), 
        onMissionTap: (location) => 
          widget.controller.toggleLocationInfo(context, location, () {
            widget.controller.fetchRoute(widget.controller.currentLocation, location.coordinates);
          },
          () {},
        )
      )
    );
  }
}
