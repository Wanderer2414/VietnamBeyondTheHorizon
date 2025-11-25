import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/animations/card/appear.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transition.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/map_state.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/information_location.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_share.dart';

class MyMapController {
  MapController? mapController;
  final Location _location = Location();
  MapState _value = MapState();
  void Function() resetMap = () {};

  List<LocationModel> get allLocationn {
    return _value.locationDataList;
  }

  List<MissionModel> get allMission {
    return _value.missionList;
  }

  LocationModel get currentMissionLocation {
    return _value.locationList[_value.currentIndex];
  }

  set userRoute(List<LocationModel> route) {
    _value.locationList = route;
  }

  List<LocationModel> get userRoute {
    return _value.locationList;
  }

  LatLng? get currentLocation {
    return _value.currentLocation;
  }

  MyMapController() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadProgress();
    await _initLocation();
    final userGPS = await loadGPS();
    _value.currentLocation = LatLng(userGPS['lat']!, userGPS['lng']!);

    final prefs = await SharedPreferences.getInstance();
    final cachedLoc = prefs.getString("cached_locationData");
    final cachedMis = prefs.getString("cached_missions");
    if (cachedLoc != null) {
      final data = jsonDecode(cachedLoc) as List;
      _value.locationDataList = data
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } else {
      await _fetchLocationData();
    }
    if (cachedMis != null) {
      final data = jsonDecode(cachedMis) as List;

      _value.missionList = data.map((e) => MissionModel.fromJson(e)).toList();
    } else {
      await _fetchMissionData();
    }
  }

  Future<void> _initLocation() async {
    if (!await _checkPermission()) return;

    final locData = await _location.getLocation();
    if (locData.latitude != null && locData.longitude != null) {
      _value.currentLocation = LatLng(locData.latitude!, locData.longitude!);
      saveGPS(locData.latitude!, locData.longitude!);
      saveProgress();
    }

    _location.onLocationChanged.listen((loc) {
      if (loc.latitude != null && loc.longitude != null) {
        _value.currentLocation = LatLng(loc.latitude!, loc.longitude!);
        saveGPS(loc.latitude!, loc.longitude!);
        saveProgress();
      }
    });
  }

  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

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

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_value.toJson());
    await prefs.setString('map_progress', jsonString);
    // debugPrint("Progress saved: $jsonString");
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('map_progress');
    if (jsonString == null) return;

    try {
      final data = jsonDecode(jsonString);
      _value = MapState.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load progress: $e");
    }
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
      maxZoom: 15,
      onTap: (tapPosition, point) => {},
      onMapReady: onMapReady,
    );
  }

  List<Widget> mapLayers(
    BuildContext context,
    List<LocationModel> locationList,
    void Function(LocationModel location) onLocationTap,
  ) {
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
            Polyline(points: _value.routes!, strokeWidth: 5, color: Colors.red),
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
          markerSize: Size(35, 35),
          // markerDirection: MarkerDirection.heading,
        ),
      ),
    );

    layers.add(
      MarkerLayerWidget(
        locations: locationList,
        onMarkerTap: (location, context) {
          onLocationTap(location);
        },
        onMovingToLocation: moveToLocation,
      ),
    );
    return layers;
  }

  Future<void> _fetchLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("User error: No token exists");
    }

    final url = Uri.parse(
      "https://vnbth-backend.onrender.com/location/locations",
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
    );
    final jsonBody = jsonDecode(response.body);

    if (jsonBody['status'] == 'success') {
      final List<dynamic> data = jsonBody['data'];
      _value.locationDataList = data
          .map((e) => LocationModel.fromJson(e))
          .toList();
      prefs.setString(
        "cached_locationData",
        jsonEncode(_value.locationDataList.map((e) => e.toJson()).toList()),
      );
      //print(jsonEncode(value.locationDataList.map((e) => e.toJson()).toList()));
    } else {
      throw Exception("Network error: ${jsonBody['error']['message']}");
    }
  }

  Future<void> _fetchMissionData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("User error: No token exists");
    }

    final url = Uri.parse(
      "https://vnbth-backend.onrender.com/mission/missions",
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
    );
    final jsonBody = jsonDecode(response.body);

    if (jsonBody['status'] == 'success') {
      final List<dynamic> dataList = jsonBody['data'];
      _value.missionList = dataList
          .map((e) => MissionModel.fromJson(e))
          .toList();
      prefs.setString(
        "cached_missions",
        jsonEncode(_value.missionList.map((e) => e.toJson()).toList()),
      );
    } else {
      throw Exception("Network error: ${jsonBody['error']['message']}");
    }
  }

  Future<void> fetchCoordinates(String locationName) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(locationName)}&format=json&limit=1",
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'my_map/1.0 (khangthinh111555@gmail.com)'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        _value.destination = LatLng(lat, lon);
        await fetchRoute(_value.currentLocation, _value.destination);
        resetMap();
      } else {
        throw Exception("Location not found.");
      }
    } else {
      throw Exception("Failed to fetch location.");
    }
  }

  Future<void> fetchRoute(LatLng? start, LatLng? end) async {
    if (start == null || end == null) return;

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=polyline&alternatives=false&annotations=distance',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
  }

  Future<void> fetchFullRoute({List<LocationModel>? route}) async {
    route ??= _value.locationList;
    if (route.length < 2) return;

    List<LatLng> fullRoute = [];
    LatLng end = _value.currentLocation!;
    for (int i = 0; i < route.length; i++) {
      final start = end;
      end = LatLng(route[i].latitude, route[i].longitude);

      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=polyline',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final geometry = data['routes'][0]['geometry'];

        final List<LatLng> decodedRoute = await compute<String, List<LatLng>>(
          _decodePolyline,
          geometry,
        );

        if (i > 0) decodedRoute.removeAt(0);

        fullRoute.addAll(decodedRoute);
      } else {
        throw Exception('Failed to fetch route between $i and ${i + 1}');
      }
    }
    _value.routes = fullRoute;
    resetMap();
    throw Exception("Full route length: ${fullRoute.length} points");
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
        ),
      ),
    );
  }

  void nextMission() {
    if (_value.currentIndex >= userRoute.length) return;
    _value.currentIndex++;
    if (_value.currentIndex == userRoute.length)
      completeRoute();
    else
      resetMap();
  }

  void completeRoute() {}

  void updateMissionImage(String missionId, String imagePath) {
    for (var m in _value.missionList) {
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
