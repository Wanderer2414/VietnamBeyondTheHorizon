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
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/map_state.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/mission_screen.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_share.dart';

class MyMapController {
  final MapController mapController = MapController();
  final Location location = Location();
  MapState value = MapState();
  void Function()? resetMap;

  //___________________TEST____________________
  // late List<MissionModel> missionList;
  List<MissionModel> missionList = [
    MissionModel(
      id: "101",
      name: "Hello nana",
      description: "Take a photo involving yourself and the given image",
      difficulty: 2,
      illustrationURL:
          "https://static.vinwonders.com/production/pho-tay-bui-vien-3.jpg",
    ),
    MissionModel(
      id: "102",
      name: "Hello baba",
      description:
          "Take a photo involving yourself and the given image, and dance under the tree",
      difficulty: 4,
      illustrationURL:
          "https://cdn.thuvienphapluat.vn/uploads/tintuc/2025/07/17/truong-dai-hoc-khoa-hoc-tu-nhien-dhqg-tphcm.jpg",
    ),
  ];

  MyMapController() {
    _initialize();
  }

  void _initialize() async {
    await _loadProgress();
    // await _fetchLocationData();
    // if (!kIsWeb) {
    //   FlutterCompass.events?.listen((event) {
    //     if (!mapReady || event.heading == null) return;
    //     value = value.copyWith(heading: event.heading!);
    //   });
    // }
    await _initLocation();
    final userGPS = await loadGPS();
    value = value.copyWith(
      currentLocation: LatLng(userGPS['lat']!, userGPS['lng']!),
    );

    final prefs = await SharedPreferences.getInstance();
    final cached_loc = prefs.getString("cached_locationData");
    final cached_mis = prefs.getString("cached_missions");
    if (cached_loc != null) {
      final data = jsonDecode(cached_loc) as List;
      value = value.copyWith(
        locationDataList: data.map((e) => LocationModel.fromJson(e)).toList(),
      );
    } else {
      await _fetchLocationData();
    }
    if (cached_mis != null) {
      final data = jsonDecode(cached_mis) as List;

      missionList = data.map((e) => MissionModel.fromJson(e)).toList();
    } else {
      await _fetchMissionData();
    }
  }

  Future<void> _initLocation() async {
    if (!await _checkPermission()) return;

    final locData = await location.getLocation();
    if (locData.latitude != null && locData.longitude != null) {
      value = value.copyWith(
        currentLocation: LatLng(locData.latitude!, locData.longitude!),
        isLoading: false,
      );
      saveGPS(locData.latitude!, locData.longitude!);
      saveProgress();
    }

    location.onLocationChanged.listen((loc) {
      if (loc.latitude != null && loc.longitude != null) {
        value = value.copyWith(
          currentLocation: LatLng(loc.latitude!, loc.longitude!),
        );
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
    final jsonString = jsonEncode(value.toJson());
    await prefs.setString('map_progress', jsonString);
    // debugPrint("Progress saved: $jsonString");
  }

  Future<String> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('map_progress');
    if (jsonString == null) return "";

    try {
      final data = jsonDecode(jsonString);
      value = MapState.fromJson(data);
      return "";
    } catch (e) {
      return "Failed to load progress: $e";
    }
  }

  MapOptions mapOptions({
    required Function() onMapReady,
    required BuildContext context,
  }) {
    return MapOptions(
      initialCenter:
          value.currentLocation ?? const LatLng(10.762622, 106.660172),
      initialZoom: 15,
      minZoom: 8,
      maxZoom: 15,
      onTap: (tapPosition, point) => {
        toggleMissionCard(null, context),
      },
      onMapReady: onMapReady,
    );
  }

  List<Widget> mapLayers(BuildContext context) {
    final layers = <Widget>[
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.my_map',
      ),
    ];

    if (value.routes != null && value.routes!.isNotEmpty) {
      layers.add(
        PolylineLayer(
          polylines: [
            Polyline(points: value.routes!, strokeWidth: 5, color: Colors.red),
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
        locations: value.locationDataList,
        onMarkerTap: toggleMissionCard,
        onMovingToLocation: moveToLocation,
      ),
    );
    return layers;
  }

  Future<String> _fetchLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return "User error: No token exists";
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
      value = value.copyWith(
        locationDataList: data.map((e) => LocationModel.fromJson(e)).toList(),
      );
      prefs.setString(
        "cached_locationData",
        jsonEncode(value.locationDataList.map((e) => e.toJson()).toList()),
      );
      return "";
      //print(jsonEncode(value.locationDataList.map((e) => e.toJson()).toList()));
    } else {
      return "Network error: ${jsonBody['error']['message']}";
    }
  }

  Future<String> _fetchMissionData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return "User error: No token exists";
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
      missionList = dataList.map((e) => MissionModel.fromJson(e)).toList();
      prefs.setString(
        "cached_missions",
        jsonEncode(missionList.map((e) => e.toJson()).toList()),
      );
      return "";
    } else {
      return "Network error: ${jsonBody['error']['message']}";
    }
  }

  Future<String> fetchCoordinates(String locationName) async {
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
        value = value.copyWith(destination: LatLng(lat, lon));
        await fetchRoute(value.currentLocation, value.destination);
        if (resetMap!=null) resetMap!();
        return "";
      } else {
        return "Location not found.";
      }
    } else {
      return "Failed to fetch location.";
    }
  }

  Future<String> fetchRoute(LatLng? start, LatLng? end) async {
    if (start == null || end == null) return "";

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
      value = value.copyWith(routes: decodedRoute);
      return "";
    } else {
      return 'Failed to fetch route.';
    }
  }

  Future<String> fetchFullRoute({List<LocationModel>? route}) async {
    route ??= value.locationList;
    if (route.length < 2) return "";

    List<LatLng> fullRoute = [];
    LatLng end = value.currentLocation!;
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
        return 'Failed to fetch route between $i and ${i + 1}';
      }
    }
    value = value.copyWith(routes: fullRoute);
    if (resetMap!=null) resetMap!();
    return "Full route length: ${fullRoute.length} points";
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
    if (value.currentLocation != null) {
      mapController.move(value.currentLocation!, 15);
      return "";
    } else {
      return "Current location not available";
    }
  }

  void moveToLocation(LatLng destination, double zoom) {
    mapController.move(destination, zoom);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void toggleMissionCard(LocationModel? location, BuildContext context) {
    if (location != null) {
      Navigator.of(context).push(
        ApearAnimation(
          opaque: false,
          nextScreen: MissionScreen(controller: this, locationModel: location,onNavigate: (location) => Navigator.of(context).pop(),),
        ),
      );
    }
  }

  void updateMissionImage(String missionId, String imagePath) {
    for (var m in missionList) {
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
