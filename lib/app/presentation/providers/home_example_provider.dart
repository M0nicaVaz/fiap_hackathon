import 'package:flutter/foundation.dart';

class HomeExampleProvider extends ChangeNotifier {
  int _clickCount = 0;

  int get clickCount => _clickCount;

  void increment() {
    _clickCount++;
    notifyListeners();
  }

  void reset() {
    _clickCount = 0;
    notifyListeners();
  }
}
