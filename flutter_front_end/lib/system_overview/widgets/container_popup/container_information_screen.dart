import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late double _dependentWidth, _independentWidth, _dividerWidth, _maxHeight;
  late double _variableWidth, _minWidth;
  bool _init = true;
  bool _leftClosed = false, _rightClosed = false;
  Color _foregroundColor = Color.fromARGB(255, 0, 0, 139);

  @override
  Widget build(BuildContext context) {
    _dividerWidth = MediaQuery.of(context).size.width * 0.025;
    _variableWidth = MediaQuery.of(context).size.width - _dividerWidth;
    _maxHeight = MediaQuery.of(context).size.height * 0.95;
    _minWidth = MediaQuery.of(context).size.width * 0.3;

    if (_init) {
      _independentWidth = _variableWidth * 0.5;
      _dependentWidth = _variableWidth - _independentWidth;
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
                height: _maxHeight,
                width: _independentWidth,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 61),
                ),
                child: LineChart(
                  mainData(),
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _rightClosed = false;
                    _leftClosed = false;
                    _independentWidth += details.delta.dx;
                    _dependentWidth -= details.delta.dx;
                    _init = false;

                    // width checks
                    // if (_rightClosed = false) {
                    //   if (_dependentWidth < _minWidth) {
                    //     _dependentWidth = _minWidth;
                    //     _independentWidth = _variableWidth - _minWidth;
                    //   }
                    // }

                    // if (_independentWidth < _minWidth) {
                    //   _independentWidth = _minWidth;
                    //   _dependentWidth = _variableWidth - _minWidth;
                    // }

                    if (_independentWidth < 0) {
                      _independentWidth = 0;
                      _dependentWidth = _variableWidth;
                    }
                    if (_independentWidth > _variableWidth) {
                      _independentWidth = _variableWidth;
                      _dependentWidth = 0;
                    }
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // IconButton(
                    //   onPressed: () => {
                    //     setState(() {
                    //       _dependentWidth = 0;
                    //       _rightClosed = true;
                    //     }),
                    //   },
                    //   icon: Icon(
                    //     CupertinoIcons.arrow_right_to_line,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    Container(
                      alignment: Alignment.center,
                      width: _dividerWidth,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Container Logs',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                  ],
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
