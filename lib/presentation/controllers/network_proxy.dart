import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_cookies.dart';

class NetworkProxy {
  late Cookies _cookies;
  static NetworkProxy? _instance;
  SharedPreferences? _cache;
  Timer? _cancelTimer;
  NetworkProxy() {
    _cookies = Cookies(
      proxy: this,
      getLocation: _getAllLocation,
      getToken: _getToken,
      getMission: _getMissions,
      setToken: _setToken,
      getAcount: _getAccount,
      setAccount: _setAccount,
    );
  }
  static void logout() async {
    final cache = await _getCache();
    cache.clear;
    dispose();
  }

  static void dispose() {
    _instance = null;
  }

  static Future<List<LocationModel>> get locations async {
    return _getInstance()._cookies.dataLocation;
  }

  static Future<List<MissionModel>> get missions async {
    return _getInstance()._cookies.dataMission;
  }

  static Future<String> get token async {
    return _getInstance()._cookies.token;
  }

  static Future<void> Token(String t) async {
    await _getInstance()._cookies.Token(t);
  }

  static Future<UserAccount> get account async {
    return _getInstance()._cookies.userAccount;
  }

  static Future<void> Account(UserAccount user) async {
    await _getInstance()._cookies.Account(user);
  }

  static Future<void> _initialize() async {
    if (_instance != null) return;
    _instance = NetworkProxy();
  }

  static Future<String> _getToken() async {
    final cache = await _getCache();
    final token = cache.getString("token");
    if (token == null) throw Exception(0);
    return token;
  }

  static Future<void> _setToken(String token) async {
    final cache = await _getCache();
    cache.setString("token", token);
  }

  static NetworkProxy _getInstance() {
    if (_instance == null) _initialize();
    return _instance!;
  }

  static Future<SharedPreferences> _getCache() async {
    final instance = _getInstance();
    //Reset time to delete for each call
    instance._cancelTimer?.cancel();
    instance._cancelTimer = Timer(const Duration(minutes: 1), () {
      _instance?._cache = null;
      _instance?._cancelTimer = null;
    });
    //Get cache
    if (instance._cache == null)
      instance._cache = await SharedPreferences.getInstance();
    //Compare to last time saved
    int? oldTInt = _instance!._cache!.getInt("time");
    DateTime current = DateTime.now();
    if (oldTInt != null) {
      DateTime oldtime = DateTime.fromMillisecondsSinceEpoch(oldTInt);
      final dif = current.difference(oldtime);
      if (dif.inHours == 0) {
        return instance._cache!;
      }
      //Check cache valid by comparing to server data, if valid, reset time
    }
    //Clear if over time or invalid
    _instance!._cache!.clear();
    instance._cache!.setInt(
      "time",
      current.millisecondsSinceEpoch,
    ); //Cons: If user call it every hours, it will have never been valid checked!
    return instance._cache!;
  }

  static Future<List<LocationModel>> _getAllLocation() async {
    final cache = await _getCache();
    String? locsString = cache.getString("locs");
    if (locsString == null) {
      String token = await _getToken();

      final url = Uri.parse(
        "https://vnbth-backend.onrender.com/location/locations",
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['status'] == 'success') {
        final List<dynamic> data = jsonBody['data'];
        final dataLocation = data
            .map((e) => LocationModel.fromJson(e))
            .toList();
        cache.setString(
          "locs",
          jsonEncode(dataLocation.map((e) => e.toJson()).toList()),
        );
        return dataLocation;
      } else
        throw Exception(1);
    } else {
      final data = jsonDecode(locsString) as List;
      return data.map((e) => LocationModel.fromJson(e)).toList();
    }
  }

  static Future<UserAccount> _getAccount() async {
    final cache = await _getCache();

    final raw = cache.getString("user");
    if (raw == null) throw Exception(0);

    final data = jsonDecode(raw);
    return UserAccount.fromJson(data);
  }

  static Future<void> _setAccount(UserAccount account) async {
    final cache = await _getCache();
    cache.setString("user", jsonEncode(account));
  }

  static Future<List<MissionModel>> _getMissions() async {
    final cache = await _getCache();
    String? missesString = cache.getString("misses");
    if (missesString == null) {
      String token = await _getToken();

      final url = Uri.parse(
        "https://vnbth-backend.onrender.com/mission/missions",
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['status'] == 'success') {
        final List<dynamic> dataList = jsonBody['data'];
        final mission = dataList.map((e) => MissionModel.fromJson(e)).toList();
        cache.setString(
          "misses",
          jsonEncode(mission.map((e) => e.toJson()).toList()),
        );
        return mission;
      } else {
        throw Exception(1);
      }
    } else {
      final data = jsonDecode(missesString) as List;
      return data.map((e) => MissionModel.fromJson(e)).toList();
    }
  }
}
