import 'package:flutter/material.dart';

import 'package:flutter_front_end/models/animationInfo.dart';
import 'package:flutter_front_end/models/scenarioAnimController.dart';

class ScenarioAnimator {
  late Animation? _progressAnimation;
  late Animation<Offset> _slideTransitionAnimation;
  late Animation<double> _fadeTransitionAnimation;

  int? oldDuration = null;

  animationInfo<Offset> slideIn = animationInfo<Offset>(
    Offset(0, 0),
    Offset(0, 0),
    Interval(0.0, 0.0, curve: Curves.easeInOutCubic),
  );

  animationInfo<Offset> slideOut = animationInfo<Offset>(
    Offset(0, 0),
    Offset(-2, 0),
    Interval(0.25, 1.0, curve: Curves.easeInOutCubic),
  );

  animationInfo<double> fadeIn = animationInfo<double>(
    0.0,
    1.0,
    Interval(0.0, 0.50, curve: Curves.easeInOutCubic),
  );

  animationInfo<double> fadeOut = animationInfo<double>(
    1.0,
    0.0,
    Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
  );

  animationInfo<Offset> basePos = animationInfo<Offset>(
    Offset(0, 0),
    Offset(0, 0),
    Interval(0.0, 0.0, curve: Curves.easeInOutCubic),
  );

  animationInfo<double> baseFade = animationInfo<double>(
    0.0,
    0.0,
    Interval(0.0, 0.0, curve: Curves.easeInOutCubic),
  );

  late ScenarioAnimController controller;
  late AnimationController animationController;

  ScenarioAnimator({
    required this.controller,
    required this.animationController,
  }) {}

  Future<void> _StartAnimation({int value = -1}) async {
    if (value > 0) {
      oldDuration = animationController.duration!.inSeconds;
      animationController.duration = Duration(seconds: value);
    }

    animationController.reset();

    await animationController.forward();

    if (oldDuration != null) {
      animationController.duration = Duration(seconds: oldDuration!);
      oldDuration = null;
    }
  }

  Future<void> idleScenarioAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: this.basePos.start,
      end: basePos.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: basePos.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed)
            controller.hasActiveScenario = false;
        },
      );

    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: baseFade.start, end: baseFade.end).animate(
      CurvedAnimation(
        parent: animationController,
        curve: baseFade.timeline,
      ),
    );

    // Progress Bar Animation
    // _progressAnimation = null;
    _progressAnimation = Tween(
      begin: 0.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          0.0,
          curve: Curves.linear,
        ),
      ),
    );

    await _StartAnimation();
  }

  Future<void> activatedScenarioAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: slideIn.start,
      end: slideIn.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: slideIn.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.hasActiveScenario = true;
            controller.activeScenarioLoading = true;
          }
        },
      );

    //Opacity Animation
    _fadeTransitionAnimation = Tween<double>(
      begin: fadeIn.start,
      end: fadeIn.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: fadeIn.timeline,
      ),
    );

    // Progress Bar Animation
    // _progressAnimation = null;
    _progressAnimation = Tween(
      begin: 0.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          0.0,
          curve: Curves.linear,
        ),
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.activeScenarioLoading = false;
          }
        },
      );

    await _StartAnimation();
  }

  Future<void> progressBarAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: slideIn.end,
      end: slideIn.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: slideIn.timeline,
      ),
    );

    //Opacity Animation
    _fadeTransitionAnimation = Tween<double>(
      begin: fadeIn.end,
      end: fadeIn.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: fadeIn.timeline,
      ),
    );

    // Progress Bar Animation
    _progressAnimation = Tween(
      begin: 0.0,
      end: 175.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    await _StartAnimation(value: 11);
  }

  Future<void> finishedScenarioAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: slideOut.start,
      end: slideOut.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: slideOut.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed)
            controller.hasActiveScenario = false;
        },
      );

    //Opacity Animation
    _fadeTransitionAnimation = Tween<double>(
      begin: fadeOut.start,
      end: fadeOut.end,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: fadeOut.timeline,
      ),
    );

    _progressAnimation = Tween(
      begin: 175.0,
      end: 175.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          0.0,
          curve: Curves.ease,
        ),
      ),
    );

    await _StartAnimation();
  }
}
