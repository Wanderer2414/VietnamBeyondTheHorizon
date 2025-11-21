import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vietnambeyondthehorizon/data/models/city_map.dart';
import 'package:vietnambeyondthehorizon/data/user/player_data.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';

final authProvider = ChangeNotifierProvider<AuthController>((ref) {
  final auth = AuthController();
  auth.loadToken();
  return auth;
});

class AuthController extends ChangeNotifier {
  String? _token;
  UserAccount? _user;
  PlayerData? _player;
  Dio _dio;

  String? get token => _token;
  UserAccount? get user => _user;
  PlayerData? get player => _player;

  bool get isLoggedIn => _token != null;

  AuthController()
    : _dio = Dio(BaseOptions(baseUrl: "https://vnbth-backend.onrender.com")) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers["Authorization"] = "Bearer $_token";
          }
          options.headers["Content-Type"] = "application/json";
          handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            // token expired → logout
            logout();
          }
          handler.next(e);
        },
      ),
    );
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
        return _user;
      }
    } else {
      throw Exception("Fetch user data failed");
    }
    return null;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _player = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
