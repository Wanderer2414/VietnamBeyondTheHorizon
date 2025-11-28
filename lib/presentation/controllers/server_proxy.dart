import 'package:dio/dio.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/dio_service.dart';

class ServerProxy {
  DioService _service;

  ServerProxy(String host, void Function() onTokenExpired)
    : _service = DioService(onTokenExpired: onTokenExpired) {}
  Future<void> Token(String token) async {
    if (await isValid(token)) {
      _service.token = token;
    }
  }

  Future<List<LocationModel>> getAllLocation() async {
    final response = await _service.dio.get("/location/locations");
    final jsonBody = response.data;

    if (jsonBody['status'] == 'success') {
      final List<dynamic> data = jsonBody['data'];
      final dataLocation = data.map((e) => LocationModel.fromJson(e)).toList();
      return dataLocation;
    } else
      throw Exception(1);
  }

  Future<List<MissionModel>> getAllMission() async {
    final response = await _service.dio.get("/mission/missions");
    final jsonBody = response.data;

    if (jsonBody['status'] == 'success') {
      final List<dynamic> data = jsonBody['data'];
      final missionModel = data.map((e) => MissionModel.fromJson(e)).toList();
      return missionModel;
    } else
      throw Exception(1);
  }

  Future<bool> updateProfile({
    required String name,
    required int age,
    required String city,
  }) async {
    try {
      final response = await _service.dio.patch(
        "/user/profile",
        data: {"name": name, "age": age, "city": city},
      );
      if (response.data['status'] == "success") {
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response!.data['error']['message'];

        if (msg is List) {
          throw Exception(msg.join(", "));
        } else {
          throw Exception(msg.toString());
        }
      } else {
        throw Exception(1);
      }
    }
    return false;
  }

  Future<UserAccountCore> getUserData() async {
    final response = await _service.dio.get("/user/info");

    if (response.data['status'] == "success") {
      final userJson = response.data['data'];

      if (userJson != null) {
        final user = UserAccountCore.fromJson(userJson);
        return user;
      }
    }
    throw Exception("Fetch user data failed");
  }

  Future<bool> isValid(String token) async {
    return true;
  }

  Future<String?> signin(String email, String password) async {
    try {
      final response = await _service.dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.data["status"] == "success") {
        final token = response.data['data']['access_token'];
        _service.token = token;
        return token;
      }

      // throw Exception("Unexpected server format.");
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response!.data['error']['message'];

        if (msg is List) {
          throw Exception(msg.join(", "));
        } else {
          throw Exception(msg.toString());
        }
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }

  Future<String?> signup(String email, String password) async {
    try {
      final response = await _service.dio.post(
        "/auth/signup",
        data: {"email": email, "password": password},
      );

      if (response.data['status'] == "success") {
        final token = response.data['data']['access_token'];
        _service.token = token;
        return token;
      } else {
        return null;
        // throw Exception("Sign up error: ${response.data['error']['message']}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response!.data['error']['message'];

        if (msg is List) {
          throw Exception(msg.join(", "));
        } else {
          throw Exception(msg.toString());
        }
      } else {
        throw Exception(1);
      }
    }
  }

  Future<void> postImage(FormData data) async {
    try {
      await _service.dio.post("/mission/similarity", data: data);
    } catch (e) {
      if (e is DioException) {
        print("Lỗi server trả về: ${e.response?.data}");
      }
    }
  }

  Future<bool> isLogged() async {
    return _service.isLogged;
  }
}
