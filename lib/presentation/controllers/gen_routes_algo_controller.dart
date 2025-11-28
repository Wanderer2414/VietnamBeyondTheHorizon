import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:flutter/material.dart';

class RouteResult {
  final String locationId;
  final String missionId;

  RouteResult({required this.locationId, required this.missionId});

  @override
  String toString() => 'Location: $locationId, Mission: $missionId';
}

class RoutePlannerService {
  final Distance _distance = Distance();

  /// Tính khoảng cách giữa 2 điểm GPS (meters)
  double calculateDistance(LatLng point1, LatLng point2) {
    return _distance.as(LengthUnit.Meter, point1, point2);
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
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Kiểm tra giá phù hợp với ngân sách
  bool isPriceAffordable(LocationModel location, double budget) {
    try {
      if (location.price.toLowerCase() == 'free') return true;
      final price = double.parse(
        location.price.replaceAll('.', '').replaceAll(',', ''),
      );
      return price <= budget;
    } catch (e) {
      return true;
    }
  }

  /// Lọc địa điểm theo điều kiện - TRẢ VỀ TẤT CẢ NẾU KHÔNG CÓ ĐỦ ĐIỀU KIỆN
  List<LocationModel> filterLocations({
    required List<LocationModel> allLocations,
    required LatLng userGPS,
    required List<String> interests,
    required double budget,
    required double maxDuration,
    DateTime? currentTime,
    bool strictMode = false, // Chế độ nghiêm ngặt
  }) {
    currentTime ??= DateTime.now();

    // Lọc nghiêm ngặt theo tất cả tiêu chí
    List<LocationModel> strictFiltered = allLocations.where((location) {
      if (interests.isNotEmpty && !interests.contains(location.type))
        return false;
      if (!isPriceAffordable(location, budget)) return false;
      if (!isLocationOpen(location, currentTime!)) return false;
      return true;
    }).toList();

    if (strictFiltered.isNotEmpty || strictMode) {
      return strictFiltered;
    }

    // Nếu không có kết quả, thử lọc lỏng hơn (bỏ qua giờ mở cửa)
    List<LocationModel> relaxedFiltered = allLocations.where((location) {
      if (interests.isNotEmpty && !interests.contains(location.type))
        return false;
      if (!isPriceAffordable(location, budget)) return false;
      return true;
    }).toList();

    if (relaxedFiltered.isNotEmpty) {
      return relaxedFiltered;
    }

    // Nếu vẫn không có, chỉ lọc theo interest
    List<LocationModel> interestOnly = allLocations.where((location) {
      if (interests.isNotEmpty && !interests.contains(location.type))
        return false;
      return true;
    }).toList();

    if (interestOnly.isNotEmpty) {
      return interestOnly;
    }

    // Cuối cùng, trả về tất cả locations sẵn có
    return allLocations;
  }

  /// Thuật toán tìm đường tối ưu - LUÔN TRẢ VỀ KẾT QUẢ
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

    // Kiểm tra dataset có rỗng không
    if (allLocations.isEmpty) {
      return [];
    }

    // Bước 1: Lọc địa điểm phù hợp (relaxed filtering)
    List<LocationModel> filteredLocations = filterLocations(
      allLocations: allLocations,
      userGPS: userGPS,
      interests: interests,
      budget: budget,
      maxDuration: maxDuration,
      currentTime: startTime,
      strictMode: false, // Cho phép lọc lỏng
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

    // Bước 3: Greedy algorithm - chọn địa điểm tốt nhất có thể
    List<RouteResult> route = [];
    LatLng currentPosition = userGPS;
    double remainingTime = maxDuration;
    double remainingBudget = budget;
    Set<String> visitedTypes = {};
    DateTime currentTime = startTime;

    // Tạo bản sao để không làm thay đổi list gốc
    List<LocationModel> availableLocations = List.from(filteredLocations);

    while (availableLocations.isNotEmpty && route.length < 6) {
      LocationModel? bestLocation;
      double bestScore = -1;
      bool foundAffordable = false;

      for (var location in availableLocations) {
        // Tính thời gian cần thiết
        double distance = calculateDistance(
          currentPosition,
          LatLng(location.latitude, location.longitude),
        );
        double travelTime = calculateTravelTime(distance);

        // Lấy mission
        if (location.missionID.isEmpty) continue;

        String missionId =
            location.missionID[Random().nextInt(location.missionID.length)];
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

        // Kiểm tra budget
        bool canAfford = isPriceAffordable(location, remainingBudget);

        // Nếu đã hết thời gian và budget - dừng tìm
        if (totalTime > remainingTime && !canAfford) continue;

        // Ưu tiên location vừa đủ thời gian VÀ budget
        bool meetsAllCriteria = totalTime <= remainingTime && canAfford;

        if (meetsAllCriteria) foundAffordable = true;

        // Kiểm tra giờ mở cửa (lỏng lẻo hơn)
        DateTime arrivalTime = currentTime.add(
          Duration(minutes: travelTime.toInt()),
        );
        bool isOpen = isLocationOpen(location, arrivalTime);

        // Tính score với nhiều yếu tố
        double score = scores[location]!;

        // Bonus cho đa dạng type
        if (!visitedTypes.contains(location.type)) {
          score *= 1.5;
        }

        // Bonus cho location đáp ứng đủ điều kiện
        if (meetsAllCriteria) {
          score *= 2.0;
        }

        // Bonus nhỏ cho location mở cửa
        if (isOpen) {
          score *= 1.1;
        }

        // Penalty cho location quá xa hoặc quá tốn thời gian
        if (totalTime > remainingTime) {
          score *= 0.3;
        }

        if (score > bestScore) {
          bestScore = score;
          bestLocation = location;
        }
      }

      // Nếu không tìm thấy location nào phù hợp, dừng
      if (bestLocation == null) {
        break;
      }

      // Thêm vào route
      String selectedMissionId = bestLocation
          .missionID[Random().nextInt(bestLocation.missionID.length)];

      route.add(
        RouteResult(locationId: bestLocation.id, missionId: selectedMissionId),
      );

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

      // Cập nhật remaining
      remainingTime -= (travelTime + visitTime);
      try {
        double locationPrice = double.parse(
          bestLocation.price
              .replaceAll('.', '')
              .replaceAll(',', '')
              .toLowerCase()
              .replaceAll('free', '0'),
        );
        remainingBudget -= locationPrice;
      } catch (e) {
        // Nếu parse lỗi, giữ nguyên budget
      }

      currentPosition = LatLng(bestLocation.latitude, bestLocation.longitude);
      currentTime = currentTime.add(
        Duration(minutes: (travelTime + visitTime).toInt()),
      );
      visitedTypes.add(bestLocation.type);
      availableLocations.remove(bestLocation);

      // Nếu đã đủ thời gian cho ít nhất 1 location nữa nhưng không tìm thấy, dừng
      if (remainingTime <= 0) {
        break;
      }
    }

    return route;
  }

  /// HÀM CHÍNH: Tạo route từ UserInput - LUÔN TRẢ VỀ KẾT QUẢ
  Future<List<LocationModel>> generateRouteFromUserInput({
    required LatLng userGPS,
    required List<String> selectedInterests,
    required double budget,
    required int durationDays,
    required List<LocationModel> allLocations,
    required List<MissionModel> allMissions,
  }) async {
    print("---Start generating routes from user input.....-----");
    // Kiểm tra dataset
    if (allLocations.isEmpty) {
      return [];
    }
    print("---Break 1-----");

    // Chuyển đổi duration từ ngày sang phút (giả sử 8 giờ hoạt động/ngày)
    double maxDurationMinutes = durationDays * 8 * 60.0;

    // Gọi thuật toán tìm đường
    List<RouteResult> routeResults = await planOptimalRoute(
      userGPS: userGPS,
      interests: selectedInterests,
      budget: budget,
      maxDuration: maxDurationMinutes,
      allLocations: allLocations,
      allMissions: allMissions,
    );
    print("---Break 2-----");

    // Nếu không tìm thấy route nào, trả về top 5-6 locations gần nhất
    if (routeResults.isEmpty) {
      // Sắp xếp theo khoảng cách
      List<LocationModel> sortedByDistance = List.from(allLocations);
      sortedByDistance.sort((a, b) {
        double distA = calculateDistance(
          userGPS,
          LatLng(a.latitude, a.longitude),
        );
        double distB = calculateDistance(
          userGPS,
          LatLng(b.latitude, b.longitude),
        );
        return distA.compareTo(distB);
      });

      // Lấy tối đa 6 locations
      List<LocationModel> fallbackLocations = sortedByDistance.take(6).toList();
      print("---Break 3: route res is empty-----");

      return fallbackLocations;
    }

    // Chuyển đổi RouteResult thành List<LocationModel>
    List<LocationModel> selectedLocations = [];
    for (var result in routeResults) {
      LocationModel? location = allLocations.firstWhere(
        (loc) => loc.id == result.locationId,
        orElse: () => LocationModel(
          id: '',
          name: '',
          address: '',
          type: '',
          description: '',
          openTime: '',
          closeTime: '',
          price: '',
          imageURLs: [],
          missionID: [],
          latitude: 0,
          longitude: 0,
        ),
      );

      if (location.id.isNotEmpty) {
        selectedLocations.add(location);
      }
    }

    // In thông tin debug
    printRouteDetails(
      route: routeResults,
      allLocations: allLocations,
      allMissions: allMissions,
      startPoint: userGPS,
    );
    print("---Break 4: Final result-----");

    return selectedLocations;
  }

  /// Helper: In thông tin chi tiết route
  void printRouteDetails({
    required List<RouteResult> route,
    required List<LocationModel> allLocations,
    required List<MissionModel> allMissions,
    required LatLng startPoint,
  }) {
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

      currentPos = LatLng(location.latitude, location.longitude);
    }
  }
}
