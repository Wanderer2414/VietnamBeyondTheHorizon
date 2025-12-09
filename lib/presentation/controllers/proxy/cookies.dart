part of proxy;

class _Cookies extends Proxy {
  _Cookies(Future<void> Function() onTokenExpired)
    : super(
        subProxy: _CacheProxy(
          subProxy: _ServerProxy(
            "https://vnbth-backend.onrender.com/",
            onTokenExpired: onTokenExpired,
          ),
        ),
      );
  Quests? _gameData;
  UserAccountCore? _userAccount;

  @override
  Future<Quests?> getQuests() async {
    if (_gameData != null) return _gameData;
    return _subProxy!.getQuests();
  }

  @override
  Future<UserAccountCore?> login(String username, String password) async {
    _userAccount = await _subProxy!.login(username, password);
    return _userAccount;
  }

  @override
  Future<UserAccountCore?> signup(String username, String password) async {
    _userAccount = await _subProxy!.signup(username, password);
    return _userAccount;
  }

  @override
  Future<bool> updateAccount(String name, int age, String city) async {
    if (await _subProxy!.updateAccount(name, age, city)) {
      _userAccount!.username = name;
      _userAccount!.age = age;
      _userAccount!.city = city;
      return true;
    }
    return false;
  }

  @override
  Future<bool> setQuests(Quests quest) async {
    bool res = await _subProxy!.setQuests(quest);
    if (res) _gameData = quest;
    return res;
  }

  // @override
  // Future<bool> setToken(String token) async {
  //   bool res = await _subProxy!.setToken(token);
  //   if (res) _isLogged = true;
  //   return res;
  // }

  @override
  Future<UserAccountCore?> isLogged(String? token) async {
    if (_userAccount != null) return _userAccount;
    return await _subProxy!.isLogged(null);
  }

  @override
  Future<String?> updateAvatar(String src) async {
    final avatarUrl = await _subProxy!.updateAvatar(src);
    if (avatarUrl != null) {
      _userAccount!.avatarUrl = avatarUrl;
    }
    return avatarUrl;
  }
}
