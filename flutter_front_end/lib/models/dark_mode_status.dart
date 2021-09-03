import 'package:flutter/material.dart';

class DarkModeStatus extends ChangeNotifier {
  bool darkModeEnabled = true;

  void toggle(bool value) {
    darkModeEnabled = value;

    notifyListeners();
  }
}