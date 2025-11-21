class MissionModel {
  final String id;
  final String name;
  final String description;
  final int difficulty;
  final bool isCompleted;
  final DateTime? finishDay;
  final String? illustrationURL;
  String? imagePath;
  String? cost;

  MissionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    this.isCompleted = false,
    this.finishDay,
    this.illustrationURL,
    this.imagePath,
    this.cost = "0",
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
      'finishDay': finishDay?.toIso8601String(),
      'illustrationURL': illustrationURL,
      'imagePath': imagePath,
      'cost': cost,
    };
  }

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      finishDay: json['finishDay'] != null
          ? DateTime.tryParse(json['finishDay'].toString())
          : null,
      illustrationURL: json['illustrationURL'] as String?,
      imagePath: json['imagePath'] as String?,
      cost: json['cost']?.toString() ?? "0",
    );
  }
}


// {
//             "id": 1,
//             "name": "Right Angle",
//             "description": "Take a photo in front of the clock at Bến Thành Market when the hour hand and the minute hand form a 90-degree angle.",
//             "cost": 0,
//             "difficulty": 2,
//             "images": []
//         },