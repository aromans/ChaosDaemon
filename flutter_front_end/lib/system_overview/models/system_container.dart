import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';
import 'package:flutter_front_end/models/event_list_queue.dart';
import 'package:flutter_front_end/system_overview/animation/scenario_anim_controller.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

import '../../models/scenario.dart';
import 'package:flutter_front_end/system_overview/models/system_status.dart';

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

  String? stringStatus = "dead";
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
  // ListQueue<Scenario>? scenarioQueue;
  EventListQueue<Scenario>? scenarioQueue;
  Map<String, Scenario> scenarioHistory = {};

  int scenarioCounter = 0;

  late Delegate eventNotifier;

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
    this.stringStatus,
  }) {
    if (this.memoryFree != null && this.memoryUtil != null) {
      this.memoryFree = this.totalMemory! - this.memoryUtil!;
    }

    this.creationDate = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

    this.scenarioQueue = EventListQueue();
    this.animStatus = ScenarioAnimController();

    if (stringStatus == null)
      this.stringStatus = "Dead";

    this.containerStatus = stringToStatus(stringStatus);
    
    eventNotifier = Delegate();
  }
}
