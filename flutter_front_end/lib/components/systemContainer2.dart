import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'Vector.dart';

import 'statTable.dart';
import 'scenarioStatus.dart';

class SystemContainer2 extends StatefulWidget {
  const SystemContainer2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SystemContainer2State();
  }
}

class SystemContainer2State extends State<SystemContainer2> {
  Color backgroundColor = Colors.blueAccent.shade400;
  Color borderColor = Colors.blueAccent.shade400;
  Color currentBorderColor = Colors.red.shade900;
  Color currentColor = Colors.red.shade900;
  Color nextBorderColor = Colors.yellow.shade800;
  Color nextColor = Colors.yellow.shade800;
  int numberOfClicks = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      MouseRegion(
        onEnter: (PointerEnterEvent enterEvent) {
          print('hey!');
        },
        onExit: (PointerExitEvent exitEvent) {
          print('bye!');
        },
        child: GestureDetector(
          onTapUp: (TapUpDetails tapUpDetails) {
            this.numberOfClicks++;
            if (this.numberOfClicks % 2 == 0) {
              this.borderColor = Colors.blue;
            } else {
              this.borderColor = Colors.green.shade700;
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(width: 5.0, color: Colors.blue)),
            width: 175.0,
            height: 175.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'SOLR 2',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                statTable()
              ],
            ),
          ),
        ),
      ),
      scenarioStatus(),
    ]);
  }
}
