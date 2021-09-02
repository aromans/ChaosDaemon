import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animation/scenario_anim_controller.dart';
import '../../models/scenario_queue.dart';

class ScenarioStatus extends StatefulWidget {
  ScenarioStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScenarioStatusState();
}

class ScenarioStatusState extends State<ScenarioStatus> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ScenarioAnimController(), child: ScenarioQueue());
  }
}
