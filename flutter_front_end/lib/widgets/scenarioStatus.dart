import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/controllers/scenarioQueue.dart';
import 'package:flutter_front_end/models/scenarioAnimController.dart';
import 'package:provider/provider.dart';

class scenarioStatus extends StatefulWidget {
  scenarioStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => scenarioStatusState();
}

class scenarioStatusState extends State<scenarioStatus> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => scenarioAnimController(),
      child: scenarioQueue());
  }
}
