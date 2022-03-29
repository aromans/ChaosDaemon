import 'package:flutter/foundation.dart';
import 'package:flutter_front_end/system_overview/models/system_status.dart';
import 'package:flutter_front_end/models/delegate.dart';
import 'package:flutter_front_end/main.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'system_container.dart';
//import './scenarios.dart';

class SystemContainerSet {
  static List<String> _containerNameHistory = [];
  static List<SystemContainer> _systemContainers = [];

  static Delegate updateAllListeners = Delegate();

  static void createContainer(String name, Map stats) {
    if (doesExist(name)) {
      updateExistingContainer(name, stats);
    } else {
      var Now = DateTime.now();
      Duration uptime = Now.difference(AppTime.upTime[name]!);

      var container = SystemContainer(
        id: name,
        uptime: uptime.inHours.toDouble(),
        cpuUtil: (stats["cpu_stats"]!["cpu_usage"]!["total_usage"] /
            stats["cpu_stats"]!["system_cpu_usage"]),
        memoryUtil: (stats["memory_stats"]!["usage"]) /
            (stats["memory_stats"]!["limit"]),
        totalMemory: stats["memory_stats"]!["limit"].toDouble() / 1e9,
        packetsReceived: stats["networks"]!["eth0"]!["rx_packets"],
        packetsTransmitted: stats["networks"]!["eth0"]!["tx_packets"],
      );

      _containerNameHistory.add(name);
      addContainer(container);
    }
  }

  static void updateExistingContainer(String name, Map stats) {
    int index = getIndexOf(name);
    SystemContainer container = _systemContainers[index];

    // var _lastConso = DateTime.now().subtract();
    var Now = DateTime.now();
    Duration uptime = Now.difference(AppTime.upTime[name]!);

    container.uptime = uptime.inHours.toDouble();
    container.cpuUtil = stats["cpu_stats"]!["cpu_usage"]!["total_usage"] /
        stats["cpu_stats"]!["system_cpu_usage"];
    container.memoryUtil =
        (stats["memory_stats"]!["usage"]) / (stats["memory_stats"]!["limit"]);
    container.totalMemory = stats["memory_stats"]!["limit"].toDouble() / 1e9;
    container.packetsReceived = stats["networks"]!["eth0"]!["rx_packets"];
    container.packetsTransmitted = stats["networks"]!["eth0"]!["tx_packets"];

    _systemContainers[index] = container;
  }

  static SystemContainer findById(String id) {
    return _systemContainers.firstWhere((container) => container.id == id);
  }

  static int getIndexOf(String id) {
    return _systemContainers.indexWhere((element) => element.id == id);
  }

  static bool doesExist(String id) {
    return _systemContainers.any((element) => element.id == id);
  }

  static void removeElementById(String id) {
    if (doesExist(id)) {
      int index = getIndexOf(id);
      SystemContainer temp = _systemContainers.last;
      _systemContainers.last = _systemContainers[index];
      _systemContainers[index] = temp;
      _systemContainers.removeLast();
    }
  }

  static List<SystemContainer> get items {
    return [..._systemContainers];
  }

  static int get itemCount {
    return _systemContainers.length;
  }

  static void addContainer(SystemContainer container) {
    _systemContainers.add(container);
  }
}
