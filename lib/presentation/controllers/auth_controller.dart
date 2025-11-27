import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/network_proxy.dart';
import 'package:vietnambeyondthehorizon/main.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/dio_service.dart';
import 'package:vietnambeyondthehorizon/routes/main_route.dart';

final authProvider = ChangeNotifierProvider<AuthController>((ref) {
  final auth = AuthController();
  auth.loadToken();
  return auth;
});

class AuthController extends ChangeNotifier {
  String? _token;
  UserAccount? _user;
  Dio get _dio => DioService.dio;

  String? get token => _token;
  UserAccount? get user => _user;

  bool get isLoggedIn => _token != null;

  AuthController() {
    DioService.onTokenExpired = logout;
  }
  Future<void> signup(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match");
    }
    try {
      final response = await _dio.post(
        "/auth/signup",
        data: {"email": email, "password": password},
      );

      if (response.data['status'] == "success") {
        _token = response.data['data']['access_token'];
        notifyListeners();
        await _saveToken(_token!);
      } else {
        throw Exception("Sign up error: ${response.data['error']['message']}");
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
        throw Exception("Network error: ${e.message}");
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.data["status"] == "success") {
        _token = response.data['data']['access_token'];
        notifyListeners();
        await _saveToken(_token!);
        return;
      }

      throw Exception("Unexpected server format.");
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

  Future<void> updateProfile({
    required String name,
    required int age,
    required String city,
  }) async {
    try {
      final response = await _dio.patch(
        "/user/profile",
        data: {"name": name, "age": age, "city": city},
      );
      if (response.data['status'] == "success") {
        notifyListeners();
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
        throw Exception("Network error: ${e.message}");
      }
    }
  }

  Future<UserAccount?> fetchUserData() async {
    final response = await _dio.get("/user/info");

    if (response.data['status'] == "success") {
      final userJson = response.data['data'];

      if (userJson != null) {
        _user = UserAccount.fromJson(userJson);
        await NetworkProxy.Account(_user!);
        return _user;
      }
    } else {
      throw Exception("Fetch user data failed");
    }
    return null;
  }

  Future<void> _saveToken(String token) async {
    await NetworkProxy.Token(token);
  }

  Future<void> loadToken() async {
    _token = await NetworkProxy.token;
  }

  Future<void> logout() async {
    NetworkProxy.logout();

    notifyListeners();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MainRoute.newRoute("log_navigator"),
      (route) => false,
    );
  }
}
