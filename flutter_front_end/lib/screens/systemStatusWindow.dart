import 'dart:ui';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/services.dart';
//import 'package:touchable/touchable.dart';

// import 'package:flutter_front_end/widgets/currentScenarioStat.dart';
// import 'package:flutter_front_end/widgets/nextScenarioStat.dart';
// import 'package:flutter_front_end/widgets/expandedPanelStatSystem.dart';
import '../widgets/expandedPanel.dart';

// import '../widgets/Vector.dart';
//import '../widgets/systemContainer.dart';
import '../widgets/systemContainer2.dart';
import '../models/system_containers.dart';

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

// String SelectContainer(Offset screenPos) {
//   for (int i = 0; i < containers.length; i++) {
//     if (containers[i].Selected(screenPos)) {
//       return containers[i].label;
//     }
//   }
//   return "";
// }

// void hover(Offset pointerPos) {
//   SystemContainer? container;
//   for (int i = 0; i < containers.length; i++) {
//     if (containers[i].Selected(pointerPos)) {
//       container = containers[i];
//     }
//   }
// }

class systemStatusWindow extends StatefulWidget {
  systemStatusWindow({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _systemStatusWindowState();
  }
}

class _systemStatusWindowState extends State<systemStatusWindow> {
  // late List<SystemContainer2> widgetList;

  // int numOfWidgets = 30;

  // Map<String, Widget> expandedPanelWidgetMap = new Map<String, Widget>();

  // @override
  // void initState() {
  //   expandedPanelStatSystem mainEPStats =
  //       new expandedPanelStatSystem(Colors.black);
  //   expandedPanelStatSystem mainEPStats2 =
  //       new expandedPanelStatSystem(Colors.white);
  //   expandedPanelStatSystem mainEPStats3 =
  //       new expandedPanelStatSystem(Colors.green);

  //   expandedPanelWidgetMap['System'] = mainEPStats;
  //   expandedPanelWidgetMap['System2'] = mainEPStats2;
  //   expandedPanelWidgetMap['System3'] = mainEPStats3;
  // }

  @override
  Widget build(BuildContext context) {
    final containers = Provider.of<SystemContainers>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 3 / 2),
              itemBuilder: (_, i) => SystemContainer2(containers.items[i]),
              itemCount: containers.itemCount,
              padding: EdgeInsets.all(25),
            ),
          ),
          // Divider(
          //   height: 25.0,
          //   thickness: 5,
          //   color: Colors.grey.shade900,
          // ),
          // expandedPanel(this.expandedPanelWidgetMap),
        ],
      ),
    );
  }
}
