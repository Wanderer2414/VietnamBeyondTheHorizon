import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';

class GameProgressManager {
  static final GameProgressManager _instance = GameProgressManager._internal();
  factory GameProgressManager() => _instance;
  GameProgressManager._internal();
  int currentIndex = 0;
  List<LocationModel> userRoute = [];
  List<String> _completedMissionIds = [];
  Map<String, String> _missionPhotos = {};

  int _collectedStars = 0;

  int get collectedStars => _collectedStars;

  List<String> get completedMissionID => _completedMissionIds;
  Future<void> addStars(int amount) async {
    _collectedStars += amount;
    await saveProgress();
    print("Session Stars: $_collectedStars");
  }

  String? getPhotoUrl(String missionId) => _missionPhotos[missionId];

  bool get isFinished =>
      userRoute.isNotEmpty && currentIndex >= userRoute.length;

  int get numberMissionCompleted => _completedMissionIds.length;
  int get numberImageSubmited => _missionPhotos.length;
  LocationModel? get currentTarget =>
      (userRoute.isNotEmpty && currentIndex < userRoute.length)
      ? userRoute[currentIndex]
      : null;

  bool isLocked(LocationModel location) {
    final indexInRoute = userRoute.indexWhere((e) => e.id == location.id);

    if (indexInRoute != -1 && indexInRoute > currentIndex) {
      return true;
    }
    return false;
  }

  List<List<String>> getOrderedPhotos() {
    List<String> urls = [];
    List<String> locations = [];

    for (var location in userRoute) {
      if (location.currentMissionID != null) {
        String? url = _missionPhotos[location.currentMissionID];
        if (url != null) {
          urls.add(url);
          locations.add(location.id);
        }
      } else {
        for (var mid in location.missionID) {
          if (_missionPhotos.containsKey(mid)) {
            urls.add(_missionPhotos[mid]!);
            locations.add(location.id);
            break;
          }
        }
      }
    }

    print("urls: ${jsonEncode(urls)}");
    print("urls: ${jsonEncode(locations)}");
    return [urls, locations];
  }

  Future<void> saveMissionPhoto(String missionId, String url) async {
    _missionPhotos[missionId] = url;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mission_photos', jsonEncode(_missionPhotos));

    print("Saved Photo URL for Mission $missionId: $url");
  }

  bool isMissionCompleted(String missionId) {
    return _completedMissionIds.contains(missionId);
  }

  Future<void> markAsCompleted(String missionId) async {
    if (!_completedMissionIds.contains(missionId)) {
      _completedMissionIds.add(missionId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_missions', _completedMissionIds);
      print("Saved Mission: $missionId");
    }
  }

  Future<void> resetProgress() async {
    _completedMissionIds.clear();
    _missionPhotos.clear();
    currentIndex = 0;
    userRoute.clear();
    _collectedStars = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('completed_missions');
    await prefs.remove('game_progress');
    await prefs.remove('mission_photos');
  }

  void startGame(List<LocationModel> route) {
    userRoute = route;
    currentIndex = 0;
    saveProgress();
  }

  void nextStage() {
    if (currentIndex < userRoute.length) {
      currentIndex++;
      saveProgress();
    }
  }

  int? getSequenceNumber(LocationModel location) {
    final index = userRoute.indexWhere((e) => e.id == location.id);
    if (index != -1) {
      return index + 1;
    }
    return null;
  }

  MarkerAppearance getMarkerAppearance({
    LocationModel? location,
    bool isGameMode = false,
  }) {
    if (location == null) {
      return MarkerAppearance(
        color: Colors.grey.shade700,
        icon: Icons.not_listed_location,
      );
    }
    final indexInRoute = userRoute.indexWhere((e) => e.id == location.id);

    if (indexInRoute == -1) {
      return _getDefaultMarker(location.type);
    }

    if (isGameMode == false) {
      return MarkerAppearance(
        color: const Color.fromRGBO(233, 43, 43, 1),
        size: 50,
        icon: Icons.location_on_sharp,
        sequenceNumber: indexInRoute + 1,
      );
    }

    if (indexInRoute < currentIndex) {
      return MarkerAppearance(
        color: ColorPalette.successColor,
        // icon: Icons.location_pin,
        size: 40,
      );
    }
    if (indexInRoute == currentIndex) {
      return MarkerAppearance(
        color: const Color.fromARGB(255, 230, 131, 39),
        size: 50,
        shouldPulse: true,
        icon: Icons.my_location_rounded,
      );
    }

    return MarkerAppearance(
      color: Colors.grey.shade700,
      icon: Icons.lock,
      size: 35,
    );
  }

  MarkerAppearance _getDefaultMarker(String type) {
    switch (type) {
      case "Entertainment":
        return MarkerAppearance(color: ColorPalette.entertainment);
      case "Culture":
        return MarkerAppearance(color: ColorPalette.culture);
      case "Attraction":
        return MarkerAppearance(color: ColorPalette.attraction);
      case "Food":
        return MarkerAppearance(color: ColorPalette.food);
      default:
        return MarkerAppearance();
    }
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'currentIndex': currentIndex,
      'stars': _collectedStars,
      'route': userRoute.map((e) => e.toJson()).toList(),
    };
    await prefs.setString('game_progress', jsonEncode(data));
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? prog = prefs.getString('game_progress');
    _completedMissionIds = prefs.getStringList('completed_missions') ?? [];

    print("COMPLETED MISSIONS: $_completedMissionIds");
    final String? photosRaw = prefs.getString('mission_photos');
    if (photosRaw != null) {
      try {
        Map<String, dynamic> decoded = jsonDecode(photosRaw);
        _missionPhotos = decoded.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      } catch (e) {
        print("Lỗi load photos: $e");
      }
    }
    if (prog != null) {
      try {
        final data = jsonDecode(prog);
        currentIndex = data['currentIndex'] ?? 0;
        _collectedStars = data['stars'] ?? 0;
        final List routeData = data['route'] ?? [];
        userRoute = routeData.map((e) => LocationModel.fromJson(e)).toList();
      } catch (e) {
        print("Load progress error: $e");
      }
    }
  }
}
