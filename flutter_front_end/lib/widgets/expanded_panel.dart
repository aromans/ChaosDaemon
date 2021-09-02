import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandedPanel extends StatefulWidget {
  final Map<String, Widget> widgetMap;
  ExpandedPanel(this.widgetMap, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExpandedPanelState(widgetMap);
}

class ExpandedPanelState extends State<ExpandedPanel>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _movePanel;
  late Animation<double> _rotateArrow;
  late Animation<double> _expandHiddenPanel;
  bool isExpanded = false;
  Widget? selectedWidget = Container();
  final Map<String, Widget> widgetMap;
  List<Widget> textWidgets = [];
  ExpandedPanelState(this.widgetMap);

  Icon arrowIcon(bool isExpanded) {
    return Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_upward);
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _movePanel = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.05, 1, curve: Curves.easeInOutCubic),
      ),
    );
    _rotateArrow = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _expandHiddenPanel = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1, curve: Curves.easeInOutCubic),
      ),
    );

    Map<String, Widget>? widgetMap = widget.widgetMap;

    TextStyle topRowStyle = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

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
            setState(() {
              selectedWidget = widgetMap[name];
            });
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

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return new Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      IgnorePointer(
        child: Container(
          child: selectedWidget,
          height: _expandHiddenPanel.value,
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.indigo,
        ),
      ),
      SlideTransition(
        position: _movePanel,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.indigo,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    child: Row(children: textWidgets),
                    padding: EdgeInsets.only(left: 25)),
                Row(children: [])
              ],
            ),
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
    ],);
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
