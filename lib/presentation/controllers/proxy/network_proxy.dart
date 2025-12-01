part of proxy;

class NetworkProxy {
  static _Cookies? _instance;

  static Future<_Cookies> _getInstance() async {
    if (_instance == null) await _initialize();
    return _instance!;
  }

  static Future<bool> isLogged() async {
    return (await _getInstance())._isLogged;
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

  static Future<List<LocationModel?>> get locations async {
    final quest = await (await _getInstance()).getQuests();
    return quest!.locations;
  }

  static Future<List<MissionModel?>> get missions async {
    final quest = await (await _getInstance()).getQuests();
    print(quest);
    return quest!.missions;
  }

  static Future<UserAccount> get account async {
    final instance = await _getInstance();
    final user = await instance.getAccount();
    return user!.userAccount;
  }

  static Future<bool> login(String email, String password) async {
    final instance = await _getInstance();
    String? token = await instance.login(email, password);
    return (token != null);
  }

  static Future<bool> signup(String email, String password) async {
    final instance = await _getInstance();
    String? token = await instance.signup(email, password);
    return (token != null);
  }

  static Future<bool> setProfile(String username, int age, String city) async {
    final instance = await _getInstance();
    final user = (await instance.getAccount())!;
    user.age = age;
    user.username = username;
    user.city = city;
    user.createdAt = DateTime.now();
    return await instance.setAccount(user);
  }

  static Future<bool> setRoute(GameRoute route) async {
    return (await _getInstance()).setRoute(route);
  }

  static Future<GameRoute?> getRoute() async {
    return (await _getInstance()).getRoute();
  }

  static Future<void> logout() async {
    if (await isLogged()) {
      clean();
      MainRoute.logout();
    }
  }

  static Future<String?> postMission(int misssion, String file) async {
    final instance = await _getInstance();
    return (await instance.postMission(misssion, file));
  }

  static Future<String?> postAIMission(int misssion, String file) async {
    final instance = await _getInstance();
    return await instance.postAIMission(misssion, file);
  }

  static Future<String?> fetchMission(int mission) async {
    final instance = await _getInstance();
    return await instance.fetchMission(mission);
  }

  static Future<void> completeRoute(GameRoute route) async {
    final instance = await _getInstance();
    await instance.completeRoute(route);
  }

  static Future<String?> createVideo(List<String> url, List<int> ids) async {
    final instance = await _getInstance();
    return instance.createVideo(url, ids);
  }
}
