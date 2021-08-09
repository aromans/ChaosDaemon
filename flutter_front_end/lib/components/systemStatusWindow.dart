import 'package:flutter_js/flutter_js.dart';
import 'package:flutter/material.dart';
import 'package:gviz/gviz.dart';

class statusGraph {
  final graph = Gviz();

  void drawItem() {
    for (var item in [
      [1, 2],
      [2, 3],
      [2, 5],
      [4, 3]
    ]) {
      final from = item[0].toString();
      final to = item[1].toString();

      if (item[0] % 2 == 1 && !graph.nodeExists(from)) {
        graph.addNode(from, properties: {'color': 'red'});
      }

      graph.addEdge(from, to);
    }

    print(graph);
  }
}

class systemStatusWindow extends StatelessWidget {
  final statusGraph graph = statusGraph();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Text(graph.drawItem()),
    );
  }
}
