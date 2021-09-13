import 'package:flutter/material.dart';

@immutable
class GraphFilterWidget extends StatefulWidget {
  final Map<String, Widget> widgetMap;
  GraphFilterWidget({required this.widgetMap});

  @override
  State<StatefulWidget> createState() => GraphFilterWidgetState();
}

class GraphFilterWidgetState extends State<GraphFilterWidget> {
  List<Widget> buildWidgets(Map<String, Widget> widgetMap) {
    List<Widget> widgetList = [];
    widgetMap.forEach(
      (key, value) {
        widgetList.add(
          Container(
            child: Text(key),
          ),
        );
      },
    );
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: buildWidgets(widget.widgetMap));
  }
}
