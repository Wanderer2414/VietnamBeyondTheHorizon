import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';

class Cookies {
  final NetworkProxy proxy;
  Future<List<LocationModel>> Function() getLocation;
  Future<List<MissionModel>> Function() getMission;
  Future<String> Function() getToken;
  Future<UserAccount> Function() getAcount;
  Future<void> Function(String token) setToken;
  Future<void> Function(UserAccount account) setAccount;
  Cookies({
    required this.proxy,
    required this.getLocation,
    required this.getMission,
    required this.getToken,
    required this.setToken,
    required this.getAcount,
    required this.setAccount,
  });
  List<LocationModel>? _dataLocation;
  List<MissionModel>? _dataMission;
  UserAccount? _userAccount;
  String? _token;

  Future<List<LocationModel>> get dataLocation async {
    if (_dataLocation == null) _dataLocation = await getLocation();
    return _dataLocation!;
  }

  Future<List<MissionModel>> get dataMission async {
    if (_dataMission == null) _dataMission = await getMission();
    return _dataMission!;
  }

  Future<String> get token async {
    if (_token == null) _token = await getToken();
    return _token!;
  }

  Future<UserAccount> get userAccount async {
    if (_userAccount == null) _userAccount = await getAcount();
    print(_userAccount);
    return _userAccount!;
  }

  Future<void> Token(String t) async {
    _token = t;
    await setToken(t);
  }

  Future<void> Account(UserAccount userAccount) async {
    _userAccount = userAccount;
    await setAccount(userAccount);
  }
}
