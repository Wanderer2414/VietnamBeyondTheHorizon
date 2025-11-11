import 'package:latlong2/latlong.dart';

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

  final String missionID; // "101"
  final double latitude; // "10.0001010"
  final double longitude; // "20.1234123"

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
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      type: json['type'],
      description: json['description'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      price: json['price'],
      imageURLs: List<String>.from(json['imageURLs']),
      missionID: json['missionID'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'type': type,
    'description': description,
    'openTime': openTime,
    'closeTime': closeTime,
    'price': price,
    'imageURLs': imageURLs,
    'missionID': missionID,
    'latitude': latitude,
    'longitude': longitude,
  };

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
}
