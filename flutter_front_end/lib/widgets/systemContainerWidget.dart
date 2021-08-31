import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/system_container.dart';
import 'package:provider/provider.dart';

import 'statTable.dart';
import 'scenarioStatus.dart';

class SystemContainerWidget extends StatelessWidget {
  final String? containerName;
  SystemContainerWidget({this.containerName});

  // default values
  final double containerHeight = 175.0;
  final double containerWidth = 225.0;
  final double borderWidth = 5.0;
  final double borderRadius = 30.0;

  final Color textColor = Colors.white;
  final Color containerColor = Color.fromARGB(255, 0, 0, 139);
  final double fontSize = 36;

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
                color: this.containerColor,
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(this.borderRadius)),
                border: Border.all(
                  width: this.borderWidth,
                  color: this.containerColor,
                ),
              ),
              width: this.containerWidth,
              height: this.containerHeight,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        this.containerName!,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  statTable(
                    id: this.containerName,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
