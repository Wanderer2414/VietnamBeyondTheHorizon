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
  bool _isLogged = false;

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
    _isLogged = true;
    return true;
  }

  bool isLogged() => _isLogged;
}
