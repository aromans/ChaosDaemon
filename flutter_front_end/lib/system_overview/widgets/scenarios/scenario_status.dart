import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:provider/provider.dart';

import '../../animation/scenario_anim_controller.dart';
import '../../models/scenario_queue.dart';

class ScenarioStatus extends StatefulWidget {
  final SystemContainer container;
  ScenarioStatus(this.container, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScenarioStatusState();
}

class ScenarioStatusState extends State<ScenarioStatus> {
  @override
  Widget build(BuildContext context) {
    return ScenarioQueue(widget.container);
  }
}
