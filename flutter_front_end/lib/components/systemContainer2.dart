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
  double containerHeight = 175.0;
  double containerWidth = 175.0;
  double borderWidth = 5.0;
  double borderRadius = 8.0;

  Color textColor = Colors.white;
  double fontSize = 18;
  Color containerColor = Colors.blueAccent.shade400;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          scenarioStatus(),
          MouseRegion(
            onEnter: (PointerEnterEvent enterEvent) {
              print('hey!');
            },
            onExit: (PointerExitEvent exitEvent) {
              print('bye!');
            },
            child: GestureDetector(
              onTapUp: (TapUpDetails tapUpDetails) {
                print('tap tap tap');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: this.containerColor,
                    shape: BoxShape.rectangle,
                    borderRadius:
                        BorderRadius.all(Radius.circular(this.borderRadius)),
                    border: Border.all(
                        width: this.borderWidth, color: this.containerColor)),
                width: this.containerWidth,
                height: this.containerHeight,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          'SOLR 2',
                          style: TextStyle(
                              color: this.textColor,
                              fontSize: this.fontSize,
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
        ]);
  }
}
