import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/models/system_container.dart';
import 'package:provider/provider.dart';

import '../models/system_container_set.dart';
import 'stat_table_item.dart';
import 'stat_item.dart';

StatItem generateItem(int index, List<Map> stats) {
  String key = stats[index].keys.elementAt(0);

  return StatItem(key, stats[index][key]);
}
//ignore: must_be_immutable
class statTable extends StatefulWidget {
  String? id;
  statTable({this.id, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateTableState();
}

class StateTableState extends State<statTable> {
  // List<Map> stats = [
  //   {"Memory": "25%"},
  //   {"Packets S/R": "456/87"},
  //   {"Packet Loss": "15%"},
  //   {"CPU": "1.2 GHZ"},
  //   {"Uptime": "3.2 hrs"}
  // ];

  // Iterable<Widget> get StatItems sync* {
  //   var statList = new List<statItem>.generate(
  //       stats.length, (index) => generateItem(index, stats));

  //   for (final statItem stat in statList) {
  //     yield stat;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemContainerSet containers = Provider.of<SystemContainerSet>(context);
    SystemContainer container = containers.findById(widget.id!);
    return Container(
      height: 100,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatTableItem(
                header: 'Uptime',
                body: '${container.uptime!.toStringAsFixed(2)}',
                trailer: 'hrs',
              ),
              StatTableItem(
                header: 'Packets S/R',
                body:
                    '${container.packetsTransmitted!.toStringAsFixed(2)}/${container.packetsReceived!.toStringAsFixed(2)}',
                trailer: '',
              ),
              StatTableItem(
                header: 'CPU',
                body: '${container.cpuUtil!.toStringAsFixed(2)}',
                trailer: 'ghz',
              )
            ],
          ),
        ),
      ),
    );
  }
}
