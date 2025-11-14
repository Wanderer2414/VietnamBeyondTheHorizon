import 'package:vietnambeyondthehorizon/data/user/player_data.dart';

class UserAccount {
  final String email;
  final String username;
  final String age;
  final String avatarUrl;
  final String? city;

  final DateTime? createdAt;

  UserAccount({
    required this.email,
    required this.username,
    required this.age,
    required this.city,
    this.avatarUrl = "/", //default avatar
    required this.createdAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      email: json['email'],
      username: json['username'],
      age: json['age'],
      city: json['city'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      avatarUrl: json['avtar'],
    );
  }
}
