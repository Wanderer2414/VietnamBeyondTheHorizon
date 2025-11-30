import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';

class UserHistoryManager {
  static final UserHistoryManager _instance = UserHistoryManager._internal();
  factory UserHistoryManager() => _instance;
  UserHistoryManager._internal();

  Map<String, String> _historyMap = {};

  List<String> get historyPhotos => _historyMap.values.toList();
  List<String> get completedMissionIds => _historyMap.keys.toList();
  Future<void> syncHistory() async {
    try {
      final visits = await NetworkProxy.fetchVisits();

      _historyMap.clear();

      for (var visit in visits) {
        String mID = visit.missionId.toString();
        if (visit.imageUrl != null) {
          _historyMap[mID] = visit.imageUrl!;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_history_cache', jsonEncode(_historyMap));

      print("sync with ${_historyMap.length}");
    } catch (e) {
      print("Error sync history: $e");
    }
  }

  Future<void> loadLocalHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('user_history_cache');

    if (raw != null) {
      try {
        Map<String, dynamic> decoded = jsonDecode(raw);
        _historyMap = decoded.map((k, v) => MapEntry(k, v.toString()));
        print("loaded ${_historyMap.length}.");
      } catch (e) {
        print("Error getting cache history");
      }
    }
  }

  bool hasCompletedBefore(String missionId) {
    return _historyMap.containsKey(missionId);
  }
}
