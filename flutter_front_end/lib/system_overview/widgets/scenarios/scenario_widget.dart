import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:provider/provider.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_animator.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';

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
  // late Animation<Color?>? _colorAnimation;

  // final Color bgColor = Color.fromARGB(255, 147, 159, 92);
  // final Color fillColor = Color.fromARGB(255, 60, 65, 37);

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    animStatus = widget.animStatus;
    animator = ScenarioAnimator(_controller);

    super.initState();

    widget.isInitialized = true;
  }

  Future<void> idleAnimation() async {
    animStatus.hasActiveScenario = false;
    animStatus.activeScenarioLoading = false;
    animStatus.hasNextScenario = false;

    AnimData idle = animator.idle();
    // _colorAnimation = animator.idleColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = idle.position;
    _fadeAnimation = idle.fade;
    await _StartAnimation();
  }

  Future<void> arriveActiveAnimation() async {
    animStatus.hasActiveScenario = true;
    animStatus.activeScenarioLoading = true;

    AnimData arriveActive = animator.arriveActive();
    // _colorAnimation = animator.activeColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = arriveActive.position;
    _fadeAnimation = arriveActive.fade;
    await _StartAnimation();

    animStatus.addToQueue();

    AnimData loadBarActive = animator.idleActive();
    // _colorAnimation = animator.idleActiveColor();
    _progressAnimation = animator.loadingProgressBar();
    _positionAnimation = loadBarActive.position;
    _fadeAnimation = loadBarActive.fade;
    await _StartAnimation(value: widget.scenario.duration);

    animStatus.activeScenarioLoading = false;
  }

  Future<void> singleQueuedAnimation() async {
    animStatus.hasNextScenario = true;
    animStatus.waitingIsDone + ControlAnimations;

    AnimData queued = animator.singleQueued();
    // _colorAnimation = animator.idleColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = queued.position;
    _fadeAnimation = queued.fade;
    await _StartAnimation();
  }

  Future<void> singleActiveAnimation() async {
    AnimData activated = animator.singleActive();
    // _colorAnimation = animator.activeColor();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = activated.position;
    _fadeAnimation = activated.fade;
    await _StartAnimation();

    animStatus.hasActiveScenario = true;
    animStatus.hasNextScenario = false;
    animStatus.activeScenarioLoading = true;
    animStatus.addToQueue();

    AnimData activeLoadBar = animator.idleActive();
    // _colorAnimation = animator.idleActiveColor();
    _progressAnimation = animator.loadingProgressBar();
    _positionAnimation = activeLoadBar.position;
    _fadeAnimation = activeLoadBar.fade;
    await _StartAnimation(value: widget.scenario.duration);

    animStatus.activeScenarioLoading = false;
  }

  Future<void> exitAnimation() async {
    AnimData exit = animator.exit();
    // _colorAnimation = animator.idleActiveColor();
    _progressAnimation = animator.idleFillProgressBar();
    _positionAnimation = exit.position;
    _fadeAnimation = exit.fade;
    await _StartAnimation(value: 1);

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
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);
    final Color bgColor = status.darkModeEnabled
        ? Color.fromARGB(126, 239, 35, 60)
        : Color.fromARGB(255, 255, 71, 71);
    final Color fillColor = status.darkModeEnabled
        ? Color.fromARGB(255, 239, 35, 60)
        : Color.fromARGB(255, 205, 0, 0);
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
                        color: bgColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: 45,
                    height: 175,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: fillColor,
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
                        Text('Scenario',
                            textWidthBasis: TextWidthBasis.parent,
                            style: Theme.of(context).textTheme.headline1
                            // style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,
                            //     foreground: Paint()
                            //       ..style = PaintingStyle.stroke
                            //       ..strokeWidth = 3.0
                            //       ..color = Colors.black),
                            ),
                        Text(
                          'Scenario',
                          style: Theme.of(context).textTheme.headline1,
                        )
                      ])))),
            ]))));
  }

  Future<void> ControlAnimations() async {
    if (animStatus.hasActiveScenario && animStatus.hasNextScenario) return;

    if (!animStatus.hasActiveScenario && !animStatus.hasNextScenario) {
      await animStatus.runLockedMethod(arriveActiveAnimation);
    } else if (!animStatus.hasActiveScenario && animStatus.hasNextScenario) {
      await animStatus.runLockedMethod(singleActiveAnimation);
      animStatus.waitingIsDone - ControlAnimations;
    } else if (animStatus.hasActiveScenario && !animStatus.hasNextScenario) {
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
