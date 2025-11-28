// import 'package:shared_preferences/shared_preferences.dart';

// // Lưu data
// Future<void> saveMapState(double lat, double lng, double zoom) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setDouble('mapLat', lat);
//   await prefs.setDouble('mapLng', lng);
//   await prefs.setDouble('mapZoom', zoom);
// }

// // Lấy data
// Future<Map<String, double>> loadMapState() async {
//   final prefs = await SharedPreferences.getInstance();
//   return {
//     'lat': prefs.getDouble('mapLat') ?? 0,
//     'lng': prefs.getDouble('mapLng') ?? 0,
//     'zoom': prefs.getDouble('mapZoom') ?? 15,
//   };
// }

// Future<void> saveGPS(double lat, double lng) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('lat', lat);
//     await prefs.setDouble('lng', lng);
// }

// Future<Map<String, double>> loadGPS() async {
//   final prefs = await SharedPreferences.getInstance();
//   return {
//     'lat': prefs.getDouble('lat') ?? 0,
//     'lng': prefs.getDouble('lng') ?? 0,
//   };
// }
