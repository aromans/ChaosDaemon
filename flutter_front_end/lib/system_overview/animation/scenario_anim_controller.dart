import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

class ScenarioAnimController with ChangeNotifier {
  Delegate waitingIsDone = Delegate();
  Delegate addToQueue = Delegate();

  bool hasActiveScenario = false;
  bool activeScenarioLoading = false;
  bool hasNextScenario = false;

  bool mutex = false;

  ScenarioAnimController();

  Future<bool> runLockedMethod(Function fn) async {
    mutex = true;
    await fn();
    mutex = false;
    return true;
  }
}
