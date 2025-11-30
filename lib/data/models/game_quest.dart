import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';

class _QuestItem {
  _QuestItem({this.location, this.mission});
  LocationModel? location;
  MissionModel? mission;
}

class Quests {
  final List<LocationModel?> _locations = [];
  final List<_QuestItem> _mission = [];
  Quests({
    required List<LocationModel> locations,
    required List<MissionModel> missions,
  }) {
    locations.forEach((element) {
      if (element.id >= _locations.length) _locations.length = element.id + 1;
      _locations[element.id] = element;
      element.missionID.forEach((id) {
        for (int i = _mission.length - 1; i < id; i++)
          _mission.add(_QuestItem());
        _mission[id].location = element;
      });
    });
    missions.forEach((element) {
      for (int i = _mission.length - 1; i < element.id; i++)
        _mission.add(_QuestItem());
      _mission[element.id].mission = element;
      element.location = _mission[element.id].location;
    });
    _locations.forEach((element) {
      if (element != null) {
        element.missionID.removeWhere(
          (id) => (id >= _mission.length) || (_mission[id].mission == null),
        );
        if (element.missionID.isEmpty) element = null;
      }
    });
    while (_mission.isNotEmpty &&
        (_mission.last.location == null || _mission.last.mission == null))
      _mission.removeLast();
  }

  Quests._({
    required List<LocationModel?> locations,
    required List<MissionModel?> missions,
    required List<int?> rels,
  }) {
    print(locations.length);
    print(missions.length);
    print(rels.length);
    _locations.addAll(locations);
    rels.forEach(
      (element) => _mission.add(
        _QuestItem(location: (element != null) ? _locations[element] : null),
      ),
    );
    missions.forEach((element) {
      if (element == null) return;
      _mission[element.id].mission = element;
      element.location = _mission[element.id].location;
    });
  }

  List<LocationModel?> get locations {
    return _locations;
  }

  List<MissionModel?> get missions {
    return _mission.map((e) => e.mission).toList();
  }

  LocationModel? getLocation(int id) {
    if (id > _mission.length) return null;
    return _mission[id].location;
  }

  Map<String, dynamic> toJson() {
    return {
      "locs": locations.map((e) => e?.toJson() ?? null).toList(),
      "misses": missions.map((e) => e?.toJson() ?? null).toList(),
      "rel": _mission.map((e) => e.location?.id ?? null).toList(),
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
}
