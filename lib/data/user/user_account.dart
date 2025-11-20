import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    this.city,
    this.avatarUrl = "/",
    this.createdAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      age: json['age']?.toString() ?? "",
      city: json['city'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      avatarUrl: json['avatar'] ?? "/",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "username": username,
      "age": age,
      "city": city,
      "avatar": avatarUrl,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  UserAccount copyWith({
    String? email,
    String? username,
    String? age,
    String? avatarUrl,
    String? city,
    DateTime? createdAt,
  }) {
    return UserAccount(
      email: email ?? this.email,
      username: username ?? this.username,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
