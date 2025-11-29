import 'package:flutter/material.dart';

class Store extends ChangeNotifier {
  double _percent = 1.0;

  double get percent => _percent;

  void resetPercent() {
    _percent = 1.0;
    notifyListeners();
  }

  void updatePercent(double newPercent) {
    _percent = newPercent.clamp(0.0, 1.0);
    notifyListeners();
  }
}
