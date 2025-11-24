import 'package:flutter/material.dart';

class PlayerState extends ChangeNotifier {
  int points = 0;
  int missionsCompleted = 0;
  double distanceTravelled = 0.0; //km
  int photosSubmitted = 0;

  void addPoints(int p) {
    points += p;
    notifyListeners();
  }

  void completeMission() {
    missionsCompleted++;
    notifyListeners();
  }

  void addDistance(double km) {
    distanceTravelled += km;
    notifyListeners();
  }

  void submitPhoto() {
    photosSubmitted++;
    notifyListeners();
  }

  void reset() {
    points = 0;
    missionsCompleted = 0;
    distanceTravelled = 0.0;
    photosSubmitted = 0;
    notifyListeners();
  }
}
