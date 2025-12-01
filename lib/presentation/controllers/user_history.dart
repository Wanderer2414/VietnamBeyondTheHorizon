import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';

class UserHistoryManager {
  static final UserHistoryManager _instance = UserHistoryManager._internal();
  factory UserHistoryManager() => _instance;
  UserHistoryManager._internal();

  Map<String, List<String>> _historyMap = {};
  List<String> _videoUrls = [];

  List<String> get historyPhotos =>
      _historyMap.values.expand((listImages) => listImages).toList();
  List<String> get completedMissionIds => _historyMap.keys.toList();
  List<String> get videoUrls => _videoUrls;

  Future<void> syncHistory() async {
    try {
      final visits = await NetworkProxy.fetchVisits();

      _historyMap.clear();

      for (var visit in visits) {
        String mID = visit.missionId.toString();
        if (visit.imageUrls.isNotEmpty) {
          _historyMap[mID] = visit.imageUrls;
        }
      }

      //FETCH VIDEO URLS
      _videoUrls = await NetworkProxy.fetchVideoUrls();

      saveLocalHistory();
      print("sync with ${_historyMap.length}");
      print("sync with ${_videoUrls.length}");
    } catch (e) {
      print("Error sync history: $e");
    }
  }

  Future<void> loadLocalHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('user_history_cache');
    final String? video = prefs.getString('user_video_urls');

    if (raw != null) {
      try {
        Map<String, dynamic> decoded = jsonDecode(raw);
        _historyMap = decoded.map((key, value) {
          List<String> listUrls = (value as List)
              .map((e) => e.toString())
              .toList();
          return MapEntry(key, listUrls);
        });
        print("loaded ${_historyMap.length}.");
      } catch (e) {
        print("Error getting cache history");
      }
    }

    if (video != null) {
      try {
        final List<dynamic> decoded = jsonDecode(video);

        _videoUrls = decoded.map((e) => e.toString()).toList();

        print("loaded video urls ${_videoUrls.length}.");
      } catch (e) {
        print("Error getting cache history");
      }
    }
  }

  Future<void> saveLocalHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_history_cache', jsonEncode(_historyMap));
    await prefs.setString('user_video_urls', jsonEncode(_videoUrls));
  }

  bool hasCompletedBefore(String missionId) {
    return _historyMap.containsKey(missionId);
  }

  void addPhoto(String missionId, String newUrl) {
    if (_historyMap.containsKey(missionId)) {
      _historyMap[missionId]!.add(newUrl);
    } else {
      _historyMap[missionId] = [newUrl];
    }
    saveLocalHistory();
  }

  void addVideoUrl(String newUrl) {
    _videoUrls.add(newUrl);
    saveLocalHistory();
  }
}
