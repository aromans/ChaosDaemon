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

  final double height = 160.0;
  final double width = 45.0;
  // late Animation<Color?>? _colorAnimation;

  // final Color bgColor = Color.fromARGB(255, 147, 159, 92);
  // final Color fillColor = Color.fromARGB(255, 60, 65, 37);

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    animStatus = widget.animStatus;
    animator = ScenarioAnimator(_controller, height);

    super.initState();

    widget.isInitialized = true;
  }

  Future<void> idleAnimation() async {
    AnimData idle = animator.idle();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = idle.position;
    _fadeAnimation = idle.fade;
    await _StartAnimation();
  }

  Future<void> arriveActiveAnimation() async {
    animStatus.hasActive = true;

    AnimData arriveActive = animator.arriveActive();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = arriveActive.position;
    _fadeAnimation = arriveActive.fade;
    await _StartAnimation();

    animStatus.addToQueue();

    AnimData loadBarActive = animator.idleActive();
    _progressAnimation = animator.loadingProgressBar();
    _positionAnimation = loadBarActive.position;
    _fadeAnimation = loadBarActive.fade;
    await _StartAnimation(value: widget.scenario.duration);

    await animStatus.runLockedMethod(exitAnimation);
  }

  Future<void> singleQueuedAnimation() async {
    animStatus.waitCount += 1;
    animStatus.waitingIsDone + ControlAnimations;

    AnimData queued = animator.singleQueued();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = queued.position;
    _fadeAnimation = queued.fade;
    await _StartAnimation();
  }

  Future<void> singleActiveAnimation() async {
    AnimData activated = animator.singleActive();
    _progressAnimation = animator.idleProgressBar();
    _positionAnimation = activated.position;
    _fadeAnimation = activated.fade;
    await _StartAnimation();

    if (animStatus.waitCount > 0) animStatus.waitCount -= 1;
    animStatus.hasActive = true;

    animStatus.addToQueue();
    animStatus.waitingIsDone - ControlAnimations;

    AnimData activeLoadBar = animator.idleActive();
    _progressAnimation = animator.loadingProgressBar();
    _positionAnimation = activeLoadBar.position;
    _fadeAnimation = activeLoadBar.fade;
    await _StartAnimation(value: widget.scenario.duration);

    await animStatus.runLockedMethod(exitAnimation);
  }

  Future<void> exitAnimation() async {
    AnimData exit = animator.exit();
    _progressAnimation = animator.idleFillProgressBar();
    _positionAnimation = exit.position;
    _fadeAnimation = exit.fade;
    await _StartAnimation(value: 1);

    animStatus.hasActive = false;
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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    MouseRegion(
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 14, 14, 14)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ]
                        ),
                        width: width,
                        height: height,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      width: width,
                      height: _progressAnimation?.value,
                    )
                  ],
                ),
              ),
              Align(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    child: Stack(
                      children: [
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> ControlAnimations() async {
    if (!animStatus.hasActive && animStatus.waitCount == 0) {
      await animStatus.runLockedMethod(arriveActiveAnimation);
    } else if (animStatus.waitCount >= 1) {
      await animStatus.runLockedMethod(singleActiveAnimation);
    } else {
      await animStatus.runLockedMethod(singleQueuedAnimation);
      return;
    }

    await animStatus.runLockedMethod(idleAnimation);
  }

  @override
  Widget build(BuildContext context) {
    ControlAnimations();
    return AnimatedBuilder(builder: _buildAnimation, animation: _controller);
  }
}
