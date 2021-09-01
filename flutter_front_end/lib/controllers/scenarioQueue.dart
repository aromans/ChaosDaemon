import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/models/scenarioAnimController.dart';
import 'package:flutter_front_end/widgets/currentScenarioStat.dart';
import 'package:flutter_front_end/widgets/nextScenarioStat.dart';
import 'package:provider/provider.dart';

class scenarioQueue extends StatefulWidget {
  scenarioQueue({Key? key}) : super(key: key);

  Queue<Scenario> queue = Queue();

  @override
  State<StatefulWidget> createState() => scenarioQueueState();
}

class scenarioQueueState extends State<scenarioQueue> {

  late ScenarioAnimController controller;

  currentScenarioStat activeScenario = currentScenarioStat();
  nextScenarioStat nextScenario = nextScenarioStat();

  void TickAnimations() async {
    if (!activeScenario.isInitialized) return;

    if (widget.queue.length > 0) {

      // If current visualization doesn't exit
      if (!controller.hasNextScenario) {
        // Load the next queued Scenario Visualization 
        await nextScenario.state.newArrivalAnimation();
      }

      // If current scenario is still active
      if (controller.hasActiveScenario) {
        if (!controller.activeScenarioLoading) {
          await activeScenario.state.finishedScenarioAnimation();
        } else {
          return;
        }
      } 

      // Transition next scenario visualization 
      // Wait until next scenario transition is done
      await nextScenario.state.transitionAnimation();


      // Enable "queue current scenario" transition
      await activeScenario.state.activatedScenarionAnimation();
      // Exit "next scenario" transition
      await nextScenario.state.exitAnimation();

      // Set activate scenario visualization loading bar
      activeScenario.state.progressBarAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {

    controller = Provider.of<scenarioAnimController>(context);

    Scenario x = Scenario();

    widget.queue.add(x);

    TickAnimations();

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VerticalDivider(width: 3.0),
          activeScenario,
          VerticalDivider(width: 2.0),
          nextScenario,
        ],
    );
  }
}