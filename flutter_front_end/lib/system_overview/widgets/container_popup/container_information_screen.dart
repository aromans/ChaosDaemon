import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/sliding_stack.dart';
import 'package:flutter_front_end/system_overview/system_status_window.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_widget.dart';
import 'package:provider/provider.dart';

// user-defined
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/graph_filter_widget.dart';

@immutable
class ContainerInformationScreen extends StatefulWidget {
  static const String pageRoute = '/ContainerInformationScreen';
  final String containerName;
  ContainerInformationScreen({required this.containerName});

  @override
  State<StatefulWidget> createState() => ContainerInformationScreenState();
}

class ContainerInformationScreenState
    extends State<ContainerInformationScreen> {
  
  late double _screenHeight, _screenWidth;

  late double _dependentWidth, _independentWidth, _dividerWidth, _maxHeight;
  late double _variableWidth, _minWidth, _barHeight;

  late double _deltaBox1, _deltaBox2, _deltaBox3;

  late double _bottomOfScreen;

  late double _sharedBy1 = 0.0;
  late double _sharedBy3 = 0.0;
  

  late double topBox;
  late double middleBox;
  late double bottomBox;

  bool _init = true;
  bool _leftClosed = false, _rightClosed = false;
  Color _foregroundColor = Color.fromARGB(255, 0, 0, 139);

  @override
  Widget build(BuildContext context) {

    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;

    _dividerWidth = _screenWidth * 0.025;
    _variableWidth = _screenWidth - _dividerWidth;
    _maxHeight = _screenHeight * 0.95;
    _minWidth = _screenWidth * 0;

    _barHeight = _screenHeight - _maxHeight;

    _bottomOfScreen = _screenHeight - _barHeight - 2 * _dividerWidth;
    
    if (_init) {
      _independentWidth = _variableWidth * 0.5;
      _dependentWidth = _variableWidth - _independentWidth;

      topBox = _maxHeight * 0.25 - _dividerWidth;
      _deltaBox1 = topBox;
      middleBox = _maxHeight * 0.25 - _dividerWidth;
      _deltaBox2 = middleBox;
      bottomBox = _maxHeight * 0.5;
      _deltaBox3 = bottomBox;
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 61),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    CupertinoIcons.arrow_left_square_fill,
                    color: Color.fromARGB(255, 88, 176, 156),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: _independentWidth,
                child: GestureDetector(child: 
                  SlidingStack([Container(), Container(), Container(),Container(), Container(), Container(),Container(), Container()], _screenWidth, _screenHeight))),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _rightClosed = false;
                    _leftClosed = false;
                    _independentWidth += details.delta.dx;
                    _dependentWidth -= details.delta.dx;
                    _init = false;

                    // width checks
                    if (_independentWidth < _minWidth) {
                      _independentWidth = _minWidth;
                      _dependentWidth = _variableWidth - _minWidth;
                    }
                    if (_dependentWidth < _minWidth) {
                      _independentWidth = _variableWidth - _minWidth;
                      _dependentWidth = _minWidth;
                    }
                  });
                },
                child: 
                  Container(
                    color: Color.fromARGB(0, 0, 0, 0),
                    alignment: Alignment.center,
                    width: _dividerWidth,
                    height: _maxHeight,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Container Logs',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
              ),
              Container(
                height: _maxHeight,
                width: _dependentWidth,
                decoration: BoxDecoration(
                  color: _foregroundColor,
                ),
                child: LogWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
