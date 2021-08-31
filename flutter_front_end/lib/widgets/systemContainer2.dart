import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'statTable.dart';
import 'scenarioStatus.dart';

class SystemContainer2 extends StatefulWidget {
  SystemContainer2({Key? key}) : super(key: key);

  // default values
  final double containerHeight = 175.0;
  final double containerWidth = 175.0;
  final double borderWidth = 5.0;
  final double borderRadius = 8.0;

  final Color textColor = Colors.white;
  final Color containerColor = Colors.blueAccent.shade400;
  final double fontSize = 36;

  @override
  State<StatefulWidget> createState() {
    return SystemContainer2State();
  }
}

class SystemContainer2State extends State<SystemContainer2> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        scenarioStatus(),
        MouseRegion(
          onEnter: (PointerEnterEvent enterEvent) {},
          onExit: (PointerExitEvent exitEvent) {},
          child: GestureDetector(
            onTapUp: (TapUpDetails tapUpDetails) {},
            child: Container(
              decoration: BoxDecoration(
                color: widget.containerColor,
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius)),
                border: Border.all(
                  width: widget.borderWidth,
                  color: widget.containerColor,
                ),
              ),
              width: widget.containerWidth,
              height: widget.containerHeight,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'SOLR 2',
                        style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF-Pro-Rounded',
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  statTable(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
