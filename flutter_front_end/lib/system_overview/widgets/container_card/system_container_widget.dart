import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_front_end/components/dotted_decoration.dart';

import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/models/system_container_set.dart';
import 'package:flutter_front_end/system_overview/widgets/scenarios/scenario_widget.dart';

import 'package:provider/provider.dart';

import 'package:flutter_front_end/system_overview/models/system_status.dart';

import 'stat_table.dart';
import '../scenarios/scenario_status.dart';

//ignore: must_be_immutable
class SystemContainerWidget extends StatefulWidget {
  final String? containerName;
  final String? creationDate;
  SystemContainerWidget({this.containerName, this.creationDate});

  @override
  _SystemContainerWidgetState createState() => _SystemContainerWidgetState();
}

class _SystemContainerWidgetState extends State<SystemContainerWidget>
    with SingleTickerProviderStateMixin {
  final double containerHeight = 175.0;

  final double containerWidth = 335.0; // 225.0

  final double borderWidth = 3.0;

  final double borderRadius = 30.0;

  SystemStatus systemStatus = SystemStatus.dead;

  Color containerColor = Color.fromARGB(255, 0, 0, 139);

  double t = 0.0;
  final double fontSize = 36;

  StreamController<String> _refreshController = StreamController<String>();

  @override
  Widget build(BuildContext context) {
    // SystemContainerSet containers = Provider.of<SystemContainerSet>(context);
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);
    if (t < 1) {
      t += 0.1;
    } else {
      t = 1.0;
    }
    this.containerColor = status.darkModeEnabled
        ? Color.fromARGB(255, 0, 0, 139)
        : Color.fromARGB(255, 65, 105, 225);

    SystemContainer objectContainer =
        SystemContainerSet.findById(widget.containerName!);

    objectContainer.eventNotifier + UpdateScenarioText;

    this.systemStatus = objectContainer.containerStatus;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MouseRegion(
          onEnter: (PointerEnterEvent enterEvent) {},
          onExit: (PointerExitEvent exitEvent) {},
          child: GestureDetector(
            onTapUp: (TapUpDetails tapUpDetails) {
              setState(() {
                objectContainer.scenarioQueue?.add(Scenario(5));
              });
            },
            onDoubleTap: () {
              print("Bring up stat information");
            },
            child: Row(
              children: [
                Container(
                  decoration: ContainerBoxStyle(this.containerColor, this.borderRadius, this.borderWidth),
                  width: containerWidth,
                  height: containerHeight,
                  child: Row(
                    children: [
                      StaticElement(containerName: widget.containerName, creationDate: widget.creationDate, containerColor: containerColor, systemStatus: systemStatus),
                      Container(
                        decoration: DottedDecoration(
                          shape: Shape.box,
                          strokeWidth: 2,
                          borderRadius: BorderRadius.circular(10), //remove this to get plane rectange
                        ),
                        width: 120,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 25).withOpacity(0.5),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              width: 120,
                              height: containerHeight,
                              child: StreamBuilder(
                                stream: _refreshController.stream,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  return Center(
                                    child: Text(
                                      NoScenarioText(objectContainer), 
                                      textAlign: TextAlign.center, 
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  );
                                },
                              ),
                            ),
                            ScenarioStatus(objectContainer),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void UpdateScenarioText() {
    this._refreshController.add("");
  }

  String NoScenarioText(SystemContainer objectContainer) {
    if (objectContainer.scenarioQueue!.length == 0) {
      return "No Current Scenarios";
    }
    return "";
  }

  BoxDecoration ContainerBoxStyle(Color color, double radius, double borderWidth) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
      borderRadius:
          BorderRadius.all(Radius.circular(radius)),
      border: Border.all(
        width: borderWidth,
        color: color,
      ),
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 0, 0, 20).withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
    ]);
  }
}

class StaticElement extends StatelessWidget {
  StaticElement({
    Key? key,
    required this.containerName,
    required this.creationDate,
    required this.containerColor,
    required this.systemStatus,
  }) : super(key: key);

  final String? containerName;
  final String? creationDate;
  final Color? containerColor;
  final SystemStatus? systemStatus;

  Color unhealthyColor = Color.fromARGB(255, 255, 221, 74);
  Color deadColor = Color.fromARGB(255, 216, 0, 50);
  Color healthyColor = Color.fromARGB(255, 7, 218, 74);

  Tooltip statusIcon(SystemStatus ss) {
    if (ss == SystemStatus.healthy) {
      return Tooltip(
        message: 'Healthy',
        child: Icon(
          CupertinoIcons.wifi,
          color: this.healthyColor,
        ),
      );
    } else if (ss == SystemStatus.unhealthy) {
      return Tooltip(
        message: 'Unhealthy',
        child: Icon(
          CupertinoIcons.wifi_exclamationmark,
          color: this.unhealthyColor,
        ),
      );
    } else {
      return Tooltip(
        message: 'Out of service',
        child: Icon(
          CupertinoIcons.wifi_slash,
          color: this.deadColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 3,
                right: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: statusIcon(systemStatus!),
                    margin: EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Text(
                          containerName!,
                          style:
                              Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          creationDate!,
                          style:
                              Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => {print("Graph Me!")},
                    icon: Icon(CupertinoIcons.graph_square),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        StatTable(
          id: containerName,
        ),
      ],
    );
  }
}
