import 'dart:ui';
import 'package:flutter/material.dart';

import 'statItem.dart';

statItem generateItem(int index, List<Map> stats) {
  String key = stats[index].keys.elementAt(0);

  return statItem(key, stats[index][key]);
}

class statTable extends StatefulWidget {
  const statTable({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => stateTableState();
}

class stateTableState extends State<statTable> {
  List<Map> stats = [
    {"Memory": "25%"},
    {"Packets S/R": "456/87"},
    {"Packet Loss": "15%"},
    {"CPU": "1.2 GHZ"},
    {"Uptime": "3.2 hrs"}
  ];

  Iterable<Widget> get StatItems sync* {
    var statList = new List<statItem>.generate(
        stats.length, (index) => generateItem(index, stats));

    for (final statItem stat in statList) {
      yield stat;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: StatItems.toList(),
          ),
        ),
      ),
    );
  }
}
