import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_front_end/system_overview/animation/animation_info.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class NextScenarioStat extends StatefulWidget {
  NextScenarioStat({Key? key}) : super(key: key);

  late NextScenarioStatState state;

  bool isInitialized = false;

  @override
  State<StatefulWidget> createState() { 
    state = NextScenarioStatState(); 
    return state;  
  }
}

class NextScenarioStatState extends State<NextScenarioStat>
    with TickerProviderStateMixin {

  late ScenarioAnimController controller;

  late AnimationController _controller;

  late Animation<Offset> _slideTransitionAnimation;
  late Animation<double> _fadeTransitionAnimation;
  late Animation<Color?>? _colorTransitionAnimation;

  late AnimationInfo<Offset> arrivalSlide;
  late AnimationInfo<Offset> transitionSlide;
  late AnimationInfo<Offset> exitSlide;

  late AnimationInfo<double> arrivalFade;
  late AnimationInfo<double> transitionFade;
  late AnimationInfo<double> exitFade;

  late AnimationInfo<double> baseFade;
  late AnimationInfo<Offset> basePos;

  late final AnimationInfo<Color> transitionColor;

  Decoration outline =
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration fill =
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    arrivalSlide    = AnimationInfo<Offset>(Offset(1, 0), Offset(0, 0), Interval(0.25, 0.75, curve: Curves.easeInOutCubic));
    transitionSlide = AnimationInfo<Offset>(Offset(0, 0), Offset(-1.05, 0), Interval(0.25, 0.75, curve: Curves.easeInOutCubic));
    exitSlide       = AnimationInfo<Offset>(Offset(-1.05, 0), Offset(1, 0), Interval(0.95, 1.0, curve: Curves.easeInOutCubic));

    arrivalFade     = AnimationInfo<double>(0.0, 0.5, Interval(0.0, 0.50, curve: Curves.easeInOutCubic));
    transitionFade  = AnimationInfo<double>(0.5, 1.0, Interval(0.5, 0.75, curve: Curves.easeInOutCubic));
    exitFade        = AnimationInfo<double>(1.0, 0.0, Interval(0.0, 0.2, curve: Curves.easeInOutCubic));

    basePos = AnimationInfo<Offset>(Offset(0, 0), Offset(0, 0), Interval(0.0, 0.0, curve: Curves.easeInOutCubic));
    baseFade  = AnimationInfo<double>(0.0, 0.0, Interval(0.0, 0.0, curve: Curves.easeInOutCubic));

    transitionColor = AnimationInfo<Color>(Colors.yellow.shade700, Colors.red, Interval(0.75, 1, curve: Curves.easeInOut));

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
    ))..addStatusListener((status) { if (status == AnimationStatus.completed) controller.hasNextScenario = false; });

    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: baseFade.start, end: baseFade.end).animate(CurvedAnimation(
      parent: _controller,
      curve: baseFade.timeline,
    ));

    this._colorTransitionAnimation = ColorTween(begin: Colors.yellow.shade700, end: Colors.yellow.shade700).animate(_controller);

    await _StartAnimation();
  }

  Future<void> newArrivalAnimation() async {
    this._slideTransitionAnimation = Tween<Offset>(
      begin: arrivalSlide.start,
      end: arrivalSlide.end,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: arrivalSlide.timeline
    ))..addStatusListener((status) { if (status == AnimationStatus.completed) controller.hasNextScenario = true; });

    this._fadeTransitionAnimation = Tween<double>(
      begin:  arrivalFade.start, 
      end: arrivalFade.end
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: arrivalFade.timeline
    ));

    this._colorTransitionAnimation = ColorTween(begin: Colors.yellow.shade700, end: Colors.yellow.shade700).animate(_controller);

    await _StartAnimation();
  }

  Future<void> transitionAnimation() async {
    this._slideTransitionAnimation = Tween<Offset>(
      begin: transitionSlide.start,
      end: transitionSlide.end,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: transitionSlide.timeline
    ))..addStatusListener((status) { if (status == AnimationStatus.completed) controller.hasNextScenario = false; });

    this._fadeTransitionAnimation = Tween<double>(
      begin:  transitionFade.start, 
      end: transitionFade.end
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: transitionFade.timeline
    ));

    this._colorTransitionAnimation =
        ColorTween(begin: transitionColor.start, end: transitionColor.end)
            .animate(CurvedAnimation(
                parent: _controller,
                curve: transitionColor.timeline
        ));

    await _StartAnimation();
  }

  Future<void> exitAnimation() async {
    this._slideTransitionAnimation = Tween<Offset>(
      begin: exitSlide.start,
      end: exitSlide.end,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: exitSlide.timeline
    ))..addStatusListener((status) { if (status == AnimationStatus.completed) controller.hasNextScenario = false; });

    this._fadeTransitionAnimation = Tween<double>(
      begin:  exitFade.start, 
      end: exitFade.end
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: exitFade.timeline
    ));

    this._colorTransitionAnimation = null;

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
                    decoration: BoxDecoration(
                        color: _colorTransitionAnimation?.value,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: 45,
                    height: 175,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: _colorTransitionAnimation?.value,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  width: 45,
                  height: 175,
                )
              ])),
              Align(
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                          child: Stack(children: [
                        Text(
                          'Next Scenario',
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
                          'Next Scenario',
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
    controller = Provider.of<ScenarioAnimController>(context);

    init();

    return AnimatedBuilder(
        builder: _buildAnimation, animation: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
