import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';

class MarkerAppearance {
  Color color;
  MarkerAppearance({this.color = Colors.black});
}

class LocationMarker extends Marker {
  LocationMarker(
    BuildContext context,
    LocationModel loc,
    MarkerAppearance appear,
    Function(LocationModel loc, BuildContext context) onMarkerTap,
  ) : super(
        point: loc.coordinates,
        width: 60,
        height: 60,
        rotate: true,
        child: GestureDetector(
          onTap: () {
            onMarkerTap(loc, context);
            // onMovingToLocation(loc.coordinates, 15);
          },
          child: Icon(Icons.location_pin, color: appear.color, size: 45),
        ),
      );
}
