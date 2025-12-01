import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_cookies.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/server_proxy.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/user_history.dart';

class NetworkProxy {
  late ServerProxy _server;
  late Cookies _cookies;

  static NetworkProxy? _instance;
  SharedPreferences? _cache;
  Timer? _cancelTimer;

  static Function()? gotoLoginScreen;
  NetworkProxy() {
    _cookies = Cookies(
      proxy: this,
      getLocation: _getAllLocation,
      getMission: _getMissions,
      getAcount: _getAccount,
    );
  }
  static void clear() async {
    final cache = await _getCache();
    cache.clear();
    dispose();
  }

  static void dispose() {
    _instance = null;
  }

  static Future<List<LocationModel>> get locations async {
    return (await _getInstance())._cookies.dataLocation;
  }

  static Future<List<MissionModel>> get missions async {
    return (await _getInstance())._cookies.dataMission;
  }

  static Future<UserAccount> get account async {
    final instance = await _getInstance();
    final user = await instance._cookies.userAccount;
    return user.userAccount;
  }

  static Future<void> _initialize() async {
    if (_instance != null) return;
    _instance = NetworkProxy();
    final token = await _getToken();
    _instance!._server = ServerProxy("", logout);
    if (token != null) await _instance!._server.Token(token);
  }

  static Future<bool> signin(String email, String password) async {
    final instance = await _getInstance();
    String? token = await instance._server.signin(email, password);
    if (token != null) {
      await _setToken(token);
      return true;
    }
    return false;
  }

  static Future<bool> signup(String email, String password) async {
    final instance = await _getInstance();
    String? token = await instance._server.signup(email, password);
    if (token != null) {
      await _setToken(token);
      return true;
    }
    return false;
  }

  static void logout() {
    clear();
    gotoLoginScreen?.call();
  }

  static Future<String?> _getToken() async {
    final cache = await _getCache();
    final token = cache.getString("token");
    print("Load token: " + (token ?? ""));
    return token;
  }

  static Future<void> _setToken(String token) async {
    final cache = await _getCache();
    cache.setString("token", token);
    await UserHistoryManager().syncHistory();
  }

  static Future<NetworkProxy> _getInstance() async {
    if (_instance == null) await _initialize();
    return _instance!;
  }

  static Future<SharedPreferences> _getCache() async {
    final instance = await _getInstance();
    //Reset time to delete for each call
    instance._cancelTimer?.cancel();
    instance._cancelTimer = Timer(const Duration(minutes: 1), () {
      _instance?._cache = null;
      _instance?._cancelTimer = null;
      print("Unlink cache!");
    });
    //Get cache
    if (instance._cache == null)
      instance._cache = await SharedPreferences.getInstance();
    //Compare to last time saved
    int? oldTInt = instance._cache!.getInt("time");
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

  Future<List<LocationModel>> _getAllLocation() async {
    final cache = await _getCache();
    String? locsString = cache.getString("locs");
    late final List<LocationModel> dataLocation;
    if (locsString == null) {
      dataLocation = await _server.getAllLocation();
      cache.setString(
        "locs",
        jsonEncode(dataLocation.map((e) => e.toJson()).toList()),
      );
      return dataLocation;
    } else {
      final data = jsonDecode(locsString) as List;
      dataLocation = data.map((e) => LocationModel.fromJson(e)).toList();
    }
    return dataLocation;
  }

  Future<UserAccountCore> _getAccount() async {
    final cache = await _getCache();

    final raw = cache.getString("user");
    if (raw == null) {
      final data = await _server.getUserData();
      cache.setString("user", jsonEncode(data.toJson()));
      return data;
    }

    final data = jsonDecode(raw);
    return UserAccountCore.fromJson(data);
  }

  Future<List<MissionModel>> _getMissions() async {
    final cache = await _getCache();
    String? missesString = cache.getString("misses");
    late final List<MissionModel> missions;
    if (missesString == null) {
      missions = await _server.getAllMission();
      cache.setString(
        "misses",
        jsonEncode(missions.map((e) => e.toJson()).toList()),
      );
    } else {
      final data = jsonDecode(missesString) as List;
      missions = data.map((e) => MissionModel.fromJson(e)).toList();
    }
    return missions;
  }

  static Future<void> updateProfile(String name, int age, String city) async {
    final instance = await _getInstance();
    if (await instance._server.updateProfile(
      name: name,
      age: age,
      city: city,
    )) {
      final account = (await instance._cookies.userAccount);
      account.username = name;
      account.age = age;
      account.city;
      account.createdAt = DateTime.now();

      final cache = await _getCache();
      cache.setString("user", jsonEncode(account.toJson()));
    }
  }

  static Future<Map<String, dynamic>?> postImage({
    FormData? data,
    String type = "AI Photo",
  }) async {
    if (data == null) throw Exception("Image data is null!");
    final instance = await _getInstance();
    return await instance._server.postImage(data: data, type: type);
  }

  static Future<Map<String, dynamic>?> createVideo({
    Map<String, dynamic>? body,
  }) async {
    if (body == null) {
      print("Body is NULLL");
      return null;
    }
    final instance = await _getInstance();
    return await instance._server.createVideo(body);
  }

  static Future<bool> isLogged() async {
    final instance = await _getInstance();
    return instance._server.isLogged();
  }

  static Future<List<VisitModel>> fetchVisits() async {
    final instance = await _getInstance();
    return await instance._server.fetchVisits();
  }

  static Future<List<String>> fetchVideoUrls() async {
    return await (await _getInstance())._server.fetchVideoUrls();
  }
}


// {
//   url: string[] // Mảng các url của các ảnh generate
//   frame_index_list: number[], // Mảng các số thứ tự frame 
//   ứng với từng url ở mảng tên
//   group_num_list: number[] // Mảng số ảnh ở từng địa điểm, 
//   ví dụ [1, 1, 1], 3 địa điểm, mỗi địa điểm 1 ảnh
// }