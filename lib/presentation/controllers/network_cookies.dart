import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';

class Cookies {
  final NetworkProxy proxy;
  Future<List<LocationModel>> Function() getLocation;
  Future<List<MissionModel>> Function() getMission;
  Future<UserAccountCore> Function() getAcount;
  Cookies({
    required this.proxy,
    required this.getLocation,
    required this.getMission,
    required this.getAcount,
  });
  List<LocationModel>? _dataLocation;
  List<MissionModel>? _dataMission;
  UserAccountCore? _userAccount;

  Future<List<LocationModel>> get dataLocation async {
    if (_dataLocation == null) _dataLocation = await getLocation();
    print("Load data location!");
    return _dataLocation!;
  }

  Future<List<MissionModel>> get dataMission async {
    if (_dataMission == null) _dataMission = await getMission();
    print("Load mission!");
    return _dataMission!;
  }

  Future<UserAccountCore> get userAccount async {
    if (_userAccount == null) _userAccount = await getAcount();
    print("Load account!");
    return _userAccount!;
  }
}
