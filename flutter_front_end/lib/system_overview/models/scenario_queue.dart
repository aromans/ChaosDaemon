import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/widgets/scenarios/scenario_widget.dart';
import 'package:mutex/mutex.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

// Cool Black Color: Color.fromARGB(255, 25, 23, 22)

//ignore: must_be_immutable
class ScenarioQueue extends StatefulWidget {
  final SystemContainer container;
  ScenarioQueue(this.container, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScenarioQueueState();
}

class ScenarioQueueState extends State<ScenarioQueue> {

  late ScenarioAnimController controller;
  List<Widget> the_children = [];

  StreamController<String> _refreshController = StreamController<String>();

  @override
  void initState() {
    controller = ScenarioAnimController();
    widget.container.scenarioQueue! + controller.addToQueue;
    super.initState();
  }

  void incrementCounter() {
    if (widget.container.scenarioQueue!.length > 0 && widget.container.scenarioCounter < 2) {
      the_children.add(ScenarioWidget(
        widget.container.scenarioQueue!.removeFirst(), 
        controller
        ),
      );

      the_children.add(VerticalDivider(width: 3.0, color: Color.fromARGB(0, 0, 0, 0),));

      _refreshController.add("");
      widget.container.scenarioCounter++;
    }
  }

  void decrementCounter() {
    if (widget.container.scenarioCounter > 0)
      widget.container.scenarioCounter -= 1;

    if (widget.container.scenarioCounter <= 0)
      widget.container.eventNotifier();
  }

  Widget extraText(DarkModeStatus status) {
    int queueLength = widget.container.scenarioQueue!.length;
    TextStyle extraStyle = Theme.of(context).textTheme.bodyText2!;

    if (queueLength > 0) {
      return RotatedBox(
        quarterTurns: 3, 
        child: Text(
          "+ " + queueLength.toString(), 
          style: TextStyle(color: extraStyle.color,
          fontSize: extraStyle.fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: extraStyle.fontFamily),
        ),
      );
    } 
    return Text("");
  }

  @override
  Widget build(BuildContext context) {

    DarkModeStatus status = Provider.of<DarkModeStatus>(context);
    
    controller.waitingIsDone + decrementCounter;
    controller.addToQueue + incrementCounter;

    // controller.addToQueue();

    return 
      StreamBuilder(
        stream: _refreshController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            children: [
              Container(
                width: 100,
                child: Stack(alignment: Alignment.centerLeft, children: the_children,),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: extraText(status),
              ),
            ],
          );
        },
    );
  }
}
