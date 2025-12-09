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

  Future<String?> _getToken() async {
    String? token = (await _get()).getString("token");
    return token;
  }

  Future<bool> _setToken(String token) async {
    return await (await _get()).setString("token", token);
  }

  @override
  Future<Quests?> getQuests() async {
    String? response = (await _get()).getString("quest");
    if (response != null) {
      final data = jsonDecode(response);
      return Quests.fromJson(data);
    } else {
      return await _subProxy?.getQuests();
    }
  }

  @override
  Future<bool> setQuests(Quests quest) async {
    bool res = await _subProxy!.setQuests(quest);
    if (res)
      return await (await _get()).setString(
        "quest",
        jsonEncode(quest.toJson()),
      );
    return false;
  }

  // Future<UserAccountCore?> _getAccount() async {
  //   final raw = (await _get()).getString("user");
  //   if (raw == null) return null;
  //   final data = jsonDecode(raw);
  //   return UserAccountCore.fromJson(data);
  // }

  @override
  Future<bool> clear() async {
    print("Clear cache!");
    _subProxy?.clear();
    (await _get()).clear();
    return true;
  }

  @override
  Future<UserAccountCore?> login(String username, String password) async {
    final account = await _subProxy!.login(username, password);
    if (account != null) _setToken(account.token!);
    return account;
  }

  @override
  Future<UserAccountCore?> signup(String username, String password) async {
    final account = await _subProxy!.signup(username, password);
    if (account != null) _setToken(account.token!);
    return account;
  }

  @override
  Future<UserAccountCore?> isLogged(String? token) async {
    if (token == null) token = await _getToken();
    return await _subProxy!.isLogged(token);
  }

  @override
  Future<String?> postMission(int id, String file) async {
    String? res = await _subProxy!.postMission(id, file);
    if (res == null) return null;
    (await _get()).setString(id.toString(), res);
    return res;
  }

  @override
  Future<String?> postAIMission(int id, String file) async {
    String? res = await _subProxy!.postAIMission(id, file);
    if (res == null) return null;
    (await _get()).setString(id.toString(), res);
    return res;
  }

  @override
  Future<String?> fetchMission(int id) async {
    String? local = (await _get()).getString(id.toString());
    if (local != null) return local;
    return await _subProxy!.fetchMission(id);
  }

  @override
  Future<GameRoute?> getRoute() async {
    final response = (await _get()).getString("route");
    if (response != null) return GameRoute.fromJson(jsonDecode(response));
    return _subProxy!.getRoute();
  }

  @override
  Future<bool> setRoute(GameRoute route) async {
    // bool res = await _subProxy!.setRoute(route);
    // if (res)
    return (await _get()).setString("route", jsonEncode(route.toJson()));
    // return false;
  }

  @override
  Future<bool> completeRoute(GameRoute route) async {
    bool res = await _subProxy!.completeRoute(route);
    if (res) return (await _get()).remove("route");
    return false;
  }


}
