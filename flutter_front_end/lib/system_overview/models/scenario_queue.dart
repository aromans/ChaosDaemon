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
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> the_children = [];
    the_children.add(VerticalDivider(width: 3.0));

    // final Stream<bool> myStream = controller.stream;
    // final stuff = myStream.listen((event) { print("MUTEX : " +  event.toString()); });
    // stuff.onData((data) {print("Data : " + data.toString());});

    final Future<String> _calculation = Future<String>.delayed(
        const Duration(seconds: 2),
        () => 'Data Loaded',
    );

    return 
      FutureBuilder(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

          if (widget.container.scenarioQueue!.length > 0 && counter < 2) {

            the_children.add(ScenarioWidget(
              widget.container.scenarioQueue!.removeFirst(), 
              controller
              ),
            );

            the_children.add(VerticalDivider(width: 3.0));

            counter++;
          }

          return Container(
            width: 100,
            child: Stack(alignment: Alignment.centerLeft, children: the_children,),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: the_children,
            // ),
          );
        },
    );
  }
}
