class PlayerData {
  final String userId; // link to UserAccount
  //int level;
  int stars;
  int diamonds;
  //int exp;

  List<String> completedMissions; // ID of all completed missions
  List<String> unlockedLocations; // unlocked locations

  PlayerData({
    required this.userId,
    //this.level = 1,
    this.stars = 0,
    this.diamonds = 0,
    //this.exp = 0,
    this.completedMissions = const [],
    this.unlockedLocations = const [],
  });
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
