import 'package:flutter/foundation.dart';
import 'dart:math';

import './system_container.dart';
//import './scenarios.dart';

class SystemContainers with ChangeNotifier {
  int _itemCount = 0;
  List<SystemContainer> _systemContainers = [
    SystemContainer(
        id: 'SOLR',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'HAProxy',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'SOA Core',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Artemis',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Kafka',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Prometheus',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Filebeat',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'Elastic Search',
        cpuUtil: Random().nextDouble() * 4,
        memoryUtil: Random().nextDouble() * 64,
        totalMemory: 64,
        packetsReceived: Random().nextDouble() * 500,
        packetsTransmitted: Random().nextDouble() * 500),
    SystemContainer(
        id: 'LDAP',
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
    return _itemCount;
  }

  void addContainer(SystemContainer container) {
    _systemContainers.add(container);
    notifyListeners();
  }
}
