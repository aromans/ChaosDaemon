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
  int? packetsReceived;
  int? packetsTransmitted;

  // String? stringStatus = "dead";
  SystemStatus containerStatus = SystemStatus.healthy;

  String statusToString() {
    switch (containerStatus) {
      case SystemStatus.healthy:
        return "Healthy";
      case SystemStatus.unhealthy:
        return "Unhealthy";
      case SystemStatus.dead:
        return "Out of Service";
      default:
        return "Out of Service";
    }
  }

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
  }) {
    if (this.memoryFree != null && this.memoryUtil != null) {
      this.memoryFree = this.totalMemory! - this.memoryUtil!;
    }

    this.creationDate = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

    this.scenarioQueue = EventListQueue();
    this.animStatus = ScenarioAnimController();

    // if (stringStatus == null) this.stringStatus = "Dead";

    this.containerStatus = SystemStatus.healthy;

    eventNotifier = Delegate();
  }

  Map<String, String> getStats() {
    Map<String, String> retStats = {};
    retStats['CPU'] = '${this.cpuUtil!.toStringAsFixed(2)} %';
    retStats['Memory Total'] = '${this.totalMemory!.toStringAsFixed(2)} MB';
    retStats['Memory'] = '${this.memoryUtil!.toStringAsFixed(2)} %';
    retStats['Packets Received'] = '${this.packetsReceived!}';
    retStats['Packets Transmitted'] = '${this.packetsTransmitted!}';
    retStats['Uptime'] = '${this.uptime!.toStringAsFixed(2)} hrs';
    return retStats;
  }

  Map<String, String> getScenarioHistory() {
    Map<String, String> retScenarioHistory = {};
    retScenarioHistory['2021-09-21 17:52:23'] = 'pass';
    retScenarioHistory['2021-09-21 17:55:07'] = 'heal';
    retScenarioHistory['2021-09-21 18:01:47'] = 'fail';
    retScenarioHistory['2021-09-21 18:04:36'] = 'heal';
    retScenarioHistory['2021-09-21 18:08:51'] = 'pass';
    retScenarioHistory['2021-09-21 19:00:01'] = 'heal';

    return retScenarioHistory;
  }
}
