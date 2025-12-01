part of proxy;

class _CacheProxy extends Proxy {
  _CacheProxy({super.subProxy});
  Timer? _cancelTimer;
  SharedPreferences? _cache;

  Future<SharedPreferences> _get() async {
    //Reset time to delete for each call
    _cancelTimer?.cancel();
    _cancelTimer = Timer(const Duration(minutes: 1), () {
      _cache = null;
      _cancelTimer = null;
      print("Unlink cache!");
    });
    //Get cache
    if (_cache == null) _cache = await SharedPreferences.getInstance();
    //Compare to last time saved
    int? oldTInt = _cache!.getInt("time");
    DateTime current = DateTime.now();
    if (oldTInt != null) {
      DateTime oldtime = DateTime.fromMillisecondsSinceEpoch(oldTInt);
      final dif = current.difference(oldtime);
      if (dif.inHours == 0) {
        return _cache!;
      }
      //Check cache valid by comparing to server data, if valid, reset time
    }
    //Clear if over time or invalid
    _cache!.clear();
    _cache!.setInt(
      "time",
      current.millisecondsSinceEpoch,
    ); //Cons: If user call it every hours, it will have never been valid checked!
    return _cache!;
  }

  @override
  Future<void> _init() async {}

  @override
  Future<String?> _getToken() async {
    return (await _get()).getString("token");
  }

  @override
  Future<bool> _setToken(String token) async {
    (await _get()).setString("token", token);
    print("save token!");
    return true;
  }

  @override
  Future<Quests?> _getQuests() async {
    String? response = (await _get()).getString("quest");
    if (response != null) {
      final data = jsonDecode(response);
      return Quests.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> _setQuests(Quests quest) async {
    await (await _get()).setString("quest", jsonEncode(quest.toJson()));
    return true;
  }

  @override
  Future<UserAccountCore?> _getAccount() async {
    final raw = (await _get()).getString("user");
    if (raw == null) return null;
    final data = jsonDecode(raw);
    return UserAccountCore.fromJson(data);
  }

  @override
  Future<bool> _setAccount(UserAccountCore account) async {
    await (await _get()).setString("user", jsonEncode(account.toJson()));
    return true;
  }

  @override
  Future<bool> _clear() async {
    (await _get()).clear();
    return true;
  }

  @override
  Future<String?> _signin(String username, String password) async {
    return null;
  }

  @override
  Future<String?> _signup(String username, String password) async {
    return null;
  }

  @override
  Future<String?> _postMission(int id, String file) async {
    (await _get()).setString(id.toString(), file);
    return null;
  }

  @override
  Future<String?> _fetchMission(int id) async {
    return (await _get()).getString(id.toString());
  }

  @override
  Future<GameRoute?> _getRoute() async {
    print("Get route from cache!");
    final response = (await _get()).getString("route");
    print(response);
    if (response != null) return GameRoute.fromJson(jsonDecode(response));
    return null;
  }

  @override
  Future<bool> _setRoute(GameRoute route) async {
    (await _get()).setString("route", jsonEncode(route.toJson()));
    return true;
  }

  @override
  Future<bool> _completeRoute(GameRoute route) async {
    (await _get()).remove("route");
    return true;
  }
}
