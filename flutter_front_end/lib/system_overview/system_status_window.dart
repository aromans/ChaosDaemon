import 'dart:ui';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/services.dart';
//import 'package:touchable/touchable.dart';

// import 'package:flutter_front_end/widgets/currentScenarioStat.dart';
// import 'package:flutter_front_end/widgets/nextScenarioStat.dart';
// import 'package:flutter_front_end/widgets/expandedPanelStatSystem.dart';
//import '../widgets/expandedPanel.dart';

// import '../widgets/Vector.dart';
//import '../widgets/systemContainer.dart';
import 'widgets/container_card/system_container_widget.dart';
import 'models/system_container_set.dart';

// Paint AnalyzeStatus(String value) {
//   switch (value) {
//     case "up":
//       return green();
//     case "scenario":
//       return orange();
//     case "down":
//       return red();
//     default:
//       return black();
//   }
// }

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

  @override
  Widget build(BuildContext context) {
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    int numOfCols = 3;

    // if (screenWidth < 718) {
    //   numOfCols = 1;
    // } else if (screenWidth >= 718 && screenWidth < 1036) {
    //   numOfCols = 2;
    // } else if (screenWidth >= 1036 && screenWidth < 1354) {
    //   numOfCols = 3;
    // } else if (screenWidth >= 1354 && screenWidth < 1672) {
    //   numOfCols = 4;
    // } else if (screenWidth >= 1672 && screenWidth < 1990) {
    //   numOfCols = 5;
    // } else {
    //   numOfCols = 6;
    // }

    return Scaffold(
      backgroundColor: status.darkModeEnabled ? Color.fromARGB(255, 0, 0, 61) : Color.fromARGB(255, 238, 240, 235),
      body: Container(
        alignment: Alignment.center,
        child: ContainerGrid(numOfCols: numOfCols),
      ),
    );
  }
}

class ContainerGrid extends StatelessWidget {
  const ContainerGrid({
    Key? key,
    required this.numOfCols,
  }) : super(key: key);

  final int numOfCols;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numOfCols,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1.5),
        itemBuilder: (_, i) => SystemContainerWidget(
          containerName: SystemContainerSet.items[i].id,
          creationDate: SystemContainerSet.items[i].creationDate,
        ),
        itemCount: SystemContainerSet.itemCount,
      );
  }
}
