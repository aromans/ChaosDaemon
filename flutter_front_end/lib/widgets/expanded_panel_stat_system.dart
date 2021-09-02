import 'package:flutter/material.dart';

class ExpandedPanelStatSystem extends StatefulWidget {
  // constructor values
  final Color testColor;

  // default values
  final double containerWidth = 400.0;
  final double containerHeight = 100.0;
  final double containerPadding = 50.0;
  final double borderWidth = 5.0;
  final Radius borderRadius = Radius.circular(8.0);

  final Color borderColor = Colors.white;

  ExpandedPanelStatSystem(this.testColor, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpandedPanelStatSystemState();
}

class _ExpandedPanelStatSystemState extends State<ExpandedPanelStatSystem>
    with SingleTickerProviderStateMixin {
  // @override
  // void initState() {
  //   super.initState();
  // }

  _ExpandedPanelStatSystemState();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(widget.containerPadding),
        decoration: BoxDecoration(
          color: widget.testColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(widget.borderRadius),
          border: Border.all(
            width: widget.borderWidth,
            color: widget.borderColor,
          ),
        ),
        width: widget.containerWidth,
        height: widget.containerHeight,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
