class MissionModel {
  final int id;
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
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      finishDay: json['finishDay'] != null
          ? DateTime.parse(json['finishDay'] as String)
          : null,
      illustrationURL: json['illustrationURL'] != null
          ? json['illustrationURL'] as String
          : null,
      imagePath: json['imagePath'] != null ? json['imagePath'] as String : null,
      cost: json['cost'] != null ? json['cost'] as String : "0",
    );
  }
}
