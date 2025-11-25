import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';

class MarkerLayerWidget extends StatelessWidget {
  final List<LocationModel> locations;
  final void Function(LocationModel, BuildContext) onMarkerTap;
  final void Function(LatLng, double) onMovingToLocation;
  const MarkerLayerWidget({
    super.key,
    required this.locations,
    required this.onMarkerTap,
    required this.onMovingToLocation,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: locations.map((loc) {
        return Marker(
          point: loc.coordinates,
          width: 60,
          height: 60,
          rotate: true,
          child: GestureDetector(
            onTap: () {
              onMarkerTap(loc, context);
              // onMovingToLocation(loc.coordinates, 15);
            },
            child: Icon(Icons.location_pin, color: loc.typeColor, size: 45),
          ),
        );
      }).toList(),
    );
  }
}
