import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserAccount?>(
  (ref) => UserNotifier(),
);

class UserAccount {
  final String email;
  final String username;
  final int age;
  final String avatarUrl;
  final String city;
  final int star;
  final int diamond;
  final DateTime? createdAt;

  UserAccount({
    required this.email,
    this.username = "",
    this.age = 0,
    this.city = "",
    this.avatarUrl = "/",
    this.createdAt,
    this.star = 0,
    this.diamond = 0,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      email: json['email'] ?? "",
      username: json['name'] ?? "",
      age: json['age'] ?? 0,
      star: json['star'] ?? 0,
      diamond: json['diamond'] ?? 0,
      city: json['city'] ?? "",
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      avatarUrl: json['avatar'] ?? "/",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": username,
      "age": age,
      "city": city,
      "star": star,
      "diamond": diamond,
      "avatar": avatarUrl,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  UserAccount copyWith({
    String? email,
    String? username,
    int? age,
    int? star,
    int? diamond,
    String? avatarUrl,
    String? city,
    DateTime? createdAt,
  }) {
    return UserAccount(
      email: email ?? this.email,
      username: username ?? this.username,
      age: age ?? this.age,
      star: star ?? this.star,
      diamond: diamond ?? this.diamond,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserNotifier extends StateNotifier<UserAccount?> {
  UserNotifier() : super(null);

  void setUser(UserAccount user) {
    state = user;
  }

  void updateUser(UserAccount updated) {
    state = updated;
  }

  void clearUser() {
    state = null;
  }
}

// {
//     "status": "success",
//     "data": {
//         "id": 15,
//         "email": "khangthinhne@gmail.com",
//         "name": "Khang Thinh",
//         "age": 58,
//         "city": "Ho Chi Minh",
//         "star": 0,
//         "diamond": 0,
//         "createdAt": "2025-11-20T16:21:15.627Z",
//         "updatedAt": "2025-11-20T16:44:26.418Z",
//         "avatar": null,
//         "visit": []
//     }
// }
