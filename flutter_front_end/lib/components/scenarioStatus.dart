import 'dart:ui';
import 'package:flutter/material.dart';

class scenarioStatus extends StatefulWidget {
  scenarioStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => scenarioStatusState();
}

class scenarioStatusState extends State<scenarioStatus>
    with SingleTickerProviderStateMixin {
  Color backgroundColor = Colors.blueAccent.shade400;
  Color borderColor = Colors.blueAccent.shade400;
  Color currentBorderColor = Colors.red.shade900;
  Color currentColor = Colors.red.shade900;
  Color nextBorderColor = Colors.yellow.shade800;
  Color nextColor = Colors.yellow.shade800;

  late final AnimationController _controller;
  late final Animation _animation;
  late final Animation<double> _curve;

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

  Decoration outline = BoxDecoration(
      color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration fill = BoxDecoration(
      color: Colors.red[900],
      borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration nextOutline = BoxDecoration(
      color: Colors.yellow[700],
      borderRadius: BorderRadius.all(Radius.circular(8.0)));

  Decoration nextFill = BoxDecoration(
      color: Colors.yellow[800],
      borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VerticalDivider(width: 1.0),
        Stack(alignment: Alignment.topCenter, children: [
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
        ]),
        VerticalDivider(width: 2.0),
        Stack(alignment: Alignment.topCenter, children: [
          Align(
              child: Stack(alignment: Alignment.bottomCenter, children: [
            MouseRegion(
              child: Container(
                decoration: nextOutline,
                width: 45,
                height: 175,
              ),
            ),
            Container(
              decoration: nextFill,
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
        ]),
        // MouseRegion(
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.rectangle,
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //     ),
        //     margin: const EdgeInsets.all(1.0),
        //     width: 45,
        //     height: 175,
        //     child: Stack(alignment: Alignment.bottomCenter, children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           color: this.currentColor,
        //           shape: BoxShape.rectangle,
        //         ),
        //         width: 45,
        //         height: _animation.value,
        //       ),
        //       RotatedBox(
        //           quarterTurns: 3,
        //           child: Container(
        //               alignment: Alignment.center,
        //               child: Text(
        //                 'Current Scenario',
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.normal),
        //               ))),
        //     ]),
        //   ),
        // ),
        // MouseRegion(
        //   child: Container(
        //       decoration: BoxDecoration(
        //           color: this.nextColor,
        //           shape: BoxShape.rectangle,
        //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //           border: Border.all(width: 5.0, color: this.nextBorderColor)),
        //       margin: const EdgeInsets.all(1.0),
        //       width: 45,
        //       height: 175.0,
        //       child: RotatedBox(
        //           quarterTurns: 3,
        //           child: Container(
        //               alignment: Alignment.center,
        //               child: Text(
        //                 'Next Scenario',
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.normal),
        //               )))),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
