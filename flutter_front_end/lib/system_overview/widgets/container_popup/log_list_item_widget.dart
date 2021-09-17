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
    return Row(
      children: [
        Container(
          color: Colors.blue.shade900,
          child: Text(log.timeStamp),
        ),
        Container(
          color: Colors.blue.shade800,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: log.body,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
  }
}
