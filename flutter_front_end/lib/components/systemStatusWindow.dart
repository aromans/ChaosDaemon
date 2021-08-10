import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:touchable/touchable.dart';

import 'Vector.dart';
import 'systemContainer.dart';

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
  late double width, height;
  late double half_height, half_width;

  OpenPainter(BuildContext context, double width, double height) {
    this.context = context;
    this.width = width;
    this.height = height;
    this.half_height = height * 0.5;
    this.half_width = width * 0.5;
  }

  @override
  void paint(Canvas ogCanvas, Size size) {
    // var canvas = ogCanvas;
    var canvas = TouchyCanvas(context, ogCanvas);

    var paint1 = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    var paint2 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    var paint3 = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    var paint4 = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    ParagraphBuilder pb = new ParagraphBuilder(ParagraphStyle(
        fontSize: 20,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr));

    SystemContainer box_1 = new SystemContainer(
        paint3,
        new Vector((MediaQuery.of(context).size.width * 0.25) - half_width,
            -half_height),
        new Vector(width, height),
        "Main");

    SystemContainer box_2 = new SystemContainer(paint2,
        new Vector(10, -half_height + 100), new Vector(width, height), "Solr");

    SystemContainer box_3 = new SystemContainer(
        paint1,
        new Vector(
            (MediaQuery.of(context).size.width * 0.415), -half_height + 100),
        new Vector(width, height),
        "CORE SOA");

    // box_1.Draw(canvas, pb);
    // box_2.Draw(canvas, pb);
    // box_3.Draw(canvas, pb);

    canvas.drawLine(box_1.position, box_2.position, paint2);

    canvas.drawRect(
        Offset((MediaQuery.of(context).size.width * 0.415),
                (-half_height + 100) + (1 * (height + 10))) &
            Size(width, height),
        paint1);

    canvas.drawRect(
        Offset((MediaQuery.of(context).size.width * 0.415),
                (-half_height + 100) + (2 * (height + 10))) &
            Size(width, height),
        paint1);

    canvas.drawRect(
        Offset((MediaQuery.of(context).size.width * 0.415),
                (-half_height - 100)) &
            Size(width, height),
        paint4);

    canvas.drawLine(
        Offset((MediaQuery.of(context).size.width * 0.25) - half_width, 0),
        Offset(width + 10, 0 + 100),
        paint3);

    canvas.drawLine(
        Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
        Offset((MediaQuery.of(context).size.width * 0.415), 0 + 100),
        paint4);

    canvas.drawLine(
        Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
        Offset((MediaQuery.of(context).size.width * 0.415),
            0 + 100 + (1 * (height + 10))),
        paint3);

    canvas.drawLine(
        Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
        Offset((MediaQuery.of(context).size.width * 0.415),
            0 + 100 + (2 * (height + 10))),
        paint3);

    canvas.drawLine(
        Offset((MediaQuery.of(context).size.width * 0.25) + half_width, 0),
        Offset((MediaQuery.of(context).size.width * 0.415), 0 + -100),
        paint3);

    Paragraph p;

    // pb.addText("Solr");
    // Paragraph p = pb.build();
    // p.layout(ParagraphConstraints(width: width));

    // canvas.drawParagraph(p, Offset(10, (-half_height * 0.5) + 100));

    pb.addText("CORE SOA");
    p = pb.build();
    p.layout(ParagraphConstraints(width: width));

    canvas.drawParagraph(
        p,
        Offset((MediaQuery.of(context).size.width * 0.415),
            ((-half_height * 0.5) + 100) + (1 * (height + 10))));

    pb.addText("CORE SOA");
    p = pb.build();
    p.layout(ParagraphConstraints(width: width));

    canvas.drawParagraph(
        p,
        Offset((MediaQuery.of(context).size.width * 0.415),
            ((-half_height * 0.5) + 100) + (2 * (height + 10))));

    pb.addText("HA PROXY");
    p = pb.build();
    p.layout(ParagraphConstraints(width: width));

    canvas.drawParagraph(
        p,
        Offset((MediaQuery.of(context).size.width * 0.415),
            ((-half_height * 0.5) - 100)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
