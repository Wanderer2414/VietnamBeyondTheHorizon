import 'package:latlong2/latlong.dart';

class LocationModel {
  final String id;
  final String name;
  final String address;
  final String type;
  final String description;
  final String openTime;
  final String closeTime;
  final String price;
  final List<String> imageURLs;
  final List<String> missionID;
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
