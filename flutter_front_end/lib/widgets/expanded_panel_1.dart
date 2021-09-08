import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandedPanel extends StatefulWidget {
  final Map<String, Widget> widgetMap;
  final BoxDecoration panelDecoration;
  final bool vertical;
  final bool left;
  final bool top;
  ExpandedPanel({
    required this.widgetMap,
    required this.panelDecoration,
    required this.vertical,
    required this.left,
    required this.top,
  });

  @override
  State<StatefulWidget> createState() => ExpandedPanelState();
}

class ExpandedPanelState extends State<ExpandedPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _movePanelUp;
  late Animation<Offset> _movePanelDown;
  late Animation<Offset> _movePanelLeft;
  late Animation<Offset> _movePanelRight;
  late Animation<double> _rotateArrow;
  late Animation<double> _expandHiddenPanel;
  bool isExpanded = false;

  Widget? selectedWidget = Container();
  List<Widget> textWidgets = [];

  Icon arrowIcon(bool isExpanded) {
    return Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_upward);
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _movePanelUp = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.05,
          0.75,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    _movePanelDown = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0.5),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.05,
          0.75,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    _movePanelLeft = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.05,
          0.75,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    _movePanelRight = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.05,
          0.75,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
    _rotateArrow = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
    _expandHiddenPanel = Tween<double>(
      begin: 0,
      end: 200,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.75,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    Map<String, Widget>? widgetMap = widget.widgetMap;

    TextStyle topRowStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    int counter = 0;
    for (String name in widgetMap.keys) {
      counter++;
      textWidgets.add(
        InkWell(
          onTap: () {
            if (!isExpanded) {
              isExpanded = !isExpanded;
              _controller.forward();
            }
            setState(
              () {
                selectedWidget = widgetMap[name];
              },
            );
          },
          onHover: (value) {
            setState(() {});
          },
          child: Text(
            name,
            style: topRowStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );

      if (counter < widgetMap.keys.length) {
        textWidgets.add(
          Container(
            height: 25,
            child: VerticalDivider(
              color: Colors.white,
              width: 15,
              thickness: 2,
            ),
          ),
        );
      }
    }

    super.initState();
  }

  // Widget? _selectedWidget(BuildContext context) {
  //   if (selectedWidget != "") {
  //     setState(() {

  //     });
  //     print('select widget: ' + selectedWidget);
  //     return widgetMap[selectedWidget];
  //   }
  //   return Container();
  // }

  IconData getIcon({
    bool vertical = false,
    bool left = false,
    bool top = false,
  }) {
    if (vertical && !left) {
      return CupertinoIcons.arrowtriangle_left_fill;
    } else if (!vertical && top) {
      return CupertinoIcons.arrowtriangle_up_fill;
    } else if (vertical && left) {
      return CupertinoIcons.arrowtriangle_right_fill;
    } else {
      return CupertinoIcons.arrowtriangle_down_fill;
    }
  }

  Animation<Offset> getMovePanel({
    bool vertical = false,
    bool left = false,
    bool top = false,
  }) {
    if (vertical && !left) return _movePanelLeft;
    if (!vertical && top) return _movePanelDown;
    if (vertical && left) return _movePanelRight;
    return _movePanelUp;
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return new Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        IgnorePointer(
          child: Container(
            decoration: widget.panelDecoration,
            child: selectedWidget,
            height: widget.vertical
                ? MediaQuery.of(context).size.height * 1
                : _expandHiddenPanel.value,
            width: widget.vertical
                ? _expandHiddenPanel.value
                : MediaQuery.of(context).size.width * 0.5,
          ),
        ),
        SlideTransition(
          position: getMovePanel(
            vertical: widget.vertical,
            top: widget.top,
            left: widget.left,
          ),
          child: Container(
            decoration: widget.panelDecoration,
            height: widget.vertical
                ? MediaQuery.of(context).size.height * 1
                : MediaQuery.of(context).size.height * 0.05,
            width: widget.vertical
                ? MediaQuery.of(context).size.width * 0.05
                : MediaQuery.of(context).size.width * 0.5,
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //     child: Row(children: textWidgets),
                  //     padding: EdgeInsets.only(left: 25)),
                  // Row(children: [])
                ],
              ),
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
              floatingActionButton: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    if (!isExpanded) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                    isExpanded = !isExpanded;
                  },
                  child: RotationTransition(
                    turns: _rotateArrow,
                    child: Icon(
                      getIcon(
                          vertical: widget.vertical,
                          top: widget.top,
                          left: widget.left),
                    ),
                  ),
                  tooltip: 'Create a scenario',
                  backgroundColor: Color.fromARGB(255, 19, 21, 22),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndTop,
            ),
          ),
        ),
      ],
    );
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
