import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_front_end/components/dotted_decoration.dart';
import 'package:flutter_front_end/system_overview/models/system_status.dart';

class ExpandablePanelHorz extends StatefulWidget {
  ExpandablePanelHorz(this.topSide, this.maxHeight, this.panelDecor, {Key? key}) : super(key: key);

  final bool topSide;
  final BoxDecoration panelDecor;

  double maxHeight;

  @override
  State<StatefulWidget> createState() => HorzPanelState(maxHeight);
}

class HorzPanelState extends State<ExpandablePanelHorz> with TickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _changeHeight;
  late Animation<double> _rotateArrow;
  late Animation<double> _widgetOpacity;

  bool _isExpanded = false;

  HorzPanelState(double height) {
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this);

    _changeHeight = Tween<double>(begin: 40, end: height).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Interval(
          0.0, 
          1.0, 
          curve: Curves.easeInOutCubic),
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

  Color unhealthyColor = Color.fromARGB(255, 255, 221, 74);
  Color deadColor = Color.fromARGB(255, 216, 0, 50);
  Color healthyColor = Color.fromARGB(255, 7, 218, 74);

  Tooltip statusIcon(SystemStatus ss) {
    if (ss == SystemStatus.healthy) {
      return Tooltip(
        message: 'Healthy',
        child: Icon(
          CupertinoIcons.wifi,
          color: this.healthyColor,
        ),
      );
    } else if (ss == SystemStatus.unhealthy) {
      return Tooltip(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        message: 'Unhealthy',
        child: Icon(
          CupertinoIcons.wifi_exclamationmark,
          color: this.unhealthyColor,
        ),
      );
    } else {
      return Tooltip(
        padding: EdgeInsets.all(0),
        message: 'Out of service',
        child: Icon(
          CupertinoIcons.wifi_slash,
          color: this.deadColor,
        ),
      );
    }
  }

  Icon _getArrowIcon() {
    if (widget.topSide) 
      return Icon(CupertinoIcons.arrowtriangle_down_fill, color: Colors.white,);
    return Icon(CupertinoIcons.arrowtriangle_up_fill, color: Colors.white,);
  }

  Alignment _getAlignment() {
    if (widget.topSide) 
      return Alignment.topRight;
    return Alignment.topRight;
  }

  void movePanel() {
    if (!_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isExpanded = !_isExpanded;
  }

  List<Widget> _builtWidgetButtons() {
  
    List<Widget> wList = [
      SizedBox(width: 10,),
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 5.0),
        child: statusIcon(SystemStatus.healthy),
      ),
      SizedBox(width: 30,),
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 7.5),
        child: Text(
          "Stuff",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      SizedBox(width: 30,),
    ];

    for (int i = 0; i < 5; i++) {
      wList.add(Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 5.0),
        margin: const EdgeInsets.only(right: 15.0),
        child: IconButton(
          alignment: Alignment.topCenter,
          iconSize: 24,
          color: Colors.amber,
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            print("Show something");
            if (!_isExpanded) movePanel();
          }, 
          icon: Icon(CupertinoIcons.badge_plus_radiowaves_right),
        ),
      ));
    }

    return wList;
  }

  Widget _buildPanel(BuildContext context, Widget? child) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: _changeHeight.value,
      decoration: widget.panelDecor,
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
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.68,
                    height: widget.maxHeight * 0.8,
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      strokeWidth: 2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.68,
                    height: widget.maxHeight * 0.8,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 25)
                          .withOpacity(0.5),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _builtWidgetButtons(),
          ),
          Container(
            alignment: _getAlignment(),
            child: RotationTransition(
              turns: _rotateArrow,
              child: IconButton(
                padding: EdgeInsets.all(0.0),
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