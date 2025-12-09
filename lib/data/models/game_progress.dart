import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/marker_layer.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

class LocationUtils {
  static const double allowed_radus = 100.0;

  static bool isCloseEnough(LatLng userLocation, LatLng targetLocation) {
    final Distance distance = Distance();
    final double meter = distance.as(
      LengthUnit.Meter,
      userLocation,
      targetLocation,
    );
    return meter <= allowed_radus;
  }
}

class GameRoute {
  late final List<MissionModel> _missions;
  late final List<int> _missionId;
  int _currentIndex = 0;
  int _collectedStars = 0;
  bool _isCheckedIn = false;
  List<String> _checkInPhotos = [];

  bool get isCheckedIn => _isCheckedIn;
  List<String> get checkInPhotos => _checkInPhotos;

  int get numberOfMission => _missionId.length;
  int get collectedStars => _collectedStars;

  GameRoute({List<MissionModel>? missions}) {
    if (missions != null) {
      _missions = missions;
      _missionId = _missions.map((e) => e.id).toList();
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'progress': _missionId,
      'current': _currentIndex,
      'star': _collectedStars,
      'isCheckedIn': _isCheckedIn,
      'checkInPhotos': _checkInPhotos,
    };
  }

  double _dis(MissionModel model, LatLng cur) {
    LatLng des = LatLng(model.location!.latitude, model.location!.longitude);
    return (des.latitude - cur.latitude) * (des.latitude - cur.latitude) +
        (des.longitude - cur.longitude) * (des.longitude - cur.longitude);
  }

  void sort(LatLng current) {
    print(_missionId.length);
    List<MissionModel> missions = [];
    int length = _missions.length;

    for (int i = 0; i < length; i++) {
      double dis = _dis(_missions[0], current);
      int index = 0;
      for (int i = 1; i < _missions.length; i++) {
        if (_dis(_missions[i], current) < dis) {
          dis = _dis(_missions[i], current);
          index = i;
        }
      }
      missions.add(_missions[index]);
      current = LatLng(
        _missions[index].location!.latitude,
        _missions[index].location!.longitude,
      );
      _missions.removeAt(index);
    }
    _missions.clear();
    _missions.addAll(missions);
    _missionId.clear();
    _missionId.addAll(missions.map((e) => e.id));
  }

  List<MissionModel> get missions => _missions;

