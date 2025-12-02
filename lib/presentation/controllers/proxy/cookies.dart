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
  List<String>? _videoUrls;
  bool _isLogged = false;

  @override
  Future<UserAccountCore?> getAccount() async {
    if (_userAccount != null) return _userAccount;
    return _subProxy!.getAccount();
  }

  @override
  Future<Quests?> getQuests() async {
    if (_gameData != null) return _gameData;
    return _subProxy!.getQuests();
  }

  @override
  Future<bool> setAccount(UserAccountCore user) async {
    bool res = await _subProxy!.setAccount(user);
    if (res) _userAccount = user;
    return res;
  }

  @override
  Future<bool> setQuests(Quests quest) async {
    bool res = await _subProxy!.setQuests(quest);
    if (res) _gameData = quest;
    return res;
  }

  @override
  Future<bool> setToken(String token) async {
    bool res = await _subProxy!.setToken(token);
    if (res) _isLogged = true;
    return res;
  }

  @override
  Future<List<String>> fetchVideoUrls() async {
    if (_videoUrls != null) return _videoUrls!;
    return await _subProxy!.fetchVideoUrls();
  }

  bool isLogged() => _isLogged;
}
