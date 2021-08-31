import 'dart:ui';
import 'package:flutter/material.dart';

class currentScenarioStat extends StatefulWidget {
  currentScenarioStat({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => currentScenarioStatState();
}

class currentScenarioStatState extends State<currentScenarioStat>
    with SingleTickerProviderStateMixin {
  //late final AnimationController _progressController;
  late final AnimationController _transitionController;
  //late final Animation _progressAnimation;
  late final Animation<Offset> _slideTransitionAnimation;
  late final Animation<double> _fadeTransitionAnimation;
  //late final Animation<double> _curve;

  Decoration outline = BoxDecoration(
      color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration fill = BoxDecoration(
      // color: Colors.red[900],
      color: Color.fromARGB(255, 184, 15, 10),
      borderRadius: BorderRadius.all(Radius.circular(8.0)));

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
      end: Offset(-2, 0),
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Interval(0.25, 1, curve: Curves.easeInOut),
    ));
    //Opacity Animation
    _fadeTransitionAnimation =
        Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Interval(0, 1, curve: Curves.easeInOut),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _transitionController.forward();
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
                  height: 175,
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
  void dispose() {
    //_progressController.dispose();
    _transitionController.dispose();
    super.dispose();
  }
}
