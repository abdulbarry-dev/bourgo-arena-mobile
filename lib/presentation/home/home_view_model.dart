import 'package:flutter/material.dart';

/// ViewModel for the Home screen.
class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Future home data (activities, events, etc.)
  final List<Map<String, String>> activities = [
    {'title': 'Football', 'image': 'assets/images/football.jpg'},
    {'title': 'Padel', 'image': 'assets/images/padel.jpg'},
    {'title': 'Fitness', 'image': 'assets/images/fitness.jpg'},
  ];
}
