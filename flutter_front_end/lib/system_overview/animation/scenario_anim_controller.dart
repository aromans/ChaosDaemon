import 'package:flutter/material.dart';

class ScenarioAnimController with ChangeNotifier {
  // AnimationController controller;

  bool hasActiveScenario = false;
  bool activeScenarioLoading = false;
  bool hasNextScenario = false;

  int? oldDuration = null;

  ScenarioAnimController();

  // void StartAnimation({int value = -1}) async {
  //   if (value > 0) {
  //     oldDuration = controller.duration!.inSeconds;
  //     controller.duration = Duration(seconds: value);
  //   }

  //   controller.reset();

  //   await controller.forward();

  //   if (oldDuration != null) {
  //     controller.duration = Duration(seconds: oldDuration!);
  //     oldDuration = null;
  //   }

  //   notifyListeners();
  // }
}