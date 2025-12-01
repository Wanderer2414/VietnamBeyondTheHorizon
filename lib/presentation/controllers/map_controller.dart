import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:vietnambeyondthehorizon/animations/card/appear.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/data/models/game_progress.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/map_state.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/user_history.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/result_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/information_location.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/timeline_progress.dart';

class MyMapController {
  MapController? mapController;
  final Location _location = Location();
  MapState _value = MapState();
  final GameProgressManager gameManager = GameProgressManager();
  void Function() resetMap = () {};

  LocationModel get currentMissionLocation {
    return gameManager.userRoute[gameManager.currentIndex];
  }

  // set userRoute(List<LocationModel> route) {
  //   gameManager.userRoute = route;
  // }

  // List<LocationModel> get userRoute {
  //   return _value.locationList;
  // }
  List<LocationModel> get userRoute => gameManager.userRoute;

  LatLng? get currentLocation {
    if (_value.currentLocation == null) {
      _initLocation();
    }
    return _value.currentLocation;
  }

  Future<void> initialize() async {
    try {
      await _initLocation();
      await gameManager.loadProgress();

      // final userGPS = await loadGPS();
      // _value.currentLocation = LatLng(userGPS['lat']!, userGPS['lng']!);
      //await UserHistoryManager().loadLocalHistory();

      if (gameManager.userRoute.isNotEmpty &&
          gameManager.currentTarget != null) {
        await fetchRoute(
          _value.currentLocation,
          gameManager.currentTarget!.coordinates,
        );
      }
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
      _value.currentLocation = LatLng(locData.latitude!, locData.longitude!);
      // saveGPS(locData.latitude!, locData.longitude!);
      // saveProgress();
    }

    _location.onLocationChanged.listen((loc) {
      if (loc.latitude != null && loc.longitude != null) {
        _value.currentLocation = LatLng(loc.latitude!, loc.longitude!);
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
      initialCenter:
          _value.currentLocation ?? const LatLng(10.762622, 106.660172),
      initialZoom: 15,
      minZoom: 8,
      maxZoom: 20,
      onTap: (tapPosition, point) => {},
      onMapReady: onMapReady,
    );
  }

  List<Widget> mapLayers(
    BuildContext context,
    List<LocationModel> locationList,
    void Function(LocationModel location) onLocationTap, {
    required bool isGameMode,
  }) {
    final layers = <Widget>[
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.my_map',
      ),
    ];

    if (_value.routes != null && _value.routes!.isNotEmpty) {
      layers.add(
        PolylineLayer(
          polylines: [
            Polyline(
              points: _value.routes!,
              strokeWidth: 6,
              borderColor: Colors.blue.shade900,
              borderStrokeWidth: 2,
              color: Colors.blue.shade500,
            ),
          ],
        ),
      );
    }

    layers.add(
      CurrentLocationLayer(
        style: LocationMarkerStyle(
          marker: DefaultLocationMarker(
            child: Icon(Icons.location_pin, color: Colors.red),
          ),
          // accuracyCircleColor: Colors.black,
          headingSectorColor: Colors.black54,
          markerSize: Size(35, 35),
          // markerDirection: MarkerDirection.heading,
        ),
      ),
    );

    layers.add(
      MarkerLayer(
        markers: locationList
            .map(
              (e) => LocationMarker(
                context,
                e,

                gameManager.getMarkerAppearance(
                  location: e,
                  isGameMode: isGameMode,
                ),
                (loc, context) {
                  if (isGameMode && gameManager.isLocked(loc)) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Locked! Complete the previous mission first",
                        ),
                        backgroundColor: Colors.grey[800],
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  onLocationTap(loc);
                },
              ),
            )
            .toList(),
      ),
    );
    if (gameManager.userRoute.isNotEmpty && isGameMode) {
      layers.add(
        SafeArea(
          // Tránh tai thỏ
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TimelineProgress(
                currentIndex: gameManager.currentIndex,
                totalSteps: gameManager.userRoute.length,
              ),
            ),
          ),
        ),
      );
    }
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
          await fetchRoute(_value.currentLocation, LatLng(lat, lon));
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
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final geometry = data['routes'][0]['geometry'];
        final List<LatLng> decodedRoute = await compute<String, List<LatLng>>(
          _decodePolyline,
          geometry,
        );
        _value.routes = decodedRoute;
        resetMap();
      } else {
        throw Exception('Failed to fetch route.');
      }
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    } finally {}
  }

  Future<void> fetchFullRoute({List<LocationModel>? route}) async {
    route ??= gameManager.userRoute;
    if (route.length < 2) return;

    _value.routes = [];
    final dio = Dio();
    LatLng end = _value.currentLocation!;

    for (int i = 0; i < route.length; i++) {
      final start = end;
      end = LatLng(route[i].latitude, route[i].longitude);

      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${start.longitude},${start.latitude};'
          '${end.longitude},${end.latitude}'
          '?overview=full&geometries=polyline';

      try {
        final response = await dio.get(
          url,
          // options: Options(
          //   receiveTimeout: Duration(seconds: 10),
          //   sendTimeout: Duration(seconds: 10),
          // ),
        );

        if (response.statusCode == 200) {
          final data = response.data;
          final geometry = data['routes'][0]['geometry'];

          final List<LatLng> decodedRoute = await compute<String, List<LatLng>>(
            _decodePolyline,
            geometry,
          );

          if (i > 0) decodedRoute.removeAt(0);

          _value.routes?.addAll(decodedRoute);
        } else {
          throw Exception('Failed to fetch route between $i and ${i + 1}');
        }
      } catch (e) {
        // _value.routes?.add(start);
        // _value.routes?.add(end);
        print("OSRM Lỗi đoạn $i (Server 504/Timeout): $e");
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
    if (_value.currentLocation != null) {
      mapController?.move(_value.currentLocation!, 15);
      return "";
    } else {
      return "Current location not available";
    }
  }

  void moveToLocation(LatLng destination, double zoom) {
    mapController?.move(destination, zoom);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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

  void toggleMissionCard(
    BuildContext context,
    LocationModel location, {
    bool isReplace = false,
  }) {
    Function(Route) func = Navigator.of(context).push;
    if (isReplace) func = Navigator.of(context).pushReplacement;
    func(
      ApearAnimation(
        opaque: false,
        nextScreen: MissionScreen(
          controller: this,
          locationModel: location,
          onNavigate: () {},
          onClose: () {
            if (gameManager.currentIndex == userRoute.length)
              completeRoute(context);
          },
        ),
      ),
    );
  }

  void nextMission(BuildContext context) {
    if (gameManager.isFinished) {
      throw Exception("Out range of userRoute");
    }
    gameManager.nextStage();

    if (gameManager.isFinished) {
      completeRoute(context);
      resetMap();
      return;
    }

    if (gameManager.currentTarget != null) {
      fetchRoute(
        _value.currentLocation,
        userRoute[gameManager.currentIndex].coordinates,
      );
    }
    resetMap();
  }

  void startRoute(List<LocationModel> newRoute) {
    gameManager.startGame(newRoute);

    if (gameManager.currentTarget != null) {
      fetchRoute(
        _value.currentLocation,
        gameManager.currentTarget!.coordinates,
      );
    }

    // for (int i = 0; i < userRoute.length; i++) {
    //   if (i <= gameManager.currentIndex)
    //     _markerAppreances[userRoute[i].id]?.color = Colors.red;
    //   else
    //     _markerAppreances[userRoute[i].id]?.color = Colors.black;
    // }
    resetMap();
  }

  void completeRoute(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(TransitionLRPageRoute(nextScreen: ResultAutoScreen()));
    // GameProgressManager().resetProgress();
  }

  Future<void> updateMissionImage(String missionId, String imagePath) async {
    for (var m in await NetworkProxy.missions) {
      if (m.id == missionId) {
        m.imagePath = imagePath;
        //notifyListeners();
        break;
      }
    }
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
