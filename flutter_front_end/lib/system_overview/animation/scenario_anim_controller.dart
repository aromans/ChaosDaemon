import 'package:flutter/material.dart';

class ScenarioAnimController with ChangeNotifier {
  // AnimationController controller;

  bool hasActiveScenario = false;
  bool activeScenarioLoading = false;
  bool hasNextScenario = false;
  bool isDisplayed = false;

  static bool mutex = false;

  int? oldDuration = null;

  ScenarioAnimController() {}

  static Future<bool> runLockedMethod(Function fn) async {
    if (mutex) {
      await HoldForMutex();
    }

    mutex = true;
    final result = await fn();
    mutex = true;
    return Future<bool>.value(result);
  }

  static Future<bool> HoldForMutex() async {
    while (!mutex) {}
    return Future<bool>.value(true);
  }
}
