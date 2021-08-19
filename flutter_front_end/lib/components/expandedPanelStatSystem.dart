import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class expandedPanelStatSystem extends StatefulWidget {
  expandedPanelStatSystem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => expandedPanelStatSystemState();
}

class expandedPanelStatSystemState extends State<expandedPanelStatSystem>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Hey!'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
