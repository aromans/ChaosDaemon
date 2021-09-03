import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/scenario.dart';

import 'package:flutter_front_end/system_overview/animation/scenario_animator.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class ScenarioWidget extends StatefulWidget {
  late final Scenario scenario;
  late ScenarioAnimController animStatus;

  ScenarioWidget(this.scenario, this.animStatus, {Key? key}) : super(key: key);

  late ScenarioWidgetState state;

  bool isInitialized = false;

  @override
  State<StatefulWidget> createState() {
    state = ScenarioWidgetState();
    return state;
  }
}

class ScenarioWidgetState extends State<ScenarioWidget>
    with TickerProviderStateMixin {
  late final ScenarioAnimator animator;

  late ScenarioAnimController animStatus;
  late AnimationController _controller;

  late Animation? _progressAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?>? _colorAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    animStatus = widget.animStatus;
    animator = ScenarioAnimator(_controller, animStatus);

    super.initState();

    widget.isInitialized = true;
  }

  Future<void> idleAnimation() async {
    animStatus.hasActiveScenario = false;
    animStatus.activeScenarioLoading = false;
    animStatus.hasNextScenario = false;

    AnimData idle = animator.idle();
    _colorAnimation = animator.idleColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = idle.position;
    _fadeAnimation = idle.fade;
    await _StartAnimation();
  }

  Future<void> arriveActiveAnimation() async {
    animStatus.hasActiveScenario = true;
    animStatus.activeScenarioLoading = true;

    AnimData arriveActive = animator.arriveActive();
    _colorAnimation = animator.activeColor();
    _progressAnimation = animator.loadingProgressBar();
    _positionAnimation = arriveActive.position;
    _fadeAnimation = arriveActive.fade;
    await _StartAnimation(value: widget.scenario.duration);

    animStatus.activeScenarioLoading = false;
  }

  Future<void> singleQueuedAnimation() async {
    animStatus.hasNextScenario = true;
    animStatus.waitingIsDone + ControlAnimations;
    
    AnimData queued = animator.singleQueued();
    _colorAnimation = animator.idleColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = queued.position;
    _fadeAnimation = queued.fade;
    await _StartAnimation();
  }

  Future<void> singleActiveAnimation() async {
    animStatus.hasActiveScenario = true;
    animStatus.activeScenarioLoading = true;
    if (animStatus.hasNextScenario) animStatus.hasNextScenario = false;

    AnimData activated = animator.singleActive();
    _colorAnimation = animator.activeColor();
    _progressAnimation = animator.loadingProgressBar();
    _positionAnimation = activated.position;
    _fadeAnimation = activated.fade;
    await _StartAnimation(value: widget.scenario.duration);
    
    animStatus.activeScenarioLoading = false;
  }

  Future<void> exitAnimation() async {
    AnimData exit = animator.exit();
    _colorAnimation = animator.idleColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = exit.position;
    _fadeAnimation = exit.fade;
    await _StartAnimation();

    animStatus.hasActiveScenario = false;
    animStatus.waitingIsDone();
  }

  int? oldDuration = null;

  Future<void> _StartAnimation({int value = -1}) async {
    if (value > 0) {
      oldDuration = _controller.duration!.inSeconds;
      _controller.duration = Duration(seconds: value);
    }

    _controller.reset();

    await _controller.forward();

    if (oldDuration != null) {
      _controller.duration = Duration(seconds: oldDuration!);
      oldDuration = null;
    }
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
            position: _positionAnimation,
            child: Container(
                child: Stack(alignment: Alignment.topCenter, children: [
              Align(
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                MouseRegion(
                  child: Container(
                    decoration: BoxDecoration(
                        color: _colorAnimation?.value,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: 45,
                    height: 175,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  width: 45,
                  height: _progressAnimation?.value,
                )
              ])),
              Align(
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                          child: Stack(children: [
                        Text(
                          'Current Scenario',
                          textWidthBasis: TextWidthBasis.parent,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3.0
                                ..color = Colors.black),
                        ),
                        Text(
                          'Current Scenario',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ])))),
            ]))));
  }

  Future singleActive() async {
    await animStatus.runLockedMethod(singleActiveAnimation);
    await animStatus.runLockedMethod(exitAnimation);
  }

  Future<void> ControlAnimations() async {
    if (animStatus.hasActiveScenario && animStatus.hasNextScenario) return;

    // print("---------------------------------------");
    // print("Active: " + animStatus.hasActiveScenario.toString());
    // print("Next: " + animStatus.hasNextScenario.toString());
    // print("Load: " + animStatus.activeScenarioLoading.toString());

    if (!animStatus.hasActiveScenario && !animStatus.hasNextScenario) {
      // Load the next queued Scenario Visualization
      await animStatus.runLockedMethod(arriveActiveAnimation);
    } else if (!animStatus.hasActiveScenario && animStatus.hasNextScenario) {
      await animStatus.runLockedMethod(singleActiveAnimation);
    } else if (animStatus.hasActiveScenario && !animStatus.hasNextScenario) {
      // If current scenario is still active
      await animStatus.runLockedMethod(singleQueuedAnimation);
      return;
    }

    // If current visualization doesn't exit
    if (animStatus.hasActiveScenario && !animStatus.activeScenarioLoading) {
      await animStatus.runLockedMethod(exitAnimation);
    }

    await animStatus.runLockedMethod(idleAnimation);
  }

  @override
  Widget build(BuildContext context) {
    ControlAnimations();
    return AnimatedBuilder(builder: _buildAnimation, animation: _controller);
  }
}
