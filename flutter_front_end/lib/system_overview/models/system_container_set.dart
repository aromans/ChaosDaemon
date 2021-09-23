import 'package:flutter/foundation.dart';
import 'package:flutter_front_end/system_overview/models/system_status.dart';
import 'package:flutter_front_end/models/delegate.dart';
import 'dart:math';

import 'system_container.dart';
//import './scenarios.dart';

class SystemContainerSet {

  static List<String> _containerNameHistory = [];
  static List<SystemContainer> _systemContainers = [];

  static Delegate updateAllListeners = Delegate();

  static void createContainer(String name, List stats) {
    if (doesExist(name)) {
      updateExistingContainer(name, stats);
    } else {
      Duration uptime = DateTime.now().difference(DateTime.parse(stats.first["timestamp"]));
      var container = SystemContainer(
        id: name,
        uptime: uptime.inHours.toDouble(),
        cpuUtil: stats.last["cpu"]!["usage"]!["total"] / stats.last["cpu"]!["usage"]!["system"],
        memoryUtil: (stats.last["memory"]!["usage"] / 1000000) / (stats.last["memory"]!["max_usage"] / 1000000),
        totalMemory: stats.last["memory"]!["max_usage"].toDouble() / 1000000,
        packetsReceived: stats.last["network"]!["rx_packets"],
        packetsTransmitted: stats.last["network"]!["tx_packets"],);
      
      _containerNameHistory.add(name);
      addContainer(container);
    }
  }

  static void updateExistingContainer(String name, List stats) {
    int index = getIndexOf(name);
    SystemContainer container = _systemContainers[index];

    Duration uptime = DateTime.now().difference(DateTime.parse(stats.first["timestamp"]));


    container.uptime = uptime.inHours.toDouble();
    container.cpuUtil = stats.last["cpu"]!["usage"]!["total"] / stats.last["cpu"]!["usage"]!["system"];
    container.memoryUtil = (stats.last["memory"]!["usage"] / 1000000) / (stats.last["memory"]!["max_usage"] / 1000000);
    container.totalMemory = stats.last["memory"]!["usage"].toDouble() / 1000000;
    container.packetsReceived = stats.last["network"]!["rx_packets"];
    container.packetsTransmitted = stats.last["network"]!["tx_packets"];
    
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
