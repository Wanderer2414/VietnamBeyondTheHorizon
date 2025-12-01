part of proxy;

interface class Proxy {
  final Proxy? _subProxy;
  Proxy({Proxy? subProxy}) : _subProxy = subProxy;

  Future<UserAccountCore?> getAccount() async {
    var account = await _getAccount();
    if (account != null) return account;
    if (_subProxy != null) {
      account = await _subProxy.getAccount();
      if (account != null) await _setAccount(account);
      return account;
    }
    return null;
  }

  Future<bool> setAccount(UserAccountCore user) async {
    if ((_subProxy == null) || (await _subProxy.setAccount(user)))
      return await _setAccount(user);
    return false;
  }

  Future<Quests?> getQuests() async {
    var quests = await _getQuests();
    if (quests != null) return quests;
    if (_subProxy != null) {
      quests = await _subProxy.getQuests();
      if (quests != null) await _setQuests(quests);
      return quests;
    }
    return null;
  }

  Future<bool> setQuests(Quests quest) async {
    if ((_subProxy == null) || (await _subProxy.setQuests(quest)))
      return await _setQuests(quest);
    return false;
  }

  Future<String?> getToken() async {
    var token = await _getToken();
    if (token != null) return token;
    if (_subProxy != null) {
      token = await _subProxy.getToken();
      if (token != null) _setToken(token);
      return token;
    }
    return null;
  }

  Future<bool> setToken(String token) async {
    if ((_subProxy == null) || (await _subProxy.setToken(token)))
      return await _setToken(token);
    return false;
  }

  Future<void> clear() async {
    await _clear();
    if (_subProxy != null) _subProxy.clear();
  }

  Future<String?> login(String username, String password) async {
    if (_subProxy != null) {
      String? token = await _subProxy.login(username, password);
      if (token != null) {
        _setToken(token);
        return token;
      }
    }
    return await _signin(username, password);
  }

  Future<String?> signup(String username, String password) async {
    if (_subProxy != null) {
      String? token = await _subProxy.signup(username, password);
      if (token != null) {
        _setToken(token);
        return token;
      }
    }
    return await _signup(username, password);
  }

  Future<GameRoute?> getRoute() async {
    var route = await _getRoute();
    if (route != null) return route;
    if (_subProxy != null) {
      route = await _subProxy.getRoute();
      if (route != null) await _setRoute(route);
      return route;
    }
    return null;
  }

  Future<bool> setRoute(GameRoute route) async {
    if (_subProxy != null) {
      if (await _subProxy.setRoute(route)) return await _setRoute(route);
      return false;
    }
    return await _setRoute(route);
  }

  Future<String?> postMission(int id, String file) async {
    if (_subProxy != null) {
      String? res = await _subProxy.postMission(id, file);
      if (res != null) await _postMission(id, file);
      return res;
    }
    return await _postMission(id, file);
  }

  Future<String?> fetchMission(int id) async {
    String? src = await _fetchMission(id);
    if (src == null && _subProxy != null) {
      src = await _subProxy.fetchMission(id);
      if (src != null) _postMission(id, src);
    }
    return src;
  }

  Future<String?> postAIMission(int id, String file) async {
    if (_subProxy != null) {
      String? res = await _subProxy.postAIMission(id, file);
      if (res != null) await _postAIMission(id, file);
      return res;
    }
    return await _postAIMission(id, file);
  }

  Future<String?> fetchAIMission(int id) async {
    String? src = await _fetchAIMission(id);
    if (src == null && _subProxy != null) {
      src = await _subProxy.fetchAIMission(id);
      if (src != null) _postAIMission(id, src);
    }
    return src;
  }

  Future<bool> submit(int id) async {
    if (_subProxy != null) {
      if (await _subProxy.submit(id)) {
        await _submit(id);
        return true;
      }
      return false;
    }
    return await _submit(id);
  }

  Future<bool> completeRoute(GameRoute route) async {
    if (_subProxy != null) {
      if (await _subProxy.completeRoute(route)) {
        await _completeRoute(route);
        return true;
      }
      return false;
    }
    return _completeRoute(route);
  }

  Future<String?> createVideo(List<String> urls, List<int> locationId) async {
    if (_subProxy != null) {
      String? res = await _subProxy.createVideo(urls, locationId);
      if (res == null) return null;
      if (await _saveVideo(res)) return res;
      return null;
    }
    return _createVideo(urls, locationId);
  }

  Future<void> init() async {
    await _subProxy?.init();
    await _init();
  }

  Future<void> _init() async {}
  Future<Quests?> _getQuests() async {
    return null;
  }

  Future<bool> _setQuests(Quests quest) async {
    return true;
  }

  Future<UserAccountCore?> _getAccount() async {
    return null;
  }

  Future<bool> _setAccount(UserAccountCore user) async {
    return true;
  }

  Future<String?> _getToken() async {
    return null;
  }

  Future<bool> _setToken(String token) async {
    return true;
  }

  Future<bool> _clear() async {
    return true;
  }

  Future<String?> _signup(String username, String password) async {
    return null;
  }

  Future<String?> _signin(String username, String password) async {
    return null;
  }

  Future<GameRoute?> _getRoute() async {
    return null;
  }

  Future<bool> _setRoute(GameRoute route) async {
    return true;
  }

  Future<String?> _postMission(int id, String file) async {
    return null;
  }

  Future<String?> _postAIMission(int id, String file) async {
    return null;
  }

  Future<String?> _fetchMission(int id) async {
    return null;
  }

  Future<String?> _fetchAIMission(int id) async {
    return null;
  }

  Future<bool> _submit(int id) async {
    return true;
  }

  Future<bool> _completeRoute(GameRoute route) async {
    return true;
  }

  Future<String?> _createVideo(List<String> urls, List<int> locationIds) async {
    return null;
  }

  Future<bool> _saveVideo(String? video) async {
    return true;
  }
}
