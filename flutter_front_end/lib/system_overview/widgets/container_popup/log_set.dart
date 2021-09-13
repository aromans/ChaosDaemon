import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';
import 'package:intl/intl.dart';

class LogSet {
  int itemCount = 0;

  static generateData() {
    List<Log> retList = [];
    for (int i = 0; i < 20; i++) {
      retList.add(
        Log(
          timeStamp: DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now()),
          body:
              'blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
          level: i,
        ),
      );
    }
    return retList;
  }
}
