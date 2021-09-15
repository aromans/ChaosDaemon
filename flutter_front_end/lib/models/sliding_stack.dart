import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

Delegate updateContainer = Delegate();

Color randomColor() {
  return Color.fromARGB(
    255,
    Random().nextInt(255),
    Random().nextInt(255),
    Random().nextInt(255),
  );
}

class SelectedIcon {
  Icon icon;
  bool isSelected;

  SelectedIcon(this.icon, this.isSelected);
}

class SlidingContainer extends StatelessWidget {
  late double height;
  late Color color;
  late Icon icon;

  SlidingContainer(this.height, this.icon, {Color? color = null}) {
    if (color == null) {
      this.color = randomColor();
    } else {
      this.color = color;
    }
    _controller.add(height);
  }

  StreamController<double> _controller = StreamController<double>();

  void updateHeight(double height) {
    height = height;
    _controller.add(height);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _controller.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Container(
          height: snapshot.data,
          width: double.infinity,
          child: Container(
            color: this.color,
          ),
        );
      },
    );
  }
}

class SliderPair {
  late Widget slider;
  late SlidingContainer topContainer;
  late Function dragUpdate;

  late SlidingContainer bottomContainer;

  SliderPair(this.topContainer, this.bottomContainer, this.dragUpdate, double dividerWidth) {
    updateBottomContainer(this.bottomContainer, dividerWidth);
  }

  void updateBottomContainer(SlidingContainer container, double dividerWidth) {
    this.bottomContainer = container;

    slider = GestureDetector(
      onVerticalDragUpdate: (details) {
        dragUpdate(details);
      },
      child: Container(
        color: Color.fromARGB(0, 0, 0, 0),
        height: dividerWidth,
        width: double.infinity,
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(topContainer.icon.icon, color: Colors.white,)
              ),
              TextSpan(
                text: " & ",
              ),
              WidgetSpan(
                child: Icon(bottomContainer.icon.icon, color: Colors.white,),
              ),
            ],
          ),
        )
      ),
    );
  }

  List<Widget> build() {
    return <Widget> [topContainer, slider];
  }
}

class SlidingStack extends StatefulWidget {
  final Map<Icon, Widget> widgetMap;
  final double height, width;
  SlidingStack({
    required this.widgetMap,
    required this.width,
    required this.height,
  });

  @override
  State<StatefulWidget> createState() => SlidingStackState();
}

class SlidingStackState extends State<SlidingStack> {
  late double _maxHeight, _minWidth;
  late double _screenHeight, _screenWidth;
  late double _dividerWidth, _iconColumnWidth;
  late double _bottomOfScreen, _barHeight;
  
  late ToggleButtons iconList;

  late List<Icon> widgetDisplay = [];
  late List<double> _widgetDeltas = [];

  List<bool> buttonsSelected = [];

  StreamController<List<Widget>> _controller = StreamController<List<Widget>>();

  List<bool> _panelsToRender = [];
  late List<SliderPair> _slidingPanelView = [];
  late List<SliderPair> _renderPanelView = [];

  late List<SlidingContainer> _slidingContainers = [];

  bool _init = true;

  @override
  initState() {
    if (widget.widgetMap.length <= 1) {
      throw ErrorDescription(
          "Sliding Stack Widget needs at minimum two widgets.");
    }
    super.initState();

    this.widgetDisplay = widget.widgetMap.keys.toList();
    _widgetDeltas = [];
    _slidingPanelView = [];
    _slidingContainers = [];

    _screenHeight = widget.height;
    _screenWidth = widget.width;

    _dividerWidth = _screenWidth * 0.05;
    _maxHeight = _screenHeight * 0.95;
    _minWidth = _screenWidth * 0;
    _iconColumnWidth = _screenWidth * 0.0;
    _barHeight = _screenHeight - _maxHeight;
    _bottomOfScreen =
        _screenHeight - _barHeight - (widget.widgetMap.length) * _dividerWidth;

    double _height;
    for (int i = 0; i < widget.widgetMap.length; i++) {
      if (i != widget.widgetMap.length - 1) {
        _height = _maxHeight / widget.widgetMap.length - _dividerWidth;
        _widgetDeltas.add(_height);
      } else {
        _height = _maxHeight / widget.widgetMap.length;
        _widgetDeltas.add(_height);
      }
    }
    buttonsSelected = List.generate(widget.widgetMap.length, (index) => true);

    initWidgetSliders();
  }

  double calculateDeltas(int j) {
    double total = 0;

    for (int i = 0; i < this._widgetDeltas.length; i++) {
      if (i != j) total += this._widgetDeltas[i];
    }
    return total;
  }

