import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/scenario.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/widgets/scenarios/scenario_widget.dart';
import 'package:mutex/mutex.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

//ignore: must_be_immutable
class ScenarioQueue extends StatefulWidget {
  final SystemContainer container;
  ScenarioQueue(this.container, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScenarioQueueState();
}

class ScenarioQueueState extends State<ScenarioQueue> {

  ScenarioAnimController controller = ScenarioAnimController();
  List<Widget> the_children = [];
  int counter = 0;

  StreamController<String> _refreshController = StreamController<String>();

  void incrementCounter() {
    if (widget.container.scenarioQueue!.length > 0 && counter < 2) {
      the_children.add(ScenarioWidget(
        widget.container.scenarioQueue!.removeFirst(), 
        controller
        ),
      );

      the_children.add(VerticalDivider(width: 3.0, color: Color.fromARGB(0, 0, 0, 0),));

      _refreshController.add("");
      counter++;
    }
  }

  void decrementCounter() {
    if (counter > 0)
      counter -= 1;
  }

  Widget extraText() {
    int queueLength = widget.container.scenarioQueue!.length;
    if (queueLength > 0) {
      return RotatedBox(quarterTurns: 3, child: Text("+ " + queueLength.toString(), style: Theme.of(context).textTheme.bodyText2,));
    } 
    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    
    // the_children.add(VerticalDivider(width: 3.0));

    controller.waitingIsDone + decrementCounter;
    controller.addToQueue + incrementCounter;

    controller.addToQueue();

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
                child: extraText(),
              ),
            ],
          );
        },
    );
  }
}
