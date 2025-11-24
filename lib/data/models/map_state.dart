import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';

class MapState {
  int currentIndex = 0;
  LatLng? currentLocation;
  LatLng? destination;
  double? distance;
  List<LocationModel> locationList;
  List<LocationModel> locationDataList;
  List<LatLng>? routes;
  double heading;
  List<MissionModel> missionList;

  MapState({
    this.currentIndex = 0,
    this.currentLocation,
    this.destination,
    this.distance,
    this.routes = const [],
    this.heading = 0,
    this.locationList = const [],
    this.locationDataList = const [],
    this.missionList = const [],
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
      'destination': destination != null
          ? {'lat': destination!.latitude, 'lng': destination!.longitude}
          : null,
      'distance': distance,
      'heading': heading,
      'routes': routes
          ?.map((e) => {'lat': e.latitude, 'lng': e.longitude})
          .toList(),
      'locationList': locationList.map((e) => e.toJson()).toList(),
      'locationDataList': locationDataList.map((e) => e.toJson()).toList(),
      'missionList': missionList.map((e) => e.toJson()).toList(),
    };
  }

  factory MapState.fromJson(Map<String, dynamic> json) {
    LatLng? latLng(dynamic data) =>
        data == null ? null : LatLng(data['lat'], data['lng']);

    return MapState(
      currentLocation: latLng(json['currentLocation']),
      destination: latLng(json['destination']),
      distance: (json['distance'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble() ?? 0,
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
      locationDataList:
          (json['locationDataList'] as List?)
              ?.map((e) => LocationModel.fromJson(e))
              .toList() ??
          [],
      missionList:
          (json['missionList'] as List?)
              ?.map((e) => MissionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
