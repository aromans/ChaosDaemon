import 'package:flutter/foundation.dart';
import 'dart:math';

import './system_container.dart';
//import './scenarios.dart';

class SystemContainers with ChangeNotifier {
  int _itemCount = 0;
  List<SystemContainer> _systemContainers = [
    SystemContainer(
        id: 'SOLR',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'HAProxy',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'SOA Core',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Artemis',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Kafka',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Prometheus',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Filebeat',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Elastic Search',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'LDAP',
        uptime: Random().nextDouble() * 10,
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
  ];

  SystemContainer findById(String id) {
    return _systemContainers.firstWhere((container) => container.id == id);
  }

  List<SystemContainer> get items {
    return [..._systemContainers];
  }

  int get itemCount {
    return _systemContainers.length;
  }

  void addContainer(SystemContainer container) {
    _systemContainers.add(container);
    notifyListeners();
  }
}
