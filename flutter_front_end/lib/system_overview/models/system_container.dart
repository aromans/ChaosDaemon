import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

import '../../models/scenario.dart';

import 'package:flutter_front_end/system_overview/widgets/scenarios/scenario_widget.dart';


class SystemContainer with ChangeNotifier {
  final String id;

  // card metrics
  double? uptime;
  String? creationDate;
  double? cpuUtil;
  double? memoryFree;
  double? totalMemory;
  double? memoryUtil;
  double? packetsReceived;
  double? packetsTransmitted;
  SystemStatus containerStatus = SystemStatus.healthy;

  // expanded metrics
  String? root_dir;
  String? currentOwnership;
  double? ipAddr;
  String? image;
  String? network;
  String? role;
  String? engine;

  // Scenario Data/Visualization
  Scenario? currentScenario;
  ScenarioAnimController? animStatus;
  ListQueue<Scenario>? scenarioQueue;
  Map<String, Scenario> scenarioHistory = {};

  SystemContainer({
    required this.id,
    this.uptime,
    this.cpuUtil,
    this.totalMemory,
    this.memoryUtil,
    this.packetsReceived,
    this.packetsTransmitted,
    this.root_dir,
    this.currentOwnership,
    this.ipAddr,
    this.image,
    this.network,
    this.role,
    this.engine,
    this.currentScenario,
  }) {
    if (this.memoryFree != null && this.memoryUtil != null) {
      this.memoryFree = this.totalMemory! - this.memoryUtil!;
    }

    creationDate = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

    scenarioQueue = ListQueue();
    animStatus = ScenarioAnimController();
  }
}
