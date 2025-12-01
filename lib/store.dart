import 'package:flutter/material.dart';

class Store extends ChangeNotifier {
  double _percent = 1.0;
  bool _refreshWords = false;
  bool _showBadge = false;

  double get percent => _percent;
  bool get refreshWords => _refreshWords;
  bool get showBadge => _showBadge;

  void resetPercent() {
    _percent = 1.0;
    notifyListeners();
  }

  void updatePercent(double newValue) {
    _percent = newValue.clamp(0.0, 1.0);
    notifyListeners();
  }

  void resetRefreshWords() {
    _refreshWords = false;
    notifyListeners();
  }

  void needRefreshWords() {
    _refreshWords = true;
    notifyListeners();
  }

  void updateShowBadge(bool newValue) {
    _showBadge = newValue;
    notifyListeners();
  }
}
