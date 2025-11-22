import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';

class MapState {
  final bool isPlaying;
  final bool isLoading;
  final LatLng? currentLocation;
  final LatLng? destination;
  final double? distance;
  final List<LocationModel> locationList;
  final List<LocationModel> locationDataList;
  final List<LatLng>? routes;
  final double heading;

  MapState({
    this.isPlaying = false,
    this.isLoading = true,
    this.currentLocation,
    this.destination,
    this.distance,
    this.routes = const [],
    this.heading = 0,
    this.locationList = const [],
    this.locationDataList = const [],
  });

  MapState copyWith({
    bool? isPlaying,
    bool? isLoading,
    LatLng? currentLocation,
    LatLng? destination,
    double? distance,
    List<LatLng>? routes,
    double? heading,
    List<LocationModel>? locationList,
    List<LocationModel>? locationDataList,
  }) {
    return MapState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentLocation: currentLocation ?? this.currentLocation,
      destination: destination ?? this.destination,
      distance: distance ?? this.distance,
      routes: routes ?? this.routes,
      heading: heading ?? this.heading,
      locationList: locationList ?? this.locationList,
      locationDataList: locationDataList ?? this.locationDataList,
    );
  }

  // ---------------------- JSON ------------------------
  Map<String, dynamic> toJson() {
    return {
      'isPlaying': isPlaying,
      'isLoading': isLoading,
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
    };
  }

  factory MapState.fromJson(Map<String, dynamic> json) {
    LatLng? _latLng(dynamic data) =>
        data == null ? null : LatLng(data['lat'], data['lng']);

    return MapState(
      isPlaying: json['isPlaying'] ?? false,
      isLoading: json['isLoading'] ?? true,
      currentLocation: _latLng(json['currentLocation']),
      destination: _latLng(json['destination']),
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
    );
  }
}
