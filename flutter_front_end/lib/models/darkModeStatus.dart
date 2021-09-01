import 'package:flutter/material.dart';

class DarkModeStatus extends ChangeNotifier {
  bool darkModeEnabled = false;

  void toggle(bool value) {
    darkModeEnabled = value;

    print(darkModeEnabled);

    notifyListeners();
  }
}