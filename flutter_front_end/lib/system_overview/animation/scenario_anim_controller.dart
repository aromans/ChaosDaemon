import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

class ScenarioAnimController with ChangeNotifier {
  // AnimationController controller;

  Delegate waitingIsDone = Delegate();

  bool hasActiveScenario = false;
  bool activeScenarioLoading = false;
  bool hasNextScenario = false;
  bool isDisplayed = false;

  bool mutex = false;

  // final _streamController = StreamController<bool>();

  ScenarioAnimController();

  // Stream<bool> get stream => _streamController.stream;

  Future<bool> runLockedMethod(Function fn) async {
    mutex = true;
    // _streamController.sink.add(mutex);
    await fn();
    mutex = false;
    // _streamController.sink.add(mutex);
    return true;
  }
}
