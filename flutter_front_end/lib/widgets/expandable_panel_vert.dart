import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandablePanelVert extends StatefulWidget {
  ExpandablePanelVert(this.leftSide, this.maxWidth, this.panelColor, {Key? key}) : super(key: key);

  final bool leftSide;
  final Color panelColor;
  double maxWidth;

  @override
  State<StatefulWidget> createState() => VertPanelState(maxWidth);
}

class VertPanelState extends State<ExpandablePanelVert> with TickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _changeHeight;
  late Animation<double> _rotateArrow;

  bool _isExpanded = false;

  VertPanelState(double width) {
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this);

    _changeHeight = Tween<double>(begin: 40, end: width).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Interval(
          0.0, 
          1.0, 
          curve: Curves.easeInOutCubic),
      ),
    );

    _rotateArrow = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  Icon _getArrowIcon() {
    if (widget.leftSide) 
      return Icon(CupertinoIcons.arrowtriangle_right_fill);
    return Icon(CupertinoIcons.arrowtriangle_left_fill);
  }

  Alignment _getAlignment() {
    if (widget.leftSide) 
      return Alignment.centerRight;
    return Alignment.centerLeft;
  }

  void movePanel() {
    if (!_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isExpanded = !_isExpanded;
  }

  Widget _buildPanel(BuildContext context, Widget? child) {
    return Container(
      alignment: _getAlignment(),
      width: _changeHeight.value,
      height: MediaQuery.of(context).size.width * 0.9,
      color: widget.panelColor,
      child: RotationTransition(
        turns: _rotateArrow,
        child: IconButton(
          onPressed: movePanel,
          color: Color.fromARGB(255, 0, 0, 20), 
          icon: _getArrowIcon(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _controller, builder: _buildPanel);
  }

}