  void initWidgetSliders() {
    for (int i = 1; i < this.widgetDisplay.length; i++) {
      Icon iconOne = this.widgetDisplay[i - 1];
      Icon iconTwo = this.widgetDisplay[i];

      Widget widgetOne = widget.widgetMap[iconOne]!;
      Widget widgetTwo = widget.widgetMap[iconTwo]!;

      SlidingContainer boxOne;

      if (i == 1) {
        boxOne = SlidingContainer(_widgetDeltas[i - 1], iconOne);
        _slidingContainers.add(boxOne);
      } else {
        boxOne = _slidingContainers[i-1];
      }

      Function dragUpdate = (DragUpdateDetails details) {
        setState(() {
          _widgetDeltas[i - 1] += details.delta.dy;
          _widgetDeltas[i] -= details.delta.dy;
          double delta_one = calculateDeltas(i - 1);
          double delta_two = calculateDeltas(i);

          if (delta_one >= _bottomOfScreen) {
            _widgetDeltas[i - 1] = 0;
            _widgetDeltas[i] = _bottomOfScreen - delta_two + details.delta.dy;
          }

          if (delta_two >= _bottomOfScreen) {
            _widgetDeltas[i] = 0;
            _widgetDeltas[i - 1] =
                _bottomOfScreen - delta_one - details.delta.dy;
          }
        });
      };

      SlidingContainer boxTwo = SlidingContainer(_widgetDeltas[i], iconTwo);

      SliderPair sliderPair = SliderPair(boxOne, boxTwo, dragUpdate, _dividerWidth);

      _slidingPanelView.add(sliderPair);
      _slidingContainers.add(boxTwo);
    }

    _renderPanelView = _slidingPanelView;
    _init = false;
  }

  List<Widget> checkPanelRenders() {
    List<Widget> renders = [];
    List<SliderPair> renderCopy = _renderPanelView;
    bool isDirty = false;
    for (int i = 0; i < this.widgetDisplay.length; i++) {
      if (buttonsSelected[i]) continue;

      isDirty = true;
      for (int j = 0; j < _renderPanelView.length; j++) {
        if (j == i) {
          renderCopy[j-1].bottomContainer = renderCopy[j].bottomContainer;
          
          Function dragUpdate = (DragUpdateDetails details) {
            setState(() {
              _widgetDeltas[i - 1] += details.delta.dy;
              _widgetDeltas[i + 1] -= details.delta.dy;
              double delta_one = calculateDeltas(i - 1);
              double delta_two = calculateDeltas(i + 1);

              if (delta_one >= _bottomOfScreen) {
                _widgetDeltas[i - 1] = 0;
                _widgetDeltas[i + 1] = _bottomOfScreen - delta_two + details.delta.dy;
              }

              if (delta_two >= _bottomOfScreen) {
                _widgetDeltas[i + 1] = 0;
                _widgetDeltas[i - 1] =
                    _bottomOfScreen - delta_one - details.delta.dy;
              }
            });
          };

        } else {
          renderCopy.add(_renderPanelView[j]);
        }
      }
    }
    if (isDirty) _renderPanelView = renderCopy;

    for (int i = 0; i < _renderPanelView.length; i++) {
      var buildValues = _renderPanelView[i].build();

      renders.add(buildValues[0]);
      renders.add(buildValues[1]);

      if (i + 1 >= _renderPanelView.length) {
        renders.add(_renderPanelView[i].bottomContainer);
      }
    }

     return renders;
  }

  List<Widget> calculatePanels(List<Widget> renders) {
    for (int i = 1; i < renders.length; i += 2) {
      int j = (i * 0.5).ceil();

      int indexOne = i - j;
      int indexTwo = i - (j - 1);

      (renders[i - 1] as SlidingContainer).updateHeight(
          _widgetDeltas[indexOne]);

      (renders[i + 1] as SlidingContainer).updateHeight(
          _widgetDeltas[indexTwo]); 
    }

    print(widget.widgetMap.keys.length);
    print(buttonsSelected.length);

    iconList = ToggleButtons(
      direction: Axis.vertical,
      color: Colors.white,
      selectedColor: Color.fromARGB(255, 88, 176, 156),
      children: widget.widgetMap.keys.toList(),
      isSelected: buttonsSelected,
      onPressed: (int index) {
        setState(() {
          buttonsSelected[index] = !buttonsSelected[index];
          
        });
      },
    );

    return renders;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renders = checkPanelRenders();
    renders = calculatePanels(renders);

    return Row(
      children: [
        Container(
            alignment: Alignment.center,
            height: _maxHeight,
            width: _screenWidth * 0.06,
            child: iconList,//Column(mainAxisAlignment: MainAxisAlignment.center, children: iconList),
        ),
        Expanded(
          child: Container(
            height: _maxHeight,
            width: _screenWidth,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 61),
            ),
            child: StreamBuilder<Object>(
              stream: _controller.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Column(
                  children: renders,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}