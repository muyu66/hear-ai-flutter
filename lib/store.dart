import 'package:flutter/material.dart';

class Store extends ChangeNotifier {
  double _percent = 1.0;
  bool _wordsLevelChange = false;
  bool _showBadge = false;

  double get percent => _percent;
  bool get wordsLevelChange => _wordsLevelChange;
  bool get showBadge => _showBadge;

  void resetPercent() {
    _percent = 1.0;
    notifyListeners();
  }

  void updatePercent(double newValue) {
    _percent = newValue.clamp(0.0, 1.0);
    notifyListeners();
  }

  void resetWordsLevelChange() {
    _wordsLevelChange = false;
    notifyListeners();
  }

  void updateWordsLevelChange() {
    _wordsLevelChange = true;
    notifyListeners();
  }

  void updateShowBadge(bool newValue) {
    _showBadge = newValue;
    notifyListeners();
  }
}
