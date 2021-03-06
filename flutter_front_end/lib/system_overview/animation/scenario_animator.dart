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

  final double barHeight;

  ScenarioAnimator(this._controller, this.barHeight) {
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
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );
    slideDouble = AnimationInfo<Offset>(
      Offset(1.0, 0),
      Offset(-0.25, 0),
      Interval(
        0.0,
        1.0,
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
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );
    fadeInFull = AnimationInfo<double>(
      0.0,
      1.0,
      Interval(
        0.0,
        1.0,
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
    // transitionColor = AnimationInfo<Color>(Colors.red, Color.fromARGB(255, 128, 0, 0),
    //     Interval(0.0, 0.1, curve: Curves.easeInOut));
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
    );

    var fade = Tween<double>(begin: baseFade.start, end: baseFade.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: baseFade.timeline,
      ),
    );

    return AnimData(position, fade);
  }

    AnimData idleActive() {
    var position = Tween<Offset>(
      begin: slideDouble.end,
      end: slideDouble.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: basePos.timeline,
      ),
    );

    var fade = Tween<double>(begin: fadeInFull.end, end: fadeInFull.end).animate(
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
        parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear)));
  }

    Animation<double> idleFillProgressBar() {
    return Tween(begin: barHeight, end: barHeight).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear)));
  }

  Animation<double> loadingProgressBar() {
    return Tween(begin: 0.0, end: barHeight).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.1, 1.0, curve: Curves.linear)));
  }

  // Animation<Color?> idleColor() {
  //   return ColorTween(
  //           begin: Colors.red, end: Colors.red)
  //       .animate(_controller);
  // }

  //   Animation<Color?> idleActiveColor() {
  //   return ColorTween(
  //           begin: Color.fromARGB(255, 128, 0, 0), end: Color.fromARGB(255, 128, 0, 0))
  //       .animate(_controller);
  // }

  // Animation<Color?> activeColor() {
  //   return ColorTween(begin: transitionColor.start, end: transitionColor.end)
  //       .animate(CurvedAnimation(
  //           parent: _controller, curve: transitionColor.timeline));
  // }
}
