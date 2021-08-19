import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class expandedPanel extends StatefulWidget {
  final Map<String, Widget> widgetMap;
  expandedPanel(this.widgetMap, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => expandedPanelState(widgetMap);
}

class expandedPanelState extends State<expandedPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _movePanel;
  late Animation<double> _rotateArrow;
  late Animation<double> _expandHiddenPanel;
  bool isExpanded = false;

  final Map<String, Widget> expandedPanelWidgetMap;
  expandedPanelState(this.expandedPanelWidgetMap);

  Icon arrowIcon(bool isExpanded) {
    return Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_upward);
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _movePanel = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -3)).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.05, 1, curve: Curves.easeInOutCubic)));
    _rotateArrow = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    _expandHiddenPanel = Tween<double>(begin: 0, end: 200).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1, curve: Curves.easeInOutCubic)));

    super.initState();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    Map<String, Widget>? widgetMap = widget.widgetMap;
    return new Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      IgnorePointer(
        child: Container(
          height: _expandHiddenPanel.value,
          color: Colors.indigo,
          //TODO: child: Display Widget
        ),
      ),
      SlideTransition(
        position: _movePanel,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.indigo,
          child: Scaffold(
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!isExpanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
                isExpanded = !isExpanded;
              },
              child: RotationTransition(
                  turns: _rotateArrow, child: Icon(Icons.arrow_upward)),
              tooltip: 'Create a scenario',
              backgroundColor: Colors.indigo,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(builder: _buildAnimation, animation: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
