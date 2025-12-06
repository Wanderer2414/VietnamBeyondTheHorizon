import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';

class Quests {
  final List<LocationModel?> _locations = [];
  final List<MissionModel?> _mission = [];
  Quests({
    required List<LocationModel> locations,
    required List<MissionModel> missions,
  }) {
    missions.forEach((element) {
      if (element.id >= _mission.length) _mission.length = element.id + 1;
      _mission[element.id] = element;
    });
    locations.forEach((element) {
      if (element.id >= _locations.length) _locations.length = element.id + 1;
      _locations[element.id] = element;
      element.missionID.removeWhere(
        (id) => (id >= _mission.length) || (_mission[id] == null),
      );
      element.missionID.forEach((id) {
        _mission[id]!.location = element;
      });
      if (element.missionID.isEmpty) _locations[element.id] = null;
    });
    _mission.forEach((element) {
      if (element?.location == null) element = null;
    });
    while (_mission.isNotEmpty && (_mission.last == null))
      _mission.removeLast();
  }

  Quests._({
    required List<LocationModel?> locations,
    required List<MissionModel?> missions,
    required List<int?> rels,
  }) {
    _locations.addAll(locations);
    _mission.addAll(missions);
    for (int i = 0; i < rels.length; i++) {
      if (rels[i] != null) _mission[i]!.location = locations[rels[i]!];
    }
  }

  List<LocationModel?> get locations {
    return _locations;
  }

  List<MissionModel?> get missions {
    return _mission;
  }

  Map<String, dynamic> toJson() {
    return {
      "locs": locations.map((e) => e?.toJson() ?? null).toList(),
      "misses": missions.map((e) => e?.toJson() ?? null).toList(),
      "rel": _mission.map((e) => e?.location!.id ?? null).toList(),
    };
  }

  factory Quests.fromJson(Map<String, dynamic> json) {
    final List<LocationModel?> locs = (json['locs'] as List<dynamic>)
        .map((e) => (e != null) ? LocationModel.fromJson(e) : null)
        .toList();
    final List<MissionModel?> misses = (json['misses'] as List<dynamic>)
        .map((e) => (e != null) ? MissionModel.fromJson(e) : null)
        .toList();
    final List<int?> rel = (json['rel'] as List<dynamic>)
        .map((e) => (e != null) ? e as int : null)
        .toList();
    return Quests._(locations: locs, missions: misses, rels: rel);
  }
  Quests UncompletedQuest() {
    List<MissionModel> mission = _mission
        .where((element) => (element?.isCompleted ?? true) == false)
        .map((e) => e!)
        .toList();
    List<LocationModel> locations = _locations
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
    return Quests(locations: locations, missions: mission);
  }
}
