import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:flutter/material.dart';

class RouteResult {
  final String locationId;
  final String missionId;
  
  RouteResult({
    required this.locationId,
    required this.missionId,
  });
  
  @override
  String toString() => 'Location: $locationId, Mission: $missionId';
}

class RoutePlannerService {
  final Distance _distance = Distance();

  /// Tính khoảng cách giữa 2 điểm GPS (meters)
  double calculateDistance(LatLng point1, LatLng point2) {
    return _distance.as(
      LengthUnit.Meter,
      point1,
      point2,
    );
  }

  /// Tính thời gian di chuyển (phút) - giả sử tốc độ 40km/h
  double calculateTravelTime(double distanceMeters) {
    const double speedKmh = 40.0;
    return (distanceMeters / 1000) / speedKmh * 60; // phút
  }

  /// Tính thời gian tham quan (phút) dựa trên độ khó mission
  double calculateVisitDuration(int difficulty) {
    return difficulty * 15.0; // 15 phút cho mỗi độ khó
  }

  /// Kiểm tra địa điểm có mở cửa không
  bool isLocationOpen(LocationModel location, DateTime currentTime) {
    try {
      final open = _parseTime(location.openTime);
      final close = _parseTime(location.closeTime);
      final current = TimeOfDay.fromDateTime(currentTime);
      
      final currentMinutes = current.hour * 60 + current.minute;
      final openMinutes = open.hour * 60 + open.minute;
      final closeMinutes = close.hour * 60 + close.minute;
      
      if (closeMinutes < openMinutes) {
        // Qua đêm (vd: 18:00 - 02:00)
        return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
      }
      
      return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
    } catch (e) {
      return true; // Nếu không parse được thì cho phép
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Kiểm tra giá phù hợp với ngân sách
  bool isPriceAffordable(LocationModel location, double budget) {
    try {
      if (location.price.toLowerCase() == 'free') return true;
      final price = double.parse(location.price.replaceAll('.', '').replaceAll(',', ''));
      return price <= budget;
    } catch (e) {
      return true;
    }
  }

  /// Lọc địa điểm theo điều kiện
  List<LocationModel> filterLocations({
    required List<LocationModel> allLocations,
    required LatLng userGPS,
    required List<String> interests,
    required double budget,
    required double maxDuration,
    DateTime? currentTime,
  }) {
    currentTime ??= DateTime.now();
    
    return allLocations.where((location) {
      // Kiểm tra interest
      if (!interests.contains(location.type)) return false;
      
      // Kiểm tra giá
      if (!isPriceAffordable(location, budget)) return false;
      
      // Kiểm tra giờ mở cửa
      if (!isLocationOpen(location, currentTime!)) return false;
      
      return true;
    }).toList();
  }

  /// Thuật toán tìm đường tối ưu
  Future<List<RouteResult>> planOptimalRoute({
    required LatLng userGPS,
    required List<String> interests,
    required double budget,
    required double maxDuration, // phút
    required List<LocationModel> allLocations,
    required List<MissionModel> allMissions,
    DateTime? startTime,
  }) async {
    startTime ??= DateTime.now();
    
    // Bước 1: Lọc địa điểm phù hợp
    List<LocationModel> filteredLocations = filterLocations(
      allLocations: allLocations,
      userGPS: userGPS,
      interests: interests,
      budget: budget,
      maxDuration: maxDuration,
      currentTime: startTime,
    );

    if (filteredLocations.isEmpty) {
      return [];
    }

    // Bước 2: Tính điểm cho mỗi địa điểm
    Map<LocationModel, double> scores = {};
    for (var location in filteredLocations) {
      double distance = calculateDistance(
        userGPS,
        LatLng(location.latitude, location.longitude),
      );
      
      // Score: Càng gần càng tốt, ưu tiên type phù hợp
      double score = 10000 / (distance + 1); // +1 để tránh chia cho 0
      
      // Bonus cho type ưu tiên đầu tiên
      if (interests.isNotEmpty && location.type == interests[0]) {
        score *= 1.2;
      }
      
      scores[location] = score;
    }

    // Bước 3: Greedy algorithm - chọn địa điểm gần nhất có thể đi được
    List<RouteResult> route = [];
    LatLng currentPosition = userGPS;
    double remainingTime = maxDuration;
    Set<String> visitedTypes = {};
    DateTime currentTime = startTime;

    while (filteredLocations.isNotEmpty && remainingTime > 0) {
      LocationModel? bestLocation;
      double bestScore = -1;

      for (var location in filteredLocations) {
        // Tính thời gian cần thiết
        double distance = calculateDistance(
          currentPosition,
          LatLng(location.latitude, location.longitude),
        );
        double travelTime = calculateTravelTime(distance);
        
        // Lấy mission đầu tiên (hoặc random)
        if (location.missionID.isEmpty) continue;
        
        String missionId = location.missionID[Random().nextInt(location.missionID.length)];
        MissionModel? mission = allMissions.firstWhere(
          (m) => m.id == missionId,
          orElse: () => MissionModel(
            id: missionId,
            name: '',
            description: '',
            difficulty: 2,
            illustrationURL: '',
          ),
        );
        
        double visitTime = calculateVisitDuration(mission.difficulty);
        double totalTime = travelTime + visitTime;

        if (totalTime > remainingTime) continue;

        // Kiểm tra giờ mở cửa sau khi đến
        DateTime arrivalTime = currentTime.add(Duration(minutes: travelTime.toInt()));
        if (!isLocationOpen(location, arrivalTime)) continue;

        // Tính score với bonus cho đa dạng type
        double score = scores[location]!;
        if (!visitedTypes.contains(location.type)) {
          score *= 1.5; // Bonus cho type mới
        }

        if (score > bestScore) {
          bestScore = score;
          bestLocation = location;
        }
      }

      if (bestLocation == null) break;

      // Thêm vào route
      String selectedMissionId = bestLocation.missionID[
        Random().nextInt(bestLocation.missionID.length)
      ];
      
      route.add(RouteResult(
        locationId: bestLocation.id,
        missionId: selectedMissionId,
      ));

      // Cập nhật trạng thái
      double distance = calculateDistance(
        currentPosition,
        LatLng(bestLocation.latitude, bestLocation.longitude),
      );
      double travelTime = calculateTravelTime(distance);
      
      MissionModel? mission = allMissions.firstWhere(
        (m) => m.id == selectedMissionId,
        orElse: () => MissionModel(
          id: selectedMissionId,
          name: '',
          description: '',
          difficulty: 2,
          illustrationURL: '',
        ),
      );
      
      double visitTime = calculateVisitDuration(mission.difficulty);
      
      remainingTime -= (travelTime + visitTime);
      currentPosition = LatLng(bestLocation.latitude, bestLocation.longitude);
      currentTime = currentTime.add(Duration(minutes: (travelTime + visitTime).toInt()));
      visitedTypes.add(bestLocation.type);
      filteredLocations.remove(bestLocation);

      // Giới hạn 5-6 địa điểm
      if (route.length >= 6) break;
    }

    return route;
  }

  /// Helper: In thông tin chi tiết route
  void printRouteDetails({
    required List<RouteResult> route,
    required List<LocationModel> allLocations,
    required List<MissionModel> allMissions,
    required LatLng startPoint,
  }) {
    print('\n=== ROUTE PLAN ===');
    print('Total locations: ${route.length}\n');

    LatLng currentPos = startPoint;
    double totalDistance = 0;
    double totalTime = 0;

    for (int i = 0; i < route.length; i++) {
      var result = route[i];
      var location = allLocations.firstWhere((l) => l.id == result.locationId);
      var mission = allMissions.firstWhere((m) => m.id == result.missionId);

      double distance = calculateDistance(
        currentPos,
        LatLng(location.latitude, location.longitude),
      );
      double travelTime = calculateTravelTime(distance);
      double visitTime = calculateVisitDuration(mission.difficulty);

      totalDistance += distance;
      totalTime += (travelTime + visitTime);

      print('${i + 1}. ${location.name}');
      print('   Type: ${location.type}');
      print('   Address: ${location.address}');
      print('   Price: ${location.price}');
      print('   Open: ${location.openTime} - ${location.closeTime}');
      print('   Distance from previous: ${(distance / 1000).toStringAsFixed(2)} km');
      print('   Travel time: ${travelTime.toStringAsFixed(0)} min');
      print('   Mission: ${mission.name} (Difficulty: ${mission.difficulty})');
      print('   Visit duration: ${visitTime.toStringAsFixed(0)} min');
      print('');

      currentPos = LatLng(location.latitude, location.longitude);
    }

    print('=== SUMMARY ===');
    print('Total distance: ${(totalDistance / 1000).toStringAsFixed(2)} km');
    print('Total time: ${totalTime.toStringAsFixed(0)} minutes (${(totalTime / 60).toStringAsFixed(1)} hours)');
  }
}