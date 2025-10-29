import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:polyline_codec/polyline_codec.dart';
import 'package:flutter_compass/flutter_compass.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = true;
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> _route = [];
  double _heading = 0;
  bool _mapReady = false;

  Future<void> _initializeLocation() async {
    if (!await _checkTheRequestPermission()) return;

    //Listen for location update and update the current location
    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
          isLoading = false; //stop loading after getting the location
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });

    FlutterCompass.events?.listen((event) {
      if (_mapReady == false) return;
      if (event.heading != null) {
        setState(() {
          _heading = event.heading!;
        });
        //_mapController.rotate(_heading);
      }
    });
  }

  //Method to fetch coordinated for a given location using OSM Nominatim API
  Future<void> _fetchCoordinatesPoint(String location) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(location)}&format=json&limit=1",
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
        setState(() {
          _destination = LatLng(lat, lon);
        });
        await _fetchRoute();
      } else {
        errorMessage('Location not found. Please try antother search.');
      }
    } else {
      errorMessage('Failed to fetch location. Try another later');
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _destination == null) return;

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${_currentLocation!.longitude},${_currentLocation!.latitude};${_destination!.longitude},${_destination!.latitude}'
      '?overview=full&geometries=polyline',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data['routes'][0]['geometry'];
      _decodePolyline(geometry);
    } else {
      errorMessage('Failed to fetch route. Try again later.');
    }
  }

  void _decodePolyline(String encodedPolyline) {
    final decoded = PolylineCodec.decode(encodedPolyline);

    List<LatLng> decodedPoints = decoded.map((point) {
      return LatLng(point[0].toDouble(), point[1].toDouble());
    }).toList();

    setState(() {
      _route = decodedPoints;
    });
  }

  void errorMessage(String messange) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(messange)));
  }

  //Check if user allowed app to get GPS
  Future<bool> _checkTheRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Current location not available")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("OpenStreetMap")),

        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? const LatLng(0, 0),
                    initialZoom: 2,
                    minZoom: 1,
                    maxZoom: 40,
                    initialRotation: -_heading,
                    onMapReady: () {
                      setState(() {
                        _mapReady = true;
                      });
                    },
                  ),
                  children: [
                    // TileLayer(
                    //   urlTemplate:
                    //       'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                    //   subdomains: ['a', 'b', 'c'],
                    // ),
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.yourapp', // <-- dòng này
                    ),
                    CurrentLocationLayer(
                      style: LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(Icons.location_pin, color: Colors.red),
                        ),
                        markerSize: Size(35, 35),
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),

                    if (_destination != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _destination!,
                            width: 60,
                            height: 60,
                            child: GestureDetector(
                              onTap: () {
                                print("TAP TAP TAP TAP TAP TAP");
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Bui Vien"),
                                    content: const Text(
                                      "Come here! Enjoy your life",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              },

                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 45,
                              ),
                            ),
                            // child: Transform.rotate(
                            //   angle:
                            //       0 *
                            //       ((_heading) * pi / 180), // đổi độ -> radian
                            //   child: Icon(
                            //     Icons.navigation,
                            //     size: 50,
                            //     color: Colors.blueAccent,
                            //   ),
                            // ),
                            // child: Image.asset(
                            //   'assets/images/01_location_pin.png',
                            //   fit: BoxFit.contain,
                            // ),
                          ),
                        ],
                      ),

                    if (_currentLocation != null &&
                        _destination != null &&
                        _route.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _route,
                            strokeWidth: 5,
                            color: Colors.red,
                          ),
                        ],
                      ),
                  ],
                ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter a location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      final location = _locationController.text.trim();
                      if (location.isNotEmpty) {
                        _fetchCoordinatesPoint(location);
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _userCurrentLocation,
        elevation: 0,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, size: 30, color: Colors.white),
      ),
    );
  }
}
