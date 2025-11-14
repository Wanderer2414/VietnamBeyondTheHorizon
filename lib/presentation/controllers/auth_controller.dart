import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vietnambeyondthehorizon/data/user/player_data.dart';
import 'package:vietnambeyondthehorizon/data/user/user_account.dart';

class AuthController extends ChangeNotifier {
  String? _token;
  UserAccount? _user;
  PlayerData? _player;

  String? get token => _token;
  UserAccount? get user => _user;
  PlayerData? get player => _player;

  bool get isLoggedIn => _token != null;

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://vnbth-backend.onrender.com/auth/login'),
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == "success") {
        _token = data['data']['access_token'];

        notifyListeners();
        await _saveToken(_token!);
        await _fetchUserData();
      }
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('https://vnbth-backend.onrender.com/user/info');
    final response = await http.get(url, headers: {'Content-Type': 'json'});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == "success") {
        final data = body['data'];
        _user = UserAccount.fromJson(data['user']);
        _player = PlayerData.fromJson(data['player']);
      } else {
        throw Exception('Fetch data unsuccessfully');
      }
    } else {
      throw Exception('Fetch data failed');
    }
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
