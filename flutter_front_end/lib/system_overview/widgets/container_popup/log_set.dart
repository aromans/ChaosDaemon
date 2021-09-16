import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/random_log_message.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class LogSet {
  int itemCount = 0;

  static generateData() {
    int _messageLen = 200;
    int randomLen = Random().nextInt(_messageLen);
    RandomLogMessageGenerator rlmg = RandomLogMessageGenerator();
    List<Log> retList = [];

    if (randomLen == 0) {
      randomLen += 1;
    }
    
    for (int i = 0; i < 20; i++) {
      retList.add(
        Log(
          timeStamp: DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now()),
          body: rlmg.generate(Random().nextInt(200)),
          level: i,
        ),
      );
    }
    return retList;
  }
}
