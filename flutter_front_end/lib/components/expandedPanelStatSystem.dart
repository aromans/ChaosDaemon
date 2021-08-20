import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class expandedPanelStatSystem extends StatefulWidget {
  Color testColor;
  expandedPanelStatSystem(this.testColor, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      expandedPanelStatSystemState(testColor);
}

class expandedPanelStatSystemState extends State<expandedPanelStatSystem>
    with SingleTickerProviderStateMixin {
  Color testColor;
  @override
  void initState() {
    super.initState();
  }

  expandedPanelStatSystemState(this.testColor);
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
              color: this.testColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(width: 5, color: Colors.white)),
          width: 400,
          height: 100,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
