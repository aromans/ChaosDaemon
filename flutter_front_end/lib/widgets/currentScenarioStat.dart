import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_front_end/models/scenarioAnimController.dart';
import 'package:flutter_front_end/models/animations.dart';
import 'package:provider/provider.dart';

class currentScenarioStat extends StatefulWidget {
  currentScenarioStat({Key? key}) : super(key: key);

  late currentScenarioStatState state;

  @override
  State<StatefulWidget> createState() {
    state = currentScenarioStatState();
    return state;
  }
}

class currentScenarioStatState extends State<currentScenarioStat>
    with TickerProviderStateMixin {
  late ScenarioAnimController controller;
  late AnimationController _controller;
  late ScenarioAnimator _animator;

  Decoration outline = BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
  );

  Decoration fill = BoxDecoration(
    // color: Colors.red[900],
    color: Color.fromARGB(255, 184, 15, 10),
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
  );

  @override
  void initState() {
    _animator = ScenarioAnimator(
      controller: controller,
      animationController: AnimationController(
        duration: const Duration(
          seconds: 2,
        ),
        vsync: this,
      ),
    );

    _animator.idleScenarioAnimation();

    super.initState();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return FadeTransition(
      opacity: _fadeTransitionAnimation,
      child: SlideTransition(
        position: _slideTransitionAnimation,
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
                        decoration: outline,
                        width: 45,
                        height: 175,
                      ),
                    ),
                    Container(
                      decoration: fill,
                      width: 45,
                      height: _progressAnimation?.value,
                    ),
                  ],
                ),
              ),
              Align(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    child: Stack(
                      children: [
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
                        ),
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

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<ScenarioAnimController>(context);
    return AnimatedBuilder(builder: _buildAnimation, animation: _controller);
  }
}
