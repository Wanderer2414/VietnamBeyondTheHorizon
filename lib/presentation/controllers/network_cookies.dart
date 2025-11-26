import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';

class Cookies {
  final NetworkProxy proxy;
  Future<List<LocationModel>> Function() getLocation;
  Future<List<MissionModel>> Function() getMission;
  Future<String> Function() getToken;
  Future<void> Function(String token) setToken;
  Cookies({
    required this.proxy,
    required this.getLocation,
    required this.getMission,
    required this.getToken,
    required this.setToken,
  });
  List<LocationModel>? _dataLocation;
  List<MissionModel>? _dataMission;
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

  set token(String t) {
    _token = t;
    setToken(t);
  }
}
