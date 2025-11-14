class PlayerData {
  //int level;
  int stars;
  int diamonds;
  //int exp;

  List<int> completedMissions; // ID of all completed missions
  List<int> unlockedLocations; // ID of unlocked locations

  PlayerData({
    //this.level = 1,
    this.stars = 0,
    this.diamonds = 0,
    //this.exp = 0,
    this.completedMissions = const [],
    this.unlockedLocations = const [],
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      stars: json['stars'],
      diamonds: json['diamonds'],
      completedMissions: List<int>.from(json['completedMissions']),
      unlockedLocations: List<int>.from(json['unlockedLocations']),
    );
  }
}

// JSON
// {
//   "user": {
//     "id": "u123",
//     "email": "thinh@gmail.com",
//     "username": "Thinh",
//     "avatarUrl": "https://cdn.game.com/avatar123.png"
//   },
//   "player": {
//     "level": 5,
//     "stars": 14,
//     "diamonds": 230,
//     "exp": 480,
//     "completedMissions": [m1, m3],
//     "unlockedLocations": ["l1", "l2"]
//   },
//   "token": "<JWT_TOKEN_HERE>"
// }
