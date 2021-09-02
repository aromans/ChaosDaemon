import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/widgets/scenarios/scenario_widget.dart';
import 'package:mutex/mutex.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class ScenarioQueue extends StatefulWidget {
  final SystemContainer container;
  ScenarioQueue(this.container, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScenarioQueueState();
}

class ScenarioQueueState extends State<ScenarioQueue> {
  ScenarioAnimController controller = ScenarioAnimController();

  List<Widget> InitializeVisualizations() {
    List<Widget> visualizationList = [];
    int count = 0;

    visualizationList.add(VerticalDivider(width: 3.0));

    while (widget.container.scenarioQueue!.length > 0 && count < 2) {
      visualizationList.add(ScenarioWidget(1, controller));
      visualizationList.add(VerticalDivider(width: 3.0));

      widget.container.scenarioQueue!.removeFirst();

      count++;
    }

    return visualizationList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: InitializeVisualizations(),
      // children: [
      //   VerticalDivider(width: 3.0),
      //   scenario_one,
      //   VerticalDivider(width: 2.0),
      //   scenario_two,
      // ],
    );
  }
}