  static Future<GameRoute> fromJson(Map<String, dynamic> json) async {
    final missions = (await NetworkProxy.quest)!.missions;

    List<int> list = (json['progress'] as List<dynamic>)
        .map((e) => e as int)
        .toList();
    GameRoute route = GameRoute();
    route._missions = list.map((e) => missions[e]!).toList();
    route._missionId = route._missions.map((e) => e.id).toList();
    route._currentIndex = json['current'] as int;
    route._collectedStars = json['star'] as int;
    route._isCheckedIn = (json['isCheckedIn'] as bool?) ?? false;
    route._checkInPhotos =
        (json['checkInPhotos'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    return route;
  }

  bool isCurrentStepCheckedIn(int missionId) {
    int index = _missionId.indexOf(missionId);
    return (_isCheckedIn && _currentIndex == index) || (index < _currentIndex);
  }

  void setCheckedIn() {
    _isCheckedIn = true;
  }

  bool _next() {
    if (_currentIndex < _missions.length - 1) {
      _currentIndex++;
      _isCheckedIn = false;
      return true;
    }
    return false;
  }
  List<int> locationIds() {
    return missions.map((e) => e.location!.id).toList();
  }
  MissionModel? get _currentTarget {
    if (_missions.isNotEmpty && _currentIndex < _missions.length)
      return _missions[_currentIndex];
    else
      return null;
  }

  int index(int id) {
    return _missionId.indexWhere((element) => id == element);
  }

  bool _isLocationLocked(int id) {
    int index = _missionId.indexOf(id);
    return (index > _currentIndex);
  }

  void addPhoto(String path) {
    _checkInPhotos.add(path);
  }

  bool get _isFinished => _currentIndex >= _missionId.length;
  int get currentIndex => _currentIndex;

  int get currentLocationIndex => _missions[_currentIndex].location!.id;
}

class GameProgressManager {
  GameProgressManager._();
  static GameProgressManager? _progress;
  static GameProgressManager _getInstance() {
    if (_progress == null) _progress = GameProgressManager._();
    return _progress!;
  }

  int currentIndex = 0;
  GameRoute? _userRoute;

  static bool isCurrentStepCheckedIn(int missionId) =>
      _getInstance()._userRoute?.isCurrentStepCheckedIn(missionId) ?? false;
  
  static List<int> locationIDs() => _getInstance()._userRoute?.locationIds() ?? [];

  static Future<bool> checkInSuccess(String path) async {
    final instance = _getInstance();

    if (instance._userRoute != null) {
      final url = await  NetworkProxy.postCheckInPhoto(path, instance._userRoute!.currentLocationIndex);
      
      if(url != null) {
        instance._userRoute!.setCheckedIn();
        instance._userRoute!.addPhoto(url);
        NetworkProxy.setRoute(instance._userRoute!);
        return true;
      }
    }
    return false;
  }

  static List<String> get checkInPhotos => _getInstance()._userRoute?.checkInPhotos ?? [];

  bool get isFinished => _userRoute?._isFinished ?? true;
  static bool isLocationLocked(int id) =>
      _getInstance()._userRoute?._isLocationLocked(id) ?? true;

  // static bool isMissionLocked(int id) => _getInstance()._userRoute?._isMissionLocked( id) ?? true;
  static int get collectedStars => _getInstance()._userRoute!._collectedStars;
  static MissionModel get currentTarget =>
      _getInstance()._userRoute!._currentTarget!;
  static List<MissionModel> get missions =>
      _getInstance()._userRoute?._missions ?? [];
  // List<Stringre<void> saveMissionPhoto(String missionId, String url) async {
  //   _missionPhotos[missionId] = url;

  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mission_photos', jsonEncode(_missionPhotos));

  //   print("Saved Photo URL for Mission $missionId: $url");
  // }> get completedMissionID => _completedMissionIds;

  static Future<void> addStars(int amount) async {
    final instance = _getInstance();
    instance._userRoute!._collectedStars += amount;
    await NetworkProxy.setRoute(instance._userRoute!);
    print("Session Stars: ${instance._userRoute!._collectedStars}");
  }

  Future<void> nextMission() async {
    NetworkProxy.setRoute(_userRoute!);
    // final mission = _userRoute!._currentTarget!;
    // final loc = mission.location!.coordinates;
    // await fetchRoute(_currentLocation, loc);
  }

  void completeRoute(UserAccount account) {
    final route = _userRoute!;
    NetworkProxy.completeRoute(route);
    MainRoute.goResultScreen(route, account);
  }
  // String? getPhotoUrl(String missionId) => _missionPhotos[missionId];

  // bool get _isFinished {
  //   return (_currentIndex != 0) && (_missions.length == _currentIndex);
  // }
  static int get numberMissionCompleted =>
      _getInstance()._userRoute!._currentIndex + 1;
  static int get numberImageSubmited =>
      _getInstance()._userRoute!._currentIndex + 1;

  // Future<void> saveMissionPhoto(String missionId, String url) async {
  //   _missionPhotos[missionId] = url;

  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mission_photos', jsonEncode(_missionPhotos));

  //   print("Saved Photo URL for Mission $missionId: $url");
  // }

  bool isMissionCompleted(int missionId) {
    if (_userRoute == null) return false;
    int index = _userRoute!.index(missionId);
    return (index < _userRoute!._currentIndex && index != -1);
  }

  static Future<bool> startGame(GameRoute route) async {
    if (await NetworkProxy.setRoute(route)) {
      _getInstance()._userRoute = route;
      return true;
    }
    return false;
  }

  static Future<void> markAsCompleted(int missionId) async {
    final instance = _getInstance();
    if (!instance.isMissionCompleted(missionId)) {
      NetworkProxy.setRoute(instance._userRoute!);
    }
  }

  static void dispose() {
    _progress = null;
  }

  // Future<void> startRoute(GameRoute route) async {
  //   NetworkProxy.setRoute(route);
  //   _userRoute = route;
  // }

  static bool nextStage(UserAccount account) {
    final instance = _getInstance();
    if (instance._userRoute!._next()) {
      instance.nextMission();
      return true;
    } else {
      instance.completeRoute(account);
      return false;
    }
  }

  // }
  // void complete() {
  //   NetworkProxy.completeRoute(_userRoute);
  // }

  static MarkerAppearance getLocationAppearance({
    required LocationModel location,
  }) {
    final instance = _getInstance();
    int? index = -1;
    if (instance._userRoute != null) {
      for (int i = 0; (i < location.missionID.length) && (index == -1); i++) {
        index = instance._userRoute!._missionId.indexOf(location.missionID[i]);
      }
    }
    if (index == -1) index = null;

    return getDefaultMarker(location.type);
  }

  static MarkerAppearance getMissionAppearance({
    required MissionModel mission,
  }) {
    final instance = _getInstance();
    if (instance._userRoute != null) {
      final indexInRoute = instance._userRoute!.index(mission.id);
      if (indexInRoute == -1)
        return MarkerAppearance(
          color: Colors.grey.shade700,
          icon: Icons.lock,
          size: 35,
        );
      if (indexInRoute < instance._userRoute!._currentIndex) {
        return MarkerAppearance(
          color: ColorPalette.successColor,
          size: 40,
          sequenceNumber: indexInRoute + 1,
        );
      }
      if (indexInRoute == instance._userRoute!._currentIndex) {
        return MarkerAppearance(
          color: const Color.fromARGB(255, 230, 131, 39),
          size: 50,
          shouldPulse: true,
          sequenceNumber: indexInRoute + 1,
          icon: Icons.my_location_rounded,
        );
      }
    }

    return MarkerAppearance(
      color: Colors.grey.shade700,
      icon: Icons.lock,
      size: 35,
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

  // print("COMPLETED MISSIONS: $_completedMissionIds");
  // final String? photosRaw = prefs.getString('mission_photos');
  // if (photosRaw != null) {
  //   try {
  //     Map<String, dynamic> decoded = jsonDecode(photosRaw);
  //     _missionPhotos = decoded.map(
  //       (key, value) => MapEntry(key, value.toString()),
  //     );
  //   } catch (e) {
  //     print("Lỗi load photos: $e");
  //   }
  // }
}
