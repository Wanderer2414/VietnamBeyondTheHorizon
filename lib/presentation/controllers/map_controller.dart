import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:vietnambeyondthehorizon/animations/card/appear.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/information_location.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission_screen.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class MyMapController {
  MapController? mapController;
  final Location _location = Location();
  LatLng? _currentLocation;
  List<LatLng> _routes = [];
  void Function() resetMap = () {};

  // set userRoute(List<LocationModel> route) {
  //   gameManager.userRoute = route;
  // }

  // List<LocationModel> get userRoute {
  //   return _value.locationList;
  // }
  // List<LocationModel> get userRoute => gameManager.userRoute;

  LatLng? get currentLocation {
    if (_currentLocation == null) {
      _initLocation();
    }
    return _currentLocation;
  }

  Future<void> initialize() async {
    try {
      await _initLocation();
      // await gameManager.loadProgress();

      // final userGPS = await loadGPS();
      // _value.currentLocation = LatLng(userGPS['lat']!, userGPS['lng']!);

      // if (gameManager.userRoute.isNotEmpty &&
      //     gameManager.currentTarget != null) {
      //   await fetchRoute(
      //     _value.currentLocation,
      //     gameManager.currentTarget!.coordinates,
      //   );
      // }
    } catch (e) {
      print("Eror in initializing map: ${e}");
    } finally {
      resetMap();
    }
  }

  Future<void> _initLocation() async {
    if (!await _checkPermission()) return;

    final locData = await _location.getLocation();
    print(locData.latitude);
    print(locData.longitude);
    if (locData.latitude != null && locData.longitude != null) {
      _currentLocation = LatLng(locData.latitude!, locData.longitude!);
      // saveGPS(locData.latitude!, locData.longitude!);
      // saveProgress();
    }

    _location.onLocationChanged.listen((loc) {
      if (loc.latitude != null && loc.longitude != null) {
        _currentLocation = LatLng(loc.latitude!, loc.longitude!);
        // saveGPS(loc.latitude!, loc.longitude!);
        // saveProgress();
      }
    });
  }

  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled)
      if (!await Geolocator.openLocationSettings()) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }
    }

    return true;
  }

  MapOptions mapOptions({
    required BuildContext context,
    required Function() onMapReady,
  }) {
    return MapOptions(
      initialCenter: _currentLocation ?? const LatLng(10.762622, 106.660172),
      initialZoom: 15,
      minZoom: 8,
      maxZoom: 20,
      onTap: (tapPosition, point) => {},
      onMapReady: onMapReady,
    );
  }

  List<Widget> mapLayers(BuildContext context, MarkerLayer locaionLayer) {
    final layers = <Widget>[
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.my_map',
      ),
    ];

    if (_routes.isNotEmpty) {
      layers.add(
        PolylineLayer(
          polylines: [
            Polyline(
              points: _routes,
              strokeWidth: 6,
              borderColor: Colors.blue.shade900,
              borderStrokeWidth: 2,
              color: Colors.blue.shade500,
            ),
          ],
        ),
      );
    }

    layers.add(CurrentLayer());
    layers.add(locaionLayer);
    return layers;
  }

  Future<void> fetchCoordinates(String locationName) async {
    final dio = Dio();
    final url =
        "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(locationName)}&format=json&limit=1";

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {'User-Agent': 'my_map/1.0 (khangthinh111555@gmail.com)'},
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          await fetchRoute(_currentLocation, LatLng(lat, lon));
          resetMap();
        } else {
          throw Exception("Location not found.");
        }
      } else {
        throw Exception("Failed to fetch location.");
      }
    } catch (e) {
      throw Exception("Failed to fetch location: $e");
    } finally {}
  }

  Future<void> fetchRoute(LatLng? start, LatLng? end) async {
    if (start == null || end == null) return;
    final dio = Dio();
    final url =
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=polyline&alternatives=false&annotations=distance';

    try {
      final response = await dio.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = response.data;
        final geometry = data['routes'][0]['geometry'];
        final List<LatLng> decodedRoute = await compute<String, List<LatLng>>(
          _decodePolyline,
          geometry,
        );
        _routes = decodedRoute;
        resetMap();
      } else {
        throw Exception('Failed to fetch route.');
      }
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    } finally {}
  }

  Future<void> fetchFullRoute({required List<LatLng> route}) async {
    if (route.length < 2) return;
    print("Start fetch route!");
    _routes.clear();
    final dio = Dio();
    LatLng end = _currentLocation!;
    for (LatLng loc in route) {
      final start = end;
      end = loc;

      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${start.longitude},${start.latitude};'
          '${end.longitude},${end.latitude}'
          '?overview=full&geometries=polyline';

      try {
        print("Wait fetch $loc...");
        final response = await dio
            .get(url)
            .timeout(const Duration(seconds: 10));
        print("Fetch $loc");

        if (response.statusCode == 200) {
          final data = response.data;
          final geometry = data['routes'][0]['geometry'];

          final List<LatLng> decodedRoute = await compute<String, List<LatLng>>(
            _decodePolyline,
            geometry,
          );

          if (loc != route.first) decodedRoute.removeAt(0);

          _routes.addAll(decodedRoute);
        } else {
          throw Exception('Failed to fetch route between $start and $end');
        }
      } catch (e) {
        // _value.routes?.add(start);
        // _value.routes?.add(end);
        print("$e");
        throw Exception('Failed to fetch route: $e');
      }
    }
    print("Done fetch ${route.length} locs");
    resetMap();

    // throw Exception("Full route length: ${fullRoute.length} points");
  }

  // Future<double> fetchDistance(LatLng? start, LatLng? end) async {
  //    if (start == null || end == null) return 0;

  //   final url = Uri.parse(
  //     'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=polyline&alternatives=false&annotations=distance',
  //   );

  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final route = data['routes'][0];
  //     final double distanceMeters = route['distance'];
  //     return distanceMeters;
  //   } else {
  //     _showError('Failed to fetch distance.');
  //   }
  //   return 0;
  // }

  String moveToCurrentLocation() {
    if (_currentLocation != null) {
      mapController?.move(_currentLocation!, 15);
      return "";
    } else {
      return "Current location not available";
    }
  }

  void moveToLocation(LatLng destination, double zoom) {
    mapController?.move(destination, zoom);
  }

  void toggleLocationInfo(
    BuildContext context,
    LocationModel location,
    void Function() onNavigate,
    void Function() onClose, {
    bool isReplace = false,
  }) {
    Function(Route) func = Navigator.of(context).push;
    if (isReplace) func = Navigator.of(context).pushReplacement;
    func(
      TransitionBTPageRoute(
        nextScreen: InformationLocation(
          onClose: () {
            // Navigator.of(context).pop();
            onClose();
          },
          onNavigate: (loc) {
            onNavigate();
          },
          locationModel: location,
        ),
      ),
    );
  }

  Future<void> toggleMissionCard(
    BuildContext context,
    MissionModel mission, {
    bool isReplace = false,
  }) async {
    Function(Route) func = Navigator.of(context).push;
    if (isReplace) func = Navigator.of(context).pushReplacement;
    func(
      ApearAnimation(
        opaque: false,
        nextScreen: MissionScreen(
          controller: this,
          mission: mission,
          onNavigate: () {},
          onSubmitedAndClose: () {
            LoadingManager.run(context, (context) async {
              int reward = mission.difficulty;
              //ADD STARS!!!!!!!!!!!!!!!
              await GameProgressManager.markAsCompleted(mission.id);
              await GameProgressManager.addStars(reward);
              mission.isCompleted = true;
              if (GameProgressManager.nextStage()) {
                final mission = GameProgressManager.currentTarget;
                await fetchRoute(
                  _currentLocation,
                  mission.location!.coordinates,
                );
                moveToLocation(mission.location!.coordinates, 15);
                MainRoute.pop();
              } else {}
            });
          },
        ),
      ),
    );
  }

  Future<void> updateMissionImage(int missionId, String imagePath) async {
    (await NetworkProxy.missions)[missionId]?.imagePath = imagePath;
  }
}

List<LatLng> _decodePolyline(String encoded) {
  final List<LatLng> points = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
    lng += dlng;

    points.add(LatLng(lat / 1E5, lng / 1E5));
  }
  return points;
}
