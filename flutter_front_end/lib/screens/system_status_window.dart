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
//import '../widgets/expandedPanel.dart';

// import '../widgets/Vector.dart';
//import '../widgets/systemContainer.dart';
import '../widgets/system_container_widget.dart';
import '../models/system_container_set.dart';

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

//ignore: must_be_immutable
class SystemStatusWindow extends StatefulWidget {
  SystemStatusWindow({Key? key}) : super(key: key);

  int numOfCols = 3;

  @override
  State<StatefulWidget> createState() {
    return _SystemStatusWindowState();
  }
}

class _SystemStatusWindowState extends State<SystemStatusWindow> {
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
    final containers = Provider.of<SystemContainerSet>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    int numOfCols;

    if (screenWidth < 718) {
      numOfCols = 1;
    } else if (screenWidth >= 718 && screenWidth < 1036) {
      numOfCols = 2;
    } else if (screenWidth >= 1036 && screenWidth < 1354) {
      numOfCols = 3;
    } else if (screenWidth >= 1354 && screenWidth < 1672) {
      numOfCols = 4;
    } else if (screenWidth >= 1672 && screenWidth < 1990) {
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
                  childAspectRatio: 1.75),
              itemBuilder: (_, i) => SystemContainerWidget(
                containerName: containers.items[i].id,
                creationDate: containers.items[i].creationDate,
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