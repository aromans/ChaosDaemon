import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/system_container_set.dart';
import 'stat_table_item.dart';

// StatItem generateItem(int index, List<Map> stats) {
//   String key = stats[index].keys.elementAt(0);

//   return StatItem(key, stats[index][key]);
// }
//ignore: must_be_immutable
class StatTable extends StatefulWidget {
  String? id;
  StatTable({this.id, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateTableState();
}

class StateTableState extends State<StatTable> {
  @override
  Widget build(BuildContext context) {
    // SystemContainerSet containers = Provider.of<SystemContainerSet>(context);
    SystemContainer container = SystemContainerSet.findById(widget.id!);
    var f = NumberFormat("000", "en_US");
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
                header: 'Status',
                body: '${container.statusToString()}',
                trailer: '',
              ),
              StatTableItem(
                header: 'Uptime',
                body: '${container.uptime!.toStringAsFixed(2)}',
                trailer: 'hrs',
              ),
              StatTableItem(
                header: 'Packets S/R',
                body:
                    '${NumberFormat.compact().format(container.packetsTransmitted!)}/${NumberFormat.compact().format(container.packetsReceived!)}',
                trailer: '',
              ),
              StatTableItem(
                header: 'CPU',
                body: '${container.cpuUtil!.toStringAsFixed(2)}',
                trailer: '%',
              )
            ],
          ),
        ),
      ),
    );
  }
}
