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

var load = '''
import go from 'gojs';

var \$ = go.GraphObject.make;

var myDiagram =
  \$(go.Diagram, "myDiagramDiv",
    { // enable Ctrl-Z to undo and Ctrl-Y to redo
      "undoManager.isEnabled": true
    });

myDiagram.model = new go.Model(
  [ // for each object in this Array, the Diagram creates a Node to represent it
    { key: "Alpha" },
    { key: "Beta" },
    { key: "Gamma" }
  ]);
''';

// var load = ''''
//     <textarea id="mySavedModel" style="width:100%;height:400px">
// { "class": "go.TreeModel",
//   "nodeDataArray": [
// {"key":0, "text":"Main", "loc":"0 0"},
// {"key":1, "parent":0, "text":"Core SOA", "brush":"yellow", "dir":"right", "loc":"75 -50"},
// {"key":2, "parent":0, "text":"Core SOA", "brush":"yellow", "dir":"right", "loc":"75 -30"},
// {"key":3, "parent":0, "text":"Core SOA", "brush":"yellow", "dir":"right", "loc":"75 -10"},
// {"key":4, "parent":0, "text":"Solr", "brush":"red", "dir":"right", "loc":"75 50"},
// {"key":5, "parent":0, "text":"HA Proxy", "brush":"green", "dir":"left", "loc":"-50 -50"},
// {"key":6, "parent":0, "text":"HA Proxy", "brush":"green", "dir":"left", "loc":"-50 -30"},
// {"key":7, "parent":0, "text":"HA Proxy", "brush":"green", "dir":"left", "loc":"-50 -10"},
// {"key":8, "parent":0, "text":"Log Stash", "brush":"green", "dir":"left", "loc":"-50 50"},
// {"key":9, "parent":0, "text":"Log Stash", "brush":"green", "dir":"left", "loc":"-50 70"},
// {"key":10, "parent":0, "text":"Log Stash", "brush":"green", "dir":"left", "loc":"-50 90"}
// ]
// }
//     </textarea>
//   ''';

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
    double xPos, yPos;

    int counter = 0;

    // Add main container
    containers.add(new SystemContainer(
        black(), Vector(MIDDLE, -half_height), size, "Main"));

    for (int i = 0; i < existing_Containers.length; ++i) {
      Map curr = existing_Containers[i];

      // if (names.containsKey((curr['name']))) {
      // } else {
      //   names[curr["name"]] = true;
      // }

      Paint paint_pick = AnalyzeStatus(curr["status"]);

      Vector pos;

      if (counter > 0 && counter <= 3) {
        pos = new Vector(
            LEFT + PADDING, (0 + SPACING) + (i * (height + PADDING)));
      } else {
        pos = new Vector(
            RIGHT - PADDING, (0 + SPACING) + (i * (height + PADDING)));
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

    // SystemContainer box_1 = new SystemContainer(
    //     black(), new Vector(MIDDLE, -half_height), this.size, "Main");

    // SystemContainer box_2 = new SystemContainer(
    //     red(), new Vector(10, -half_height + 100), this.size, "Solr");

    // SystemContainer box_3 = new SystemContainer(
    //     orange(),
    //     new Vector(
    //         (MediaQuery.of(context).size.width * 0.415), -half_height + 100),
    //     this.size,
    //     "CORE SOA");

    // box_1.Draw(canvas, pb);
    // box_2.Draw(canvas, pb);
    // box_3.Draw(canvas, pb);

    // canvas.drawRect(
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //             (-half_height + 100) + (1 * (height + 10))) &
    //         Size(width, height),
    //     orange());

    // canvas.drawRect(
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //             (-half_height + 100) + (2 * (height + 10))) &
    //         Size(width, height),
    //     orange());

    // canvas.drawRect(
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //             (-half_height - 100)) &
    //         Size(width, height),
    //     green());

    // canvas.drawLine(
    //     Offset((MediaQuery.of(context).size.width * 0.25) - half_width, 0),
    //     Offset(width + 10, 0 + 100),
    //     black());

    // canvas.drawLine(
    //     Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
    //     Offset((MediaQuery.of(context).size.width * 0.415), 0 + 100),
    //     black());

    // canvas.drawLine(
    //     Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //         0 + 100 + (1 * (height + 10))),
    //     black());

    // canvas.drawLine(
    //     Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //         0 + 100 + (2 * (height + 10))),
    //     black());

    // canvas.drawLine(
    //     Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
    //     Offset((MediaQuery.of(context).size.width * 0.415), 0 + -100),
    //     black());

    // Paragraph p;

    // // pb.addText("Solr");
    // // Paragraph p = pb.build();
    // // p.layout(ParagraphConstraints(width: width));

    // // canvas.drawParagraph(p, Offset(10, (-half_height * 0.5) + 100));

    // pb.addText("CORE SOA");
    // p = pb.build();
    // p.layout(ParagraphConstraints(width: width));

    // canvas.drawParagraph(
    //     p,
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //         ((-half_height * 0.5) + 100) + (1 * (height + 10))));

    // pb.addText("CORE SOA");
    // p = pb.build();
    // p.layout(ParagraphConstraints(width: width));

    // canvas.drawParagraph(
    //     p,
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //         ((-half_height * 0.5) + 100) + (2 * (height + 10))));

    // pb.addText("HA PROXY");
    // p = pb.build();
    // p.layout(ParagraphConstraints(width: width));

    // canvas.drawParagraph(
    //     p,
    //     Offset((MediaQuery.of(context).size.width * 0.415),
    //         ((-half_height * 0.5) - 100)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
