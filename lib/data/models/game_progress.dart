import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';

class GameRoute {
  late final List<MissionModel> _missions;
  int _currentIndex = 0;
  GameRoute({List<MissionModel>? missions}) {
    if (missions != null) _missions = missions;
  }

  List<MissionModel> get missions => _missions;

  bool get _isFinished {
    return (_currentIndex != 0) && (_missions.length == _currentIndex);
  }

  MissionModel? get _currentTarget {
    if (_missions.isNotEmpty && _currentIndex < _missions.length)
      return _missions[_currentIndex];
    else
      return null;
  }

  int index(int id) {
    return _missions.indexWhere((element) => id == element.id);
  }

  bool _isLocked(int id) {
    final indexInRoute = _missions.indexWhere((e) => e.id == id);

    if (indexInRoute != -1 && indexInRoute > _currentIndex) {
      return true;
    }
    return false;
  }

  bool _next() {
    if (_currentIndex < _missions.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'progress': _missions.map((e) => e.id).toList(),
      'current': _currentIndex,
    };
  }

  static Future<GameRoute> fromJson(Map<String, dynamic> json) async {
    final missions = await NetworkProxy.missions;
    List<int> list = (json['progress'] as List<dynamic>)
        .map((e) => e as int)
        .toList();
    GameRoute route = GameRoute();
    route._missions = list.map((e) => missions[e]!).toList();
    route._currentIndex = json['current'] as int;
    return route;
  }
}

class GameProgressManager {
  late final GameRoute _userRoute;
  GameProgressManager() {}

  bool get isFinished => _userRoute._isFinished;
  bool isLocked(int id) => _userRoute._isLocked(id);
  MissionModel? get currentTarget => _userRoute._currentTarget;
  List<MissionModel> get missions => _userRoute.missions;

  Future<void> startRoute(GameRoute route) async {
    NetworkProxy.saveRoute(route);
    _userRoute = route;
  }

  bool nextStage() {
    if (_userRoute._next()) {}
    return false;
  }
  // if (currentIndex < _userRoute.length) {
  //   currentIndex++;
  // saveProgress();
  // }

  // }

  int? getSequenceNumber(int id) {
    // final index = _userRoute.indexWhere((e) => e == id);
    // if (index != -1) {
    //   return index + 1;
    // }
    // return null;
    return _userRoute._currentIndex + 1;
  }

  static MarkerAppearance getLocationAppearance({LocationModel? model}) {
    return MarkerAppearance(
      color: const Color.fromRGBO(233, 43, 43, 1),
      size: 50,
      icon: Icons.location_on_sharp,
    );
  }

  MarkerAppearance getMissionAppearance({required MissionModel mission}) {
    final indexInRoute = _userRoute.index(mission.id);

    if (indexInRoute == -1) {
      return getDefaultMarker(mission.location!.type);
    }

    if (indexInRoute < _userRoute._currentIndex) {
      return MarkerAppearance(color: const Color.fromARGB(255, 132, 244, 3));
    }
    if (indexInRoute == _userRoute._currentIndex) {
      return MarkerAppearance(
        color: const Color.fromARGB(255, 50, 153, 212),
        size: 55,
        shouldPulse: true,
      );
    }

    return MarkerAppearance(
      color: Colors.grey.shade700,
      icon: Icons.not_listed_location,
    );
  }

  static MarkerAppearance getDefaultMarker(String type) {
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
    // final prefs = await SharedPreferences.getInstance();
    // final data = {
    //   'currentIndex': currentIndex,
    //   'route': userRoute.map((e) => e.toJson()).toList(),
    // };
    // await prefs.setString('game_progress', jsonEncode(data));
  }

  Future<void> loadProgress() async {
    // final prefs = await SharedPreferences.getInstance();
    // final String? prog = prefs.getString('game_progress');

    // if (prog != null) {
    //   try {
    //     final data = jsonDecode(prog);
    //     currentIndex = data['currentIndex'] ?? 0;
    //     final List routeData = data['route'] ?? [];
    //     userRoute = routeData.map((e) => LocationModel.fromJson(e)).toList();
    //   } catch (e) {
    //     print("Load progress error: $e");
    //   }
    // }
  }
}
