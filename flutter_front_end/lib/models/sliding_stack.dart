import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

Delegate updateContainer = Delegate();

class SlidingContainer extends StatelessWidget {

  late double height;
  late Color color;

  // late SlidingContainerState state;

  SlidingContainer(this.height, {Color? color = null}) {
    if (color == null) {
      this.color = Color.fromARGB(
          255, 
          Random().nextInt(255), 
          Random().nextInt(255), 
          Random().nextInt(255),
      );
    } else {
      this.color = color;
    }

    // state = SlidingContainerState();
  }

  StreamController<String> _controller = StreamController<String>();


  void updateHeight(double height) {
    height = height;
    _controller.add("");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        return Container(
          height: height,
          width: double.infinity,
          child: Container(
            color: this.color,
          ),
        );
      }
    );
  }
}

class SlidingStack extends StatefulWidget {
  SlidingStack(this.widgetDisplay, this.width, this.height);

  List<Widget> widgetDisplay;
  double height;
  double width;

  @override
  State<StatefulWidget> createState() => SlidingStackState(widgetDisplay, width, height);
}

class SlidingStackState extends State<SlidingStack> {
  late double _maxHeight, _minWidth;
  late double _screenHeight, _screenWidth;
  late double _dividerWidth;

  late double _bottomOfScreen, _barHeight;

  late List<Widget> widgetDisplay;
  late List<double> _widgetDeltas;

  StreamController<String> _controller = StreamController<String>();

  late List<Widget> _slidingPanelView;
  late List<SlidingContainer> _slidingContainers;

  bool _init = true;

  SlidingStackState(List<Widget> widgetDisplay, width, height) {
    if (widgetDisplay.length <= 1) {
      throw ErrorDescription("Sliding Stack Widget needs at minimum two widgets.");
    }

    this.widgetDisplay = widgetDisplay;
    _widgetDeltas = [];
    _slidingPanelView = [];
    _slidingContainers = [];

    _screenHeight = height;
    _screenWidth = width;

    _dividerWidth = _screenWidth * 0.025;
    _maxHeight = _screenHeight * 0.95;
    _minWidth = _screenWidth * 0;

    _barHeight = _screenHeight - _maxHeight;
    _bottomOfScreen = _screenHeight - _barHeight - (this.widgetDisplay.length) * _dividerWidth;

    // if (_init)
    for (int i = 0; i < this.widgetDisplay.length; i++) {
      if (i != this.widgetDisplay.length - 1) {
         _widgetDeltas.add(_maxHeight / this.widgetDisplay.length -_dividerWidth);
      } else {
         _widgetDeltas.add(_maxHeight / this.widgetDisplay.length);
      }
     
    }

    InitWidgetSliders();
  }

  double calculateDeltas(int j) {
    double total = 0;

    for (int i = 0; i < this._widgetDeltas.length; i++) {
      if (i != j) total += this._widgetDeltas[i];
    }

    return total;
  }

  void InitWidgetSliders() {
    for (int i = 1; i < this.widgetDisplay.length; i++) {
      var widgetOne = this.widgetDisplay[i-1];
      var widgetTwo = this.widgetDisplay[i];

      if (i == 1) {
        SlidingContainer boxOne = SlidingContainer(_widgetDeltas[i-1]);
        _slidingPanelView.add(boxOne);
        _slidingContainers.add(boxOne);
      }

      var slider = GestureDetector(
        onVerticalDragUpdate: (details) { 
          setState(() {
            _widgetDeltas[i-1] += details.delta.dy;
            _widgetDeltas[i] -= details.delta.dy;
            double delta_one = calculateDeltas(i-1);
            double delta_two = calculateDeltas(i);
            
            if (delta_one >= _bottomOfScreen) {
              _widgetDeltas[i-1] = 0;
              _widgetDeltas[i] = _bottomOfScreen - delta_two + details.delta.dy; 
            }

            if (delta_two >= _bottomOfScreen) {
              _widgetDeltas[i] = 0;
              _widgetDeltas[i-1] = _bottomOfScreen - delta_one - details.delta.dy;
            }

          });
        }, 
        child: Container(
          color: Color.fromARGB(0, 0, 0, 0),
          height: _dividerWidth, 
          width: double.infinity,
          alignment: Alignment.center, 
          child: Text("Box ${i-1} & ${i}",),
        ),
      );

      SlidingContainer boxTwo = SlidingContainer(_widgetDeltas[i]);

      _slidingPanelView.add(slider);
      _slidingPanelView.add(boxTwo);
      _slidingContainers.add(boxTwo);
    }

    _init = false;
  }

