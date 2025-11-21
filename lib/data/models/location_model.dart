import 'package:latlong2/latlong.dart';

class LocationModel {
  final int id;
  final String name;
  final String address;
  final String type;
  final String description;
  final String openTime;
  final String closeTime;
  final double price;
  final List<String> imageURLs;
  final List<int> missionID;
  final double latitude;
  final double longitude;

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
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      price: (json['price'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageURLs: (json['images'] as List<dynamic>)
          .map((e) => e['url'] as String)
          .toList(),
      missionID: (json['missions'] as List<dynamic>)
          .map((e) => e['id'] as int)
          .toList(),
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
    'latitude': latitude,
    'longitude': longitude,
    'images': imageURLs.map((url) => {'url': url}).toList(),
    'missions': missionID.map((id) => {'id': id}).toList(),
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
