import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';

class MapState {
  int currentIndex = 0;
  LatLng? currentLocation;
  List<LocationModel> locationList;
  List<LatLng>? routes;

  MapState({
    this.currentIndex = 0,
    this.currentLocation,
    this.routes = const [],
    this.locationList = const [],
  });

  // ---------------------- JSON ------------------------
  Map<String, dynamic> toJson() {
    return {
      'currentLocation': currentLocation != null
          ? {
              'lat': currentLocation!.latitude,
              'lng': currentLocation!.longitude,
            }
          : null,
      'routes': routes
          ?.map((e) => {'lat': e.latitude, 'lng': e.longitude})
          .toList(),
      'locationList': locationList.map((e) => e.toJson()).toList(),
    };
  }

  factory MapState.fromJson(Map<String, dynamic> json) {
    LatLng? latLng(dynamic data) =>
        data == null ? null : LatLng(data['lat'], data['lng']);

    return MapState(
      currentLocation: latLng(json['currentLocation']),
      routes:
          (json['routes'] as List?)
              ?.map((e) => LatLng(e['lat'], e['lng']))
              .toList() ??
          [],
      locationList:
          (json['locationList'] as List?)
              ?.map((e) => LocationModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
