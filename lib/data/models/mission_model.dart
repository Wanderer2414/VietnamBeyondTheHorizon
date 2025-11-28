class MissionModel {
  final String id;
  final String name;
  final String description;
  final String challenge;
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
    required this.challenge,
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
      'challenge': challenge,
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
      challenge: json['challenge'] as String,
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


    //  {
    //         "id": 9,
    //         "name": "Pigeon Whisperer",
    //         "type": "Photo",
    //         "description": "The square in front of Notre-Dame Cathedral is famous for its flocks of gentle pigeons that gather around visitors. They’re friendly, curious, and often comfortable being approached — making them an iconic part of the cathedral’s atmosphere.\nYour challenge: Approach one of the pigeons calmly and gently until it’s close enough for you to lightly touch it (a soft tap or brief touch is enough — be respectful and careful!). Capture a photo of the moment to prove you’ve earned your title as the Pigeon Whisperer of Notre-Dame.",
    //         "challenge": "Approach one of the pigeons calmly and gently until it’s close enough for you to lightly touch it (a soft tap or brief touch is enough — be respectful and careful!). Capture a photo of the moment to prove you’ve earned your title as the Pigeon Whisperer of Notre-Dame.",
    //         "cost": 0,
    //         "difficulty": 4,
    //         "answer": null,
    //         "images": []
    //     },