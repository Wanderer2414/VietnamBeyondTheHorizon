class MissionModel {
  final String id;
  final String description;
  final String starReward;
  final bool isCompleted;
  final DateTime? finishDay;
  final String? illustrationURL;

  MissionModel({
    required this.id,
    required this.description,
    required this.starReward,
    this.isCompleted = false,
    this.finishDay,
    this.illustrationURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'starReward': starReward,
      'isCompleted': isCompleted,
      'finishDay': finishDay?.toIso8601String(),
      'illustrationURL': illustrationURL,
    };
  }

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String,
      description: json['description'] as String,
      starReward: json['starReward'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      finishDay: json['finishDay'] != null
          ? DateTime.parse(json['finishDay'] as String)
          : null,
      illustrationURL: json['illustrationURL'] != null
          ? json['illustrationURL'] as String
          : null,
    );
  }
}
