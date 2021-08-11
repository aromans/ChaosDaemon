import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:touchable/touchable.dart';

import 'Vector.dart';
import 'systemContainer.dart';

Paint orange() => Paint()..color = Colors.orange;
Paint black() => Paint()..color = Colors.black;
Paint red() => Paint()..color = Colors.red;
Paint green() => Paint()..color = Colors.green;

Paint AnalyzeStatus(String value) {
  switch (value) {
    case "up":
      return green();
    case "scenario":
      return orange();
    case "down":
      return red();
    default:
      return black();
  }
}

class systemStatusWindow extends StatefulWidget {
  systemStatusWindow({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _systemStatusWindowState();
  }
}

class _systemStatusWindowState extends State<systemStatusWindow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: CanvasTouchDetector(
              builder: (context) => CustomPaint(
                painter: OpenPainter(context, 100, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  late BuildContext context;
  late Vector size;
  late double height, width;
  late double half_height, half_width;

  late final double LEFT;
  late final double RIGHT;
  late final double MIDDLE;
  late final double SPACING;
  late final double PADDING;

  List<SystemContainer> containers = <SystemContainer>[];

  List<Map> existing_Containers = [
    {"name": "Solr", "status": "down"},
    {"name": "HA PROXY", "status": "up"},
    {"name": "HA PROXY", "status": "up"},
    {"name": "CORE SOA", "status": "scenario"},
    {"name": "CORE SOA", "status": "scenario"},
    {"name": "CORE SOA", "status": "scenario"},
    {"name": "LOG STASH", "status": "up"},
    {"name": "FILE BEAT", "status": "up"},
    {"name": "ELASTIC SEARCH", "status": "up"},
  ];
  // late Map names;

  OpenPainter(BuildContext context, double width, double height) {
    this.context = context;
    this.size = Vector(width, height);
    this.height = height;
    this.width = width;
    this.half_height = height * 0.5;
    this.half_width = width * 0.5;

    this.LEFT = 0;
    this.RIGHT = (MediaQuery.of(context).size.width * 0.5) - width;
    this.MIDDLE = (RIGHT * 0.5);

    this.SPACING = 100;
    this.PADDING = 10;

    AssignContainers();
  }

  void AssignContainers() {
    int counter = 0;
    int num = 0;

    // Add main container
    containers.add(new SystemContainer(
        black(), Vector(MIDDLE, -half_height), size, "Main"));

    for (int i = 0; i < existing_Containers.length; ++i) {
      Map curr = existing_Containers[i];

      Paint paint_pick = AnalyzeStatus(curr["status"]);

      Vector pos;

      if (counter >= 0 && counter < 3) {
        pos = new Vector(
            LEFT + PADDING, -(height * 2) - (num++ * (height + PADDING)));

        if (num == 3) {
          num = 0;
        }
      } else if (counter >= 3 && counter < 6) {
        pos =
            new Vector(LEFT + PADDING, (height) + (num++ * (height + PADDING)));

        if (num == 3) {
          num = 0;
        }
      } else if (counter >= 6 && counter <= 9) {
        pos = new Vector(
            RIGHT - PADDING, -(height * 2) - (num++ * (height + PADDING)));

        if (num == 3) {
          num = 0;
        }

        print(pos.x.toString() + " -- " + pos.y.toString());
      } else {
        pos = new Vector(
            RIGHT - PADDING, (height) + (num++ * (height + PADDING)));

        if (num == 3) {
          num = 0;
        }
      }

      containers.add(new SystemContainer(paint_pick, pos, size, curr["name"]));

      counter += 1;
    }
  }

  @override
  void paint(Canvas ogCanvas, Size size) {
    // var canvas = ogCanvas;
    var canvas = TouchyCanvas(context, ogCanvas);

    ParagraphBuilder pb = new ParagraphBuilder(ParagraphStyle(
        fontSize: 20,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr));

    for (int i = 0; i < containers.length; ++i) {
      containers[i].Draw(canvas, pb);
    }

    SystemContainer main = containers[0];
    Offset mainL = main.middleLeft;
    Offset mainR = main.middleRight;
    for (int i = 1; i < containers.length; ++i) {
      SystemContainer tempContainer = containers[i];

      if (tempContainer.position.dx < MIDDLE)
        canvas.drawLine(mainL, containers[i].middleRight, black());
      else
        canvas.drawLine(mainR, containers[i].middleLeft, black());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
