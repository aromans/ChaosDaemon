import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './scenarios.dart';

enum SystemStatus {
  healthy,
  unhealthy,
  dead,
}

class SystemContainer with ChangeNotifier {
  final String id;

  // card metrics
  double? uptime;
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
  Scenario? currentScenario;
  Map<String, Scenario> scenarioHistory = {};

  SystemContainer({
    required this.id,
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
  }
}
