import 'dart:ui';
import 'package:flutter/material.dart';

class currentScenarioStat extends StatefulWidget {
  currentScenarioStat({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => currentScenarioStatState();
}

class currentScenarioStatState extends State<currentScenarioStat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;
  late final Animation<double> _curve;

  Decoration outline = BoxDecoration(
      color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration fill = BoxDecoration(
      color: Colors.red[900],
      borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _animation = Tween(begin: 0.0, end: 175.0).animate(_curve)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
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
          height: _animation.value,
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
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
