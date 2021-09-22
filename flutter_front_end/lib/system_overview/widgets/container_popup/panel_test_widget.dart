import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/sliding_stack_module.dart';

class PanelTest extends StatelessWidget {
  PanelTest();

  Widget getScenarioIcon(String outcome) {
    switch (outcome) {
      case 'pass':
        return Icon(
          CupertinoIcons.check_mark_circled,
          color: Colors.blue,
          size: 48,
        );
      case 'heal':
        return Icon(
          CupertinoIcons.plus_circle,
          color: Colors.greenAccent.shade400,
          size: 48,
        );
      case 'fail':
        return Icon(
          CupertinoIcons.xmark_circle,
          color: Colors.redAccent.shade700,
          size: 48,
        );
      default:
        return Icon(CupertinoIcons.flame);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: ListView(
        physics: ScrollPhysics(),
        children: generateWidgets(20),
        scrollDirection: Axis.vertical,
      ),
    );
  }
}

List<Widget> generateWidgets(int count) {
  return List.generate(
    count,
    (index) => Container(
      height: 50,
      width: 50,
      color: randomColor(),
    ),
  );
}
