import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_list_item_widget.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_set.dart';

class LogWidget extends StatelessWidget {
  List<Log> logList = LogSet.generateData();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   padding: EdgeInsets.only(
        //     left: 85,
        //     right: 25,
        //     top: 10,
        //   ),
        //   height: MediaQuery.of(context).size.height * 0.1,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text('Time'),
        //       Text('Message'),
        //       Text('Level'),
        //     ],
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.only(
        //     left: 10,
        //     right: 10,
        //   ),
        //   height: 5,
        //   color: Colors.white,
        // ),
        Container(
          height: MediaQuery.of(context).size.height * 0.95,
          alignment: Alignment.topLeft,
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: 1.0,
              right: 1.0,
            ),
            itemCount: 20,
            itemBuilder: (ctx, i) => LogListItem(
              log: logList[i],
            ),
          ),
        ),
      ],
    );
  }
}
