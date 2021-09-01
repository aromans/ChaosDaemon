import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_front_end/models/animationInfo.dart';
import 'package:flutter_front_end/models/scenarioAnimController.dart';
import 'package:provider/provider.dart';


class currentScenarioStat extends StatefulWidget {

  currentScenarioStat({Key? key}) : super(key: key);

  late currentScenarioStatState state;

  bool isInitialized = false;

  @override
  State<StatefulWidget> createState() {
    state = currentScenarioStatState();

    return state;
  }
}

class currentScenarioStatState extends State<currentScenarioStat>
    with TickerProviderStateMixin {

  late scenarioAnimController controller;

  late AnimationController _controller;

  late Animation? _progressAnimation;
  late Animation<Offset> _slideTransitionAnimation;
  late Animation<double> _fadeTransitionAnimation;

  late animationInfo<double> fadeIn;
  late animationInfo<double> fadeOut;

  late animationInfo<double> baseFade;
  late animationInfo<Offset> basePos;

  late animationInfo<Offset> slideIn;
  late animationInfo<Offset> slideOut;

  Decoration outline = BoxDecoration(
      color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration fill = BoxDecoration(
      // color: Colors.red[900],
      color: Color.fromARGB(255, 184, 15, 10),
      borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  void initState() {
   _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    slideIn  = animationInfo<Offset>(Offset(0, 0), Offset(0, 0), Interval(0.0, 0.0, curve: Curves.easeInOutCubic));
    slideOut = animationInfo<Offset>(Offset(0, 0), Offset(-2, 0), Interval(0.25, 1.0, curve: Curves.easeInOutCubic));

    fadeIn   = animationInfo<double>(0.0, 1.0, Interval(0.0, 0.50, curve: Curves.easeInOutCubic));
    fadeOut  = animationInfo<double>(1.0, 0.0, Interval(0.0, 1.0, curve: Curves.easeInOutCubic));

    basePos = animationInfo<Offset>(Offset(0, 0), Offset(0, 0), Interval(0.0, 0.0, curve: Curves.easeInOutCubic));
    baseFade  = animationInfo<double>(0.0, 0.0, Interval(0.0, 0.0, curve: Curves.easeInOutCubic));

    idleScenarioAnimation();

    super.initState();
  }

  void init() {
    widget.isInitialized = true;
  }

  Future<void> idleScenarioAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: basePos.start,
      end: basePos.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: basePos.timeline,
    ))..addStatusListener((status) { if (status == AnimationStatus.completed) controller.hasActiveScenario = false;});

    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: baseFade.start, end: baseFade.end).animate(CurvedAnimation(
      parent: _controller,
      curve: baseFade.timeline,
    ));

    // Progress Bar Animation
    // _progressAnimation = null;
    _progressAnimation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear)))
      ..addListener(() {
        setState(() {});
      });

    await _StartAnimation();
  }

  Future<void> activatedScenarionAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: slideIn.start,
      end: slideIn.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: slideIn.timeline,
    ))..addStatusListener((status) { 
      if (status == AnimationStatus.completed) {
        controller.hasActiveScenario = true;
        controller.activeScenarioLoading = true;
      }
    });

    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: fadeIn.start, end: fadeIn.end).animate(CurvedAnimation(
      parent: _controller,
      curve: fadeIn.timeline,
    ));

    // Progress Bar Animation
    // _progressAnimation = null;
    _progressAnimation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.activeScenarioLoading = false;
        }
      });

    await _StartAnimation();
  }

  Future<void> progressBarAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: slideIn.end,
      end: slideIn.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: slideIn.timeline,
    ));

    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: fadeIn.end, end: fadeIn.end).animate(CurvedAnimation(
      parent: _controller,
      curve: fadeIn.timeline,
    ));

    // Progress Bar Animation
    _progressAnimation = Tween(begin: 0.0, end: 175.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.ease)));

    await _StartAnimation(value: 11);
  }

  Future<void> finishedScenarioAnimation() async {
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: slideOut.start,
      end: slideOut.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: slideOut.timeline,
    ))..addStatusListener((status) { if (status == AnimationStatus.completed) controller.hasActiveScenario = false;});

    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: fadeOut.start, end: fadeOut.end).animate(CurvedAnimation(
      parent: _controller,
      curve: fadeOut.timeline,
    ));

    _progressAnimation = Tween(begin: 175.0, end: 175.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.ease)))
      ..addListener(() {
        setState(() {});
      });

    await _StartAnimation();
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
      opacity: _fadeTransitionAnimation,
      child: SlideTransition(
          position: _slideTransitionAnimation,
          child: Container(
              child: Stack(alignment: Alignment.topCenter, children: [
            Align(
                child: Stack(alignment: Alignment.bottomCenter, children: [
              MouseRegion(
                child: Container(
                  decoration: outline,
                  width: 45,
                  height: 175,
                ),
              ),
              Container(
                decoration: fill,
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

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<scenarioAnimController>(context);

    init();

    return AnimatedBuilder(
        builder: _buildAnimation, animation: _controller);
  }
}