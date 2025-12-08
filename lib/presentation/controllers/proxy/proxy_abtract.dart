part of proxy;

interface class Proxy {
  final Proxy? _subProxy;
  Proxy({Proxy? subProxy}) : _subProxy = subProxy;

  Future<bool> updateAccount(String name, int age, String city) async {
    if (_subProxy != null)
      return await _subProxy.updateAccount(name, age, city);
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

  Future<UserAccountCore?> isLogged(String? token) async {
    if (_subProxy != null) return await _subProxy.isLogged(token);
    return null;
  }

  Future<void> clear() async {
    if (_subProxy != null) return await _subProxy.clear();
  }

  Future<UserAccountCore?> login(String username, String password) async {
    if (_subProxy != null) return await _subProxy.login(username, password);
    return null;
  }

  Future<UserAccountCore?> signup(String username, String password) async {
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
    if (_subProxy != null) return await _subProxy.postMission(id, file);
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

  Future<String?> updateAvatar(String src) async {
    if (_subProxy != null) return await _subProxy.updateAvatar(src);
    return null;
  }
}
