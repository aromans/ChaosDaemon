import 'package:flutter/material.dart';

import 'package:flutter_front_end/system_overview/animation/animation_info.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';

class AnimData {
  final Animation<Offset> position;
  final Animation<double> fade;

  const AnimData(this.position, this.fade);
}

class ScenarioAnimator {
  final AnimationController _controller;
  final ScenarioAnimController _animStatus;

  late AnimationInfo<double> fadeInArrival;
  late AnimationInfo<double> fadeInActive;
  late AnimationInfo<double> fadeInFull;
  late AnimationInfo<double> fadeOut;

  late AnimationInfo<double> baseFade;
  late AnimationInfo<Offset> basePos;

  late AnimationInfo<Offset> slideSingleArrival;
  late AnimationInfo<Offset> slideSingleActive;
  late AnimationInfo<Offset> slideDouble;
  late AnimationInfo<Offset> slideOut;

  late AnimationInfo<Color> transitionColor;

  ScenarioAnimator(this._controller, this._animStatus) {
    // -- Idle --
    basePos = AnimationInfo<Offset>(
      Offset(0, 0),
      Offset(0, 0),
      Interval(
        0.0,
        0.0,
        curve: Curves.easeInOutCubic,
      ),
    );
    baseFade = AnimationInfo<double>(
      0.0,
      0.0,
      Interval(
        0.0,
        0.0,
        curve: Curves.easeInOutCubic,
      ),
    );

    // -- Positions --
    slideSingleArrival = AnimationInfo<Offset>(
      Offset(1, 0),
      Offset(0.25, 0),
      Interval(
        0.0,
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );
    slideSingleActive = AnimationInfo<Offset>(
      Offset(0.25, 0),
      Offset(-0.25, 0),
      Interval(
        0.0,
        0.1,
        curve: Curves.easeInOutCubic,
      ),
    );
    slideDouble = AnimationInfo<Offset>(
      Offset(1.0, 0),
      Offset(-0.25, 0),
      Interval(
        0.0,
        0.1,
        curve: Curves.easeInOutCubic,
      ),
    );

    // -- Fades --
    fadeInArrival = AnimationInfo<double>(
      0.0,
      0.5,
      Interval(
        0.0,
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );
    fadeInActive = AnimationInfo<double>(
      0.5,
      1.0,
      Interval(
        0.0,
        0.1,
        curve: Curves.easeInOutCubic,
      ),
    );
    fadeInFull = AnimationInfo<double>(
      0.0,
      1.0,
      Interval(
        0.0,
        0.1,
        curve: Curves.easeInOutCubic,
      ),
    );

    // -- Exit --
    slideOut = AnimationInfo<Offset>(
      Offset(0, 0),
      Offset(-1, 0),
      Interval(
        0.25,
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );
    fadeOut = AnimationInfo<double>(
      1.0,
      0.0,
      Interval(
        0.0,
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );

    // -- Color --
    transitionColor = AnimationInfo<Color>(Colors.yellow.shade700, Colors.red,
        Interval(0.0, 0.1, curve: Curves.easeInOut));
  }

  // -- Base Animation Groups --
  AnimData idle() {
    var position = Tween<Offset>(
      begin: basePos.start,
      end: basePos.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: basePos.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _animStatus.hasActiveScenario = false;
            _animStatus.hasNextScenario = false;
            _animStatus.isDisplayed = true;
          }
        },
      );

    var fade = Tween<double>(begin: baseFade.start, end: baseFade.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: baseFade.timeline,
      ),
    );

    return AnimData(position, fade);
  }

  AnimData arriveActive() {
    var position = Tween<Offset>(
      begin: slideDouble.start,
      end: slideDouble.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: slideDouble.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed)
            _animStatus.hasActiveScenario = true;
        },
      );

    var fade =
        Tween<double>(begin: fadeInFull.start, end: fadeInFull.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: fadeInFull.timeline,
      ),
    );

    return AnimData(position, fade);
  }

  AnimData singleQueued() {
    var position = Tween<Offset>(
      begin: slideSingleArrival.start,
      end: slideSingleArrival.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: slideSingleArrival.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed)
            _animStatus.hasNextScenario = true;
        },
      );

    var fade = Tween<double>(begin: fadeInArrival.start, end: fadeInArrival.end)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: fadeInArrival.timeline,
      ),
    );

    return AnimData(position, fade);
  }

  AnimData singleActive() {
    var position = Tween<Offset>(
      begin: slideSingleActive.start,
      end: slideSingleActive.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: slideSingleActive.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.forward) {
            _animStatus.hasNextScenario = false;
          }
          if (status == AnimationStatus.completed) {
            _animStatus.hasActiveScenario = true;
          }
        },
      );

    var fade =
        Tween<double>(begin: fadeInActive.start, end: fadeInActive.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: fadeInActive.timeline,
      ),
    );

    return AnimData(position, fade);
  }

  AnimData exit() {
    var position = Tween<Offset>(
      begin: slideSingleActive.end,
      end: slideSingleActive.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: slideOut.timeline,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed)
            _animStatus.hasActiveScenario = false;
          _animStatus.isDisplayed = false;
        },
      );

    var fade = Tween<double>(begin: fadeOut.start, end: fadeOut.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: fadeOut.timeline,
      ),
    );

    return AnimData(position, fade);
  }

  // -- Special Animations --
  Animation<double> idleProgressBar() {
    return Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _animStatus.activeScenarioLoading = false;
      }));
  }

  Animation<double> loadingProgressBar() {
    _animStatus.activeScenarioLoading = true;

    return Tween(begin: 0.0, end: 175.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.1, 1.0, curve: Curves.linear))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _animStatus.activeScenarioLoading = false;
      }));
  }

  Animation<Color?> idleColor() {
    return ColorTween(
            begin: Colors.yellow.shade700, end: Colors.yellow.shade700)
        .animate(_controller);
  }

  Animation<Color?> activeColor() {
    return ColorTween(begin: transitionColor.start, end: transitionColor.end)
        .animate(CurvedAnimation(
            parent: _controller, curve: transitionColor.timeline));
  }
}
