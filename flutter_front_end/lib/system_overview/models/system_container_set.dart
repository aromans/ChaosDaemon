import 'package:flutter/foundation.dart';
import 'dart:math';

import 'system_container.dart';
//import './scenarios.dart';

class SystemContainerSet {

  static List<SystemContainer> _systemContainers = [];
    // SystemContainer(
    //     id: 'SOLR',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Healthy"),
    // SystemContainer(
    //     id: 'HAProxy',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Healthy"),
    // SystemContainer(
    //     id: 'SOA Core',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Healthy"),
    // SystemContainer(
    //     id: 'Artemis',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Dead"),
    // SystemContainer(
    //     id: 'Kafka',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500)),
    // SystemContainer(
    //     id: 'Prometheus',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Unhealthy"),
    // SystemContainer(
    //     id: 'Filebeat',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Healthy"),
    // SystemContainer(
    //     id: 'Elastic Search',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Unhealthy"),
    // SystemContainer(
    //     id: 'LDAP',
    //     uptime: Random().nextDouble() * 10,
    //     cpuUtil: Random().nextDouble() * 4,
    //     memoryUtil: Random().nextDouble() * 64,
    //     totalMemory: 64,
    //     packetsReceived: Random().nextInt(500),
    //     packetsTransmitted: Random().nextInt(500),
    //     stringStatus: "Healthy"),
  // ];

  static SystemContainer createContainer(String name, List stats) {

    Duration uptime = DateTime.now().difference(DateTime.parse(stats.first["timestamp"]));

    var container = SystemContainer(
      id: name,
      uptime: uptime.inHours.toDouble(),
      cpuUtil: stats.last["cpu"]!["usage"]!["total"] / stats.last["cpu"]!["usage"]!["system"],//Random().nextDouble() * 4,
      memoryUtil: stats.last["memory"]!["usage"] / stats.last["memory"]!["max_usage"],
      totalMemory: stats.last["memory"]!["max_usage"].toDouble(),
      packetsReceived: stats.last["network"]!["rx_packets"],
      packetsTransmitted: stats.last["network"]!["tx_packets"],
      stringStatus: "Healthy");

    addContainer(container);

    return container;
  }

  static SystemContainer findById(String id) {
    return _systemContainers.firstWhere((container) => container.id == id);
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
