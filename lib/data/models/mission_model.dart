import 'package:vietnambeyondthehorizon/data/models/location_model.dart';

class MissionModel {
  final int id;
  LocationModel? location;
  final String name;
  final String type;
  final String context;
  final String challenge;
  final int difficulty;
  bool isCompleted;
  final DateTime? finishDay;
  final String? illustrationURL;
  String? cost;

  MissionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.context,
    required this.challenge,
    required this.difficulty,
    this.isCompleted = false,
    this.finishDay,
    this.illustrationURL,
    this.cost = "0",
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'context': context,
      'challenge': challenge,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
      'finishDay': finishDay?.toIso8601String(),
      'illustrationURL': illustrationURL,
      'cost': cost,
    };
  }

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      context: json['context'] as String? ?? "",
      challenge: json['challenge'] as String,
      difficulty: json['difficulty'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      finishDay: json['finishDay'] != null
          ? DateTime.tryParse(json['finishDay'].toString())
          : null,
      illustrationURL: (json['images'] as List<dynamic>?)
          ?.map((e) => e['url'] as String)
          .toList()
          .firstOrNull,
      cost: json['cost']?.toString() ?? "0",
    );
  }
}

class VisitModel {
  final int missionId;
  final String? imageUrl;

  VisitModel({required this.missionId, this.imageUrl});

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    String? url;
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      url = json['images'][0]['url'];
    }

    return VisitModel(missionId: json['missionID'], imageUrl: url);
  }
}
