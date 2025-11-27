import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';

class MapState {
  int currentIndex = 0;
  LatLng? currentLocation;
  List<LocationModel> locationList;
  List<LocationModel> locationDataList;
  List<LatLng>? routes;
  double heading;
  List<MissionModel> missionList;

  MapState({
    this.currentIndex = 0,
    this.currentLocation,
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
