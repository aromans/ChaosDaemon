import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';

class LogListItem extends StatelessWidget {
  Log log;
  LogListItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(width: 115, height: 60, decoration: BoxDecoration(color: Colors.blue.shade900, border: Border(left: BorderSide(color: Colors.blueGrey), right: BorderSide(color: Colors.blueGrey),),),),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 5),
                // color: Colors.blue.shade900,
                child: Text(log.timeStamp),
              ),
              SizedBox(width: 5.0,),
              Flexible(
                child: Container(
                  alignment: Alignment.topLeft,
                  color: Color.fromARGB(255, 0, 0, 61),
                  child: RichText(
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: log.body,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
