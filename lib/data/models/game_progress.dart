import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';

class GameProgressManager {
  int currentIndex = 0;
  List<LocationModel> userRoute = [];

  bool get isFinished =>
      userRoute.isNotEmpty && currentIndex >= userRoute.length;

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

  MarkerAppearance getMarkerAppearance(LocationModel location) {
    final indexInRoute = userRoute.indexWhere((e) => e.id == location.id);

    if (indexInRoute == -1) {
      return _getDefaultColor(location.type);
    }

    if (indexInRoute < currentIndex) {
      return MarkerAppearance(color: const Color.fromARGB(255, 132, 244, 3));
    }
    if (indexInRoute == currentIndex) {
      return MarkerAppearance(
        color: const Color.fromARGB(255, 50, 153, 212),
        size: 45,
        shouldPulse: true,
      );
    }

    return MarkerAppearance(
      color: Colors.grey.shade700,
      icon: Icons.not_listed_location,
    );
  }

  MarkerAppearance _getDefaultColor(String type) {
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
      'route': userRoute.map((e) => e.toJson()).toList(),
    };
    await prefs.setString('game_progress', jsonEncode(data));
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? prog = prefs.getString('game_progress');

    if (prog != null) {
      try {
        final data = jsonDecode(prog);
        currentIndex = data['currentIndex'] ?? 0;
        final List routeData = data['route'] ?? [];
        userRoute = routeData.map((e) => LocationModel.fromJson(e)).toList();
      } catch (e) {
        print("Load progress error: $e");
      }
    }
  }
}
