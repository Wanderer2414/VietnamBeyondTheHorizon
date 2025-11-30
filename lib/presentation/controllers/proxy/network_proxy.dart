part of proxy;

class NetworkProxy extends Proxy {
  NetworkProxy._()
    : super(
        subProxy: CacheProxy(
          subProxy: ServerProxy(
            "https://vnbth-backend.onrender.com/",
            onTokenExpired: logout,
          ),
        ),
      );

  static Function()? gotoLoginScreen;
  static NetworkProxy? _instance;
  Quests? _gameData;
  UserAccountCore? _userAccount;
  bool _isLogged = false;

  static Future<NetworkProxy> _getInstance() async {
    if (_instance == null) await _initialize();
    return _instance!;
  }

  static Future<bool> isLogged() async {
    return (await _getInstance())._isLogged;
  }

  static Future<void> _initialize() async {
    if (_instance != null) return;
    _instance = NetworkProxy._();
    await _instance!.init();
  }

  @override
  Future<void> _init() async {
    final token = await getToken();
    if (token != null) {
      if (await setToken(token)) _isLogged = true;
    }
  }

  @override
  Future<UserAccountCore?> _getAccount() async {
    return _userAccount;
  }

  @override
  Future<Quests?> _getQuests() async {
    return _gameData;
  }

  @override
  Future<bool> _setAccount(UserAccountCore user) async {
    _userAccount = user;
    return true;
  }

  @override
  Future<bool> _setQuests(Quests quest) async {
    _gameData = quest;
    return true;
  }

  @override
  Future<bool> _setToken(String token) async {
    print("Logged $token");
    _isLogged = true;
    return true;
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
    String? token = await instance.signin(email, password);
    return (token != null);
  }

  static Future<bool> register(String email, String password) async {
    final instance = await _getInstance();
    String? token = await instance.signup(email, password);
    return (token != null);
  }

  static Future<bool> updateProfile(
    String username,
    int age,
    String city,
  ) async {
    final instance = await _getInstance();
    final user = (await instance.getAccount())!;
    user.age = age;
    user.username = username;
    user.city = city;
    user.createdAt = DateTime.now();
    return await instance.setAccount(user);
  }

  static Future<bool?> saveRoute(GameRoute route) async {
    return (await _getInstance()).setRoute(route);
  }

  static Future<GameRoute?> getAvailableRoute() async {
    return (await _getInstance()).getRoute();
  }

  static void logout() {
    clean();
    gotoLoginScreen?.call();
  }

  static Future<void> postImage(int misssion, String file) async {
    final instance = await _getInstance();
    await instance.postMission(misssion, file);
  }
}
