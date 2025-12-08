part of proxy;

class NetworkProxy {
  static _Cookies? _instance;

  static Future<_Cookies> _getInstance() async {
    if (_instance == null) await _initialize();
    return _instance!;
  }

  static Future<UserAccount?> isLogged() async {
    final instance = await _getInstance();
    return (await instance.isLogged(null))?.userAccount;
  }

  static Future<void> _initialize() async {
    if (_instance != null) return;
    _instance = _Cookies(logout);
    await _instance!.init();
  }

  static Future<void> clean() async {
    await (await _getInstance()).clear();
    dispose();
  }

  static void dispose() {
    _instance = null;
  }

  static Future<Quests?> get quest async {
    return await (await _getInstance()).getQuests();
  }

  static Future<UserAccount?> login(String email, String password) async {
    final instance = await _getInstance();
    final user = await instance.login(email, password);
    return user?.userAccount;
  }

  static Future<UserAccount?> signup(String email, String password) async {
    final instance = await _getInstance();
    final user = await instance.signup(email, password);
    return user?.userAccount;
  }

  static Future<bool> setProfile(String username, int age, String city) async {
    final instance = await _getInstance();
    return await instance.updateAccount(username, age, city);
  }

  static Future<bool> setRoute(GameRoute route) async {
    return (await _getInstance()).setRoute(route);
  }

  static Future<GameRoute?> get route async {
    return (await _getInstance()).getRoute();
  }

  static Future<void> logout() async {
    clean();
    MainRoute.logout();
  }

  static Future<String?> postMission(int misssion, String file) async {
    final instance = await _getInstance();
    return (await instance.postMission(misssion, file));
  }

  static Future<String?> postAIMission(int misssion, String file) async {
    final instance = await _getInstance();
    return await instance.postAIMission(misssion, file);
  }

  // static Future<String?> fetchMission(int mission) async {
  //   final instance = await _getInstance();
  //   return await instance.fetchMission(mission);
  // }

  static Future<void> completeRoute(GameRoute route) async {
    final instance = await _getInstance();
    await instance.completeRoute(route);
  }

  static Future<String?> createVideo(List<String> url, List<int> ids) async {
    final instance = await _getInstance();
    return instance.createVideo(url, ids);
  }
}