  void calculatePanels() {
    for (int i = 1; i < this._slidingPanelView.length; i+=2) {

      int j = (i * 0.5).ceil();
    
      int index_one = i - j;
      int index_two = i - (j-1);

      // var boxOne = 
      (_slidingPanelView[i-1] as SlidingContainer).updateHeight(_widgetDeltas[index_one]);//_slidingContainers[index_one];
      // boxOne = SlidingContainer(_widgetDeltas[index_one], color: boxOne.color);

      // var boxTwo = 
      (_slidingPanelView[i+1] as SlidingContainer).updateHeight(_widgetDeltas[index_two]);//_slidingContainers[index_two];
      // boxTwo = SlidingContainer(_widgetDeltas[index_two], color: boxTwo.color);

      // _slidingPanelView[i-1] = (boxOne);
      // _slidingPanelView[i+1] = (boxTwo);
    }
  }

  @override
  Widget build(BuildContext context) {

    calculatePanels();

    return Container(
      height: _maxHeight,
      width: _screenWidth * 0.5,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 61),
      ),
      child: StreamBuilder<Object>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          return Column(
            children: _slidingPanelView,
          );
        }
      ),
    );
  }
}

          // Container(
          //   height: _deltaBox1,
          //   width: double.infinity,
          //   child: Container(color: Colors.red)
          //   // LineChart(
          //   //   mainData(),
          //   // ),
          // ),
          // GestureDetector(
          //   onVerticalDragUpdate: (details) { 
          //     setState(() {
          //       _deltaBox1 += details.delta.dy;
          //       _deltaBox2 -= details.delta.dy;

          //       if (_deltaBox2 + _deltaBox3 >= _bottomOfScreen) {
          //         _deltaBox1 = 0;
          //         _deltaBox2 = _bottomOfScreen - _deltaBox3; 
          //       }

          //       if (_deltaBox1 + _deltaBox3 >= _bottomOfScreen) {
          //         _deltaBox2 = 0;
          //         _deltaBox1 = _bottomOfScreen - _deltaBox3;
          //       }
          //       print("Delta Box 1: ${_deltaBox1}");
          //       print("Delta Box 2: ${_deltaBox2}");

          //       _init = false;
          //     });
          //   }, 
          //   child: Container(
          //     height: _dividerWidth, 
          //     alignment: Alignment.center, 
          //     child: Text("Box 1 & 2",),
          //   ),
          // ),
          // Container(
          //   height: _deltaBox2,
          //   width: _independentWidth,
          //   child: Container(color: Colors.orange)
          //   // LineChart(
          //   //   mainData(),
          //   // ),
          // ),
          // GestureDetector(
          //   onVerticalDragUpdate: (details) { 
          //     setState(() {
          //       _deltaBox2 += details.delta.dy;
          //       _deltaBox3 -= details.delta.dy;         

          //       if (_deltaBox1 + _deltaBox3 >= _bottomOfScreen) {
          //         _deltaBox2 = 0;
          //         _deltaBox3 = _bottomOfScreen - _deltaBox1; 
          //       }

          //       if (_deltaBox1 + _deltaBox2 >= _bottomOfScreen) {
          //         _deltaBox3 = 0;
          //         _deltaBox2 = _bottomOfScreen - _deltaBox1;
          //       }

          //       print(_deltaBox1 + _deltaBox2);
          //       print(_bottomOfScreen);

          //       _init = false;
          //     });
          //   }, 
          //   child: Container(
          //     height: _dividerWidth, 
          //     alignment: Alignment.center, 
          //     child: Text("Box 2 & 3",),
          //   ),
          // ),
          // Expanded(
          //   child: Container(
          //     constraints: BoxConstraints(),
          //     height: _deltaBox3,
          //     child: Container(color: Colors.purple)
          //     // LineChart(
          //     //   mainData(),
          //     // ),
          //   ),
          // ),