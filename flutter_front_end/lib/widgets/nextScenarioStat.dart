import 'dart:ui';
import 'package:flutter/material.dart';

class nextScenarioStat extends StatefulWidget {
  nextScenarioStat({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => nextScenarioStatState();
}

class nextScenarioStatState extends State<nextScenarioStat>
    with SingleTickerProviderStateMixin {
  //late final AnimationController _progressController;
  late final AnimationController _transitionController;
  //late final Animation _progressAnimation;
  late final Animation<Offset> _slideTransitionAnimation;
  //late final Animation<double> _curve;
  late final Animation<double> _fadeTransitionAnimation;
  late final Animation<Color?> _colorTransitionAnimation;

  Decoration outline =
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration fill =
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  void initState() {
    _transitionController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // Progress Bar
    /*
    _progressController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _curve = CurvedAnimation(
        parent: _progressController, curve: Curves.easeInOutCubic);
    _progressAnimation = Tween(begin: 0.0, end: 175.0).animate(_curve)
      ..addListener(() {
        setState(() {});
      });
    */
    // Slide Transition
    _slideTransitionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Interval(0.25, 0.75, curve: Curves.easeInOut),
    ));
    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Interval(0.5, 0.75, curve: Curves.easeInOut),
    ));
    // Color Animation
    _colorTransitionAnimation =
        ColorTween(begin: Colors.yellow.shade700, end: Color.fromARGB(255, 184, 15, 10))
            .animate(CurvedAnimation(
                parent: _transitionController,
                curve: Interval(0.75, 1, curve: Curves.easeInOut)));
    super.initState();
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
                        color: _colorTransitionAnimation.value,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: 45,
                    height: 175,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: _colorTransitionAnimation.value,
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
    _transitionController.forward();
    return AnimatedBuilder(
        builder: _buildAnimation, animation: _transitionController);
  }

  @override
  void dispose() {
    //_progressController.dispose();
    _transitionController.dispose();
    super.dispose();
  }
}
