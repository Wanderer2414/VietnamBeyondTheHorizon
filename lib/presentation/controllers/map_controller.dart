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
import 'package:flutter/foundation.dart' show kIsWeb;

class MyMapController {
  final MapController mapController = MapController();
  final Location location = Location();
  MapState value = MapState();
  bool mapReady = false;
  late BuildContext context;
  LocationModel? selectedLocation;

  //___________________TEST____________________
  final List<LocationModel> locationsList = [
    LocationModel(
      id: "1",
      name: "Bui Vien Street",
      address: "District 1, HCMC",
      type: "entertainment",
      description: "Famous nightlife street.",
      openTime: "18:00",
      closeTime: "02:00",
      price: "Free",
      imageURLs: [
        "https://vietnamnightlife.com/uploads/images/2023/05/1685518065-single_product7-phodibobuiviencover.jpg",
      ],
      missionID: ["101"],
      latitude: 10.7725,
      longitude: 106.6959,
    ),

    LocationModel(
      id: "2",
      name: "Umbalala",
      address: "District 1, HCMC",
      type: "culture",
      description: "Famous",
      openTime: "18:00",
      closeTime: "02:00",
      price: "20.000",
      imageURLs: [
        "https://lh3.googleusercontent.com/gps-cs-s/AG0ilSyAWrWppWahQZJDccRCPRX8ZIPn26P8R41au-eF1Rto6Bw_xpSeKuEikHLEI3iMq4u3uRE1bHdzqvduf0Fs5kyr_DBn7RWHT75BIUWuK2QftPbBIGn4Cku5Up25g8xYORAu2Vvs=w360-h256-p-k-no",
      ],
      missionID: ["102"],
      latitude: 10.75,
      longitude: 106.66667,
    ),
  ];

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

  MyMapController();

  void initialize(BuildContext ctx) async {
    context = ctx;
    await loadProgress();
    // await _fetchLocationData();
    // if (!kIsWeb) {
    //   FlutterCompass.events?.listen((event) {
    //     if (!mapReady || event.heading == null) return;
    //     value = value.copyWith(heading: event.heading!);
    //   });
    // }
    //await initLocation();
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
    print("Number of Missions: ${missionList.length}");
  }

  Future<void> initLocation() async {
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
    debugPrint("Progress saved: $jsonString");
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('map_progress');
    if (jsonString == null) return;

    try {
      final data = jsonDecode(jsonString);
      value = MapState.fromJson(data);
      debugPrint("Progress loaded!");
    } catch (e) {
      debugPrint("Failed to load progress: $e");
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
        toggleLocationInfoPanel(null),
        toggleMissionCard(null, context),
      },
      onMapReady: onMapReady,
    );
  }

  void onMapReady() => mapReady = true;

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
        locations: locationsList,
        onMarkerTap: toggleMissionCard,
        onMovingToLocation: moveToLocation,
      ),
    );
    return layers;
  }

  Future<void> _fetchLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      _showError("User error: No token exists");
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
      //print(jsonEncode(value.locationDataList.map((e) => e.toJson()).toList()));
    } else {
      _showError("Network error: ${jsonBody['error']['message']}");
    }
  }

  Future<void> _fetchMissionData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      _showError("User error: No token exists");
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
      print(jsonEncode(missionList.map((e) => e.toJson()).toList()));
    } else {
      _showError("Network error: ${jsonBody['error']['message']}");
    }
  }

  Future<bool> fetchCoordinates(String locationName) async {
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
        return true;
      } else {
        _showError("Location not found.");
      }
    } else {
      _showError("Failed to fetch location.");
    }
    return false;
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
      value = value.copyWith(routes: decodedRoute);
    } else {
      _showError('Failed to fetch route.');
    }
  }

  Future<void> fetchFullRoute(List<LocationModel> locations) async {
    if (locations.length < 2) return;

    List<LatLng> fullRoute = [];

    for (int i = 0; i < locations.length - 1; i++) {
      final start = LatLng(locations[i].latitude, locations[i].longitude);
      final end = LatLng(locations[i + 1].latitude, locations[i + 1].longitude);

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
        print('Failed to fetch route between ${i} and ${i + 1}');
      }
    }
    value = value.copyWith(routes: fullRoute);

    print("Full route length: ${fullRoute.length} points");
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

  void moveToCurrentLocation() {
    if (value.currentLocation != null) {
      mapController.move(value.currentLocation!, 15);
    } else {
      _showError("Current location not available");
    }
  }

  void moveToLocation(LatLng destination, double zoom) {
    mapController.move(destination, zoom);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void toggleLocationInfoPanel(LocationModel? location) {
    if (location != null) {
      selectedLocation = location;
    }
  }

  void toggleMissionCard(LocationModel? location, BuildContext context) {
    if (location != null) {
      selectedLocation = location;

      Navigator.of(context).push(
        ApearAnimation(
          opaque: false,
          nextScreen: MissionScreen(
            controller: this,
            locationModel: location,
            onNavigate: (location) => Navigator.of(context).pop(),
          ),
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
