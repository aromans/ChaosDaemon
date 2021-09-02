import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/models/system_container_set.dart';
import 'package:flutter_front_end/system_overview/widgets/scenarios/scenario_widget.dart';

import 'package:provider/provider.dart';

import 'stat_table.dart';
import '../scenarios/scenario_status.dart';

//ignore: must_be_immutable
class SystemContainerWidget extends StatelessWidget {
  final String? containerName;
  final String? creationDate;
  SystemContainerWidget({this.containerName, this.creationDate});

  // default values
  final double containerHeight = 175.0;
  final double containerWidth = 225.0;
  final double borderWidth = 5.0;
  final double borderRadius = 30.0;

  Color containerColor = Color.fromARGB(255, 0, 0, 139);
  final double fontSize = 36;

  @override
  Widget build(BuildContext context) {
    SystemContainerSet containers = Provider.of<SystemContainerSet>(context);
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);

    this.containerColor =
        status.darkModeEnabled ? Colors.white : Color.fromARGB(255, 0, 0, 139);

    SystemContainer thisGuyHere = containers.findById(containerName!);

    if (containerName == "SOLR") {
      thisGuyHere.scenarioQueue?.add(Scenario());
      thisGuyHere.scenarioQueue?.add(Scenario());
      thisGuyHere.scenarioQueue?.add(Scenario());
    }

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ScenarioStatus(thisGuyHere),
        MouseRegion(
          onEnter: (PointerEnterEvent enterEvent) {},
          onExit: (PointerExitEvent exitEvent) {},
          child: GestureDetector(
            onTapUp: (TapUpDetails tapUpDetails) {
              // TODO: Add new scenario to queue
            },
            onDoubleTap: () {
              print("Bring up stat information");
            },
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => {print("Refresh Me!")},
                            icon: Icon(CupertinoIcons.arrow_clockwise),
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                Text(
                                  this.containerName!,
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                Text(
                                  this.creationDate!,
                                  style: Theme.of(context).textTheme.bodyText2,
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
                  StatTable(
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
