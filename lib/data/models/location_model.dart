import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';

class LocationModel {
  final String id; // "1", "2",...
  final String name; // "University of Science,...."
  final String address; // "227, NVC,...."
  final String type; // "culture", "entertainment",...        FORMATED
  final String description; // "........"
  final String openTime; // "HH:mm"                           FORMATED
  final String closeTime; // "HH:mm"                          FORMATED
  final String price; // "0", "20.000"                        FORMATED
  final List<String> imageURLs; //URLs to image

  final List<String> missionID; // "101"
  String? currentMissionID;
  final double latitude; // "10.0001010"
  final double longitude; // "20.1234123"
  //trie
  LocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.description,
    required this.openTime,
    required this.closeTime,
    required this.price,
    required this.imageURLs,
    required this.missionID,
    required this.latitude,
    required this.longitude,
    this.currentMissionID,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      openTime: json['openTime'] as String? ?? '',
      closeTime: json['closeTime'] as String? ?? '',
      price: (json['price'] is num && json['price'] == 0)
          ? "Free"
          : json['price']?.toString() ?? "Free",
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      imageURLs:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e['url'] as String)
              .toList() ??
          [],
      missionID:
          (json['missions'] as List<dynamic>?)
              ?.map((e) => e['id'].toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type,
      'description': description,
      'openTime': openTime,
      'closeTime': closeTime,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'images': imageURLs.map((url) => {'url': url}).toList(),
      'missions': missionID.map((id) => {'id': id}).toList(),
    };
  }

  LatLng get coordinates {
    return LatLng(latitude, longitude);
  }

  String get markerIcon {
    switch (type) {
      // case "culture":
      //   return "assets/icons/culture.png";
      // case "entertainment":
      //   return "assets/icons/fun.png";
      // case "food":
      //   return "assets/icons/food.png";
      default:
        return "assets/icons/default.png";
    }
  }

  Color get typeColor {
    switch (type.toLowerCase()) {
      case "culture":
        return ColorPalette.culture;
      case "entertainment":
        return ColorPalette.entertainment;
      case "food":
        return ColorPalette.food;
      case "attraction":
        return ColorPalette.attraction;
      default:
        return ColorPalette.accentColor;
    }
  }

  IconData get typeIcon {
    switch (type.toLowerCase()) {
      case "culture":
        return Icons.museum;

      case "entertainment":
        return Icons.theater_comedy;

      case "food":
        return Icons.restaurant;

      case "attraction":
        return Icons.attractions;

      default:
        return Icons.category;
    }
  }
}

// {
//     "status": "success",
//     "data": [
//         {
//             "id": 1,
//             "type": "Entertainment",
//             "name": "Ben Thanh Market",
//             "address": "Le Loi Street, Ben Thanh Ward, District 1",
//             "openTime": "6:00",
//             "closeTime": "22:00",
//             "description": "Well-known standby for handicrafts, souvenirs, clothing & other goods along with local eats",
//             "price": 0,
//             "latitude": 10.77253,
//             "longitude": 106.698037,
//             "missions": [
//                 {
//                     "id": 1
//                 },
//                 {
//                     "id": 2
//                 },
//                 {
//                     "id": 3
//                 }
//             ],
//             "images": [
//                 {
//                     "url": "https://res.cloudinary.com/dggktz5oy/image/upload/v1763130752/Avatar_1_ffa4pn.jpg"
//                 }
//             ]
//         },
//         {
