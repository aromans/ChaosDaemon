import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/components/currentScenarioStat.dart';
import 'package:flutter_front_end/components/nextScenarioStat.dart';

class scenarioStatus extends StatefulWidget {
  scenarioStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => scenarioStatusState();
}

class scenarioStatusState extends State<scenarioStatus>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VerticalDivider(width: 1.0),
        currentScenarioStat(),
        VerticalDivider(width: 2.0),
        nextScenarioStat(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
