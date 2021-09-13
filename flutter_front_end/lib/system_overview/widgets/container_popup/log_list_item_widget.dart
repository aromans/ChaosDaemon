import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';

class LogListItem extends StatelessWidget {
  Log log;
  LogListItem({required this.log});

  // @override
  // Widget build(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Text>[
  //       Text(
  //         '< ${log.timeStamp.toString()} >',
  //         style: Theme.of(context).textTheme.bodyText1,
  //       ),
  //       Text(
  //         log.body,
  //         style: Theme.of(context).textTheme.bodyText1,
  //       ),
  //       Text(
  //         log.level.toString(),
  //         style: Theme.of(context).textTheme.headline2,
  //       )
  //     ],
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(1.0),
      elevation: 1.0,
      color: Color.fromARGB(255, 0, 0, 61),
      shadowColor: Colors.black,
      child: ListTile(
        hoverColor: Colors.black,
        leading: Icon(
          CupertinoIcons.info,
          color: Color.fromARGB(255, 88, 176, 156),
        ),
        title: Text(
          log.timeStamp.toString(),
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.grey.shade400,
              ),
        ),
        subtitle: Text(
          log.body,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(
          log.level.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
