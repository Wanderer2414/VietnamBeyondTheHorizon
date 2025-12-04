part of proxy;

interface class Proxy {
  final Proxy? _subProxy;
  Proxy({Proxy? subProxy}) : _subProxy = subProxy;

  Future<UserAccountCore?> getAccount() async {
    if (_subProxy != null) return await _subProxy.getAccount();
    return null;
  }

  Future<bool> setAccount(UserAccountCore user) async {
    if (_subProxy != null) return await _subProxy.setAccount(user);
    return false;
  }

  Future<Quests?> getQuests() async {
    if (_subProxy != null) return await _subProxy.getQuests();
    return null;
  }

  Future<bool> setQuests(Quests quest) async {
    if (_subProxy != null) return await _subProxy.setQuests(quest);
    return false;
  }

  Future<String?> getToken() async {
    if (_subProxy != null) return await _subProxy.getToken();
    return null;
  }

  Future<bool> setToken(String token) async {
    if (_subProxy != null) return await _subProxy.setToken(token);
    return false;
  }

  Future<List<String>> fetchVideoUrls() async {
    if (_subProxy != null) return await _subProxy.fetchVideoUrls();
    return [];
  }

  Future<void> clear() async {
    if (_subProxy != null) return await _subProxy.clear();
  }

  Future<String?> login(String username, String password) async {
    if (_subProxy != null) return await _subProxy.login(username, password);
    return null;
  }

  Future<String?> signup(String username, String password) async {
    if (_subProxy != null) return await _subProxy.signup(username, password);
    return null;
  }

  Future<GameRoute?> getRoute() async {
    if (_subProxy != null) return await _subProxy.getRoute();
    return null;
  }

  Future<bool> setRoute(GameRoute route) async {
    if (_subProxy != null) return await _subProxy.setRoute(route);
    return false;
  }

  Future<String?> postMission(int id, String file) async {
    if (_subProxy != null) return await _subProxy.postAIMission(id, file);
    return null;
  }

  Future<String?> fetchMission(int id) async {
    if (_subProxy != null) return await _subProxy.fetchMission(id);
    return null;
  }

  Future<String?> postAIMission(int id, String file) async {
    if (_subProxy != null) return await _subProxy.postAIMission(id, file);
    return null;
  }

  Future<bool> submit(int id) async {
    if (_subProxy != null) return await _subProxy.submit(id);
    return false;
  }

  Future<bool> completeRoute(GameRoute route) async {
    if (_subProxy != null) return await _subProxy.completeRoute(route);
    return false;
  }

  Future<String?> createVideo(List<String> urls, List<int> locationId) async {
    if (_subProxy != null) return await _subProxy.createVideo(urls, locationId);
    return null;
  }

  Future<void> init() async {
    await _subProxy?.init();
  }
}
