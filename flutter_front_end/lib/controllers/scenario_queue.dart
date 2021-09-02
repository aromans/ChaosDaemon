import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/models/scenario_anim_controller.dart';
import 'package:flutter_front_end/widgets/current_scenario_stat.dart';
import 'package:flutter_front_end/widgets/next_scenario_stat.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class ScenarioQueue extends StatefulWidget {
  ScenarioQueue({Key? key}) : super(key: key);

  Queue<Scenario> queue = Queue();

  @override
  State<StatefulWidget> createState() => ScenarioQueueState();
}

class ScenarioQueueState extends State<ScenarioQueue> {

  late ScenarioAnimController controller;

  CurrentScenarioStat activeScenario = CurrentScenarioStat();
  NextScenarioStat nextScenario = NextScenarioStat();

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

    controller = Provider.of<ScenarioAnimController>(context);

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