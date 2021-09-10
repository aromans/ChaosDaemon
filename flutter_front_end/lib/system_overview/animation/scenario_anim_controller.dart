import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

class ScenarioAnimController with ChangeNotifier {
  Delegate waitingIsDone = Delegate();
  Delegate addToQueue = Delegate();

  bool hasActive = false;
  int waitCount = 0;

  ScenarioAnimController();

  Future<bool> runLockedMethod(Function fn) async {
    await fn();
    return true;
  }
}
