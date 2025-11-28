class UserAccountCore {
  String email;
  String username;
  int age;
  String avatarUrl;
  String city;
  int star;
  int diamond;
  DateTime? createdAt;
  UserAccountCore._({
    required this.email,
    this.username = "",
    this.age = 0,
    this.city = "",
    this.avatarUrl = "/",
    this.createdAt,
    this.star = 0,
    this.diamond = 0,
  });
  factory UserAccountCore.fromJson(Map<String, dynamic> json) {
    return UserAccountCore._(
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

  UserAccount get userAccount {
    return UserAccount._(this);
  }
}

class UserAccount {
  final UserAccountCore _core;
  UserAccount._(UserAccountCore core) : _core = core;
  String get email {
    return _core.email;
  }

  String get username {
    return _core.username;
  }

  int get age {
    return _core.age;
  }

  String get avatarUrl {
    return _core.avatarUrl;
  }

  String get city {
    return _core.city;
  }

  int get star {
    return _core.star;
  }

  int get diamond {
    return _core.diamond;
  }

  DateTime? get createdAt {
    return _core.createdAt;
  }
}

//   UserAccount copyWith({
//     String? email,
//     String? username,
//     int? age,
//     int? star,
//     int? diamond,
//     String? avatarUrl,
//     String? city,
//     DateTime? createdAt,
//   }) {
//     return UserAccount(
//       email: email ?? this.email,
//       username: username ?? this.username,
//       age: age ?? this.age,
//       star: star ?? this.star,
//       diamond: diamond ?? this.diamond,
//       avatarUrl: avatarUrl ?? this.avatarUrl,
//       city: city ?? this.city,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }

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
