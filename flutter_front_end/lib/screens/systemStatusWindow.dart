import 'dart:ui';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/services.dart';
//import 'package:touchable/touchable.dart';

// import 'package:flutter_front_end/widgets/currentScenarioStat.dart';
// import 'package:flutter_front_end/widgets/nextScenarioStat.dart';
// import 'package:flutter_front_end/widgets/expandedPanelStatSystem.dart';
import '../widgets/expandedPanel.dart';

// import '../widgets/Vector.dart';
//import '../widgets/systemContainer.dart';
import '../widgets/systemContainerWidget.dart';
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

  int numOfCols = 3;

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

    double screenWidth = MediaQuery.of(context).size.width;
    int numOfCols;

    if (screenWidth < 475) {
      numOfCols = 1;
    } else if (screenWidth < 950) {
      numOfCols = 2;
    } else if (screenWidth < 1425) {
      numOfCols = 3;
    } else if (screenWidth < 1900) {
      numOfCols = 4;
    } else if (screenWidth < 2375) {
      numOfCols = 5;
    } else {
      numOfCols = 6;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numOfCols,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 3 / 2),
              itemBuilder: (_, i) => SystemContainerWidget(
                containerName: containers.items[i].id,
              ),
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
