import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/components/dotted_decoration.dart';
import 'package:flutter_front_end/widgets/log_window.dart';
import 'package:flutter_front_end/widgets/panel_icon_widget.dart';

class ExpandablePanelVert extends StatefulWidget {
  final bool leftSide;
  final Color panelColor;
  double maxWidth;

  // final Map<String, PanelIconWidget> iconWidgets;
  final PanelIconWidget? mainWidget;

  ExpandablePanelVert({
    required this.leftSide,
    required this.maxWidth,
    required this.panelColor,
    required this.mainWidget,
  });

  @override
  State<StatefulWidget> createState() => VertPanelState(maxWidth);
}

class VertPanelState extends State<ExpandablePanelVert>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _changeWidth;
  late Animation<double> _rotateArrow;
  late Animation<double> _widgetOpacity;
  // late Widget? selectedWidget = null;

  bool _isExpanded = false;

  VertPanelState(double width) {
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    _changeWidth = Tween<double>(begin: 40, end: width).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _rotateArrow = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _widgetOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.65, 1.0, curve: Curves.easeInOutCubic),
      ),
    );
  }

  Icon _getArrowIcon() {
    if (widget.leftSide) return Icon(CupertinoIcons.arrowtriangle_right_fill);
    return Icon(CupertinoIcons.arrowtriangle_left_fill);
  }

  Alignment _getAlignment() {
    if (widget.leftSide) return Alignment.centerRight;
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
    // if (widget.iconWidgets.containsKey("Log Window")) {
    //   selectedWidget = widget.iconWidgets["Log Window"]?.widget;
    // }

    return Container(
      width: _changeWidth.value,
      height: MediaQuery.of(context).size.width * 0.9,
      color: widget.panelColor,
      child: Stack(
        children: [
          Opacity(
            opacity: _widgetOpacity.value,
            child: Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: widget.leftSide
                        ? EdgeInsets.only(right: 25)
                        : EdgeInsets.only(left: 25),
                    width: widget.maxWidth * 0.85,
                    height: MediaQuery.of(context).size.height * 0.95,
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      strokeWidth: 2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: widget.leftSide
                        ? EdgeInsets.only(right: 25)
                        : EdgeInsets.only(left: 25),
                    width: widget.maxWidth * 0.85,
                    height: MediaQuery.of(context).size.height * 0.95,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 25).withOpacity(0.5),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  Container(
                    margin: widget.leftSide
                        ? EdgeInsets.only(right: 25)
                        : EdgeInsets.only(left: 25),
                    width: widget.maxWidth * 0.85,
                    height: MediaQuery.of(context).size.height * 0.95,
                    alignment: Alignment.center,
                    child: widget.mainWidget == null
                        ? Text('Nothing selected')
                        : widget.mainWidget!.widget,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: _getAlignment(),
            child: RotationTransition(
              turns: _rotateArrow,
              child: IconButton(
                onPressed: movePanel,
                color: Color.fromARGB(255, 0, 0, 20),
                icon: _getArrowIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _controller, builder: _buildPanel);
  }
}
