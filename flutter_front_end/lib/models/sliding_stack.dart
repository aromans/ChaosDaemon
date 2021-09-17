import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/sliding_stack_module.dart';

class SelectedIcon {
  Icon icon;
  bool isSelected;

  SelectedIcon(this.icon, this.isSelected);
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
  late double _maxHeight;
  late double _screenHeight, _screenWidth;
  late double _dividerWidth;
  late double _bottomOfScreen, _barHeight;
  late double slidingStackHeight;
  late ToggleButtons iconList;
  late List<Icon> widgetDisplay = [];
  late List<double> _widgetDeltas = [];
  late List<SlidingStackModule> _slidingStacks = [];
  List<bool> buttonsSelected = [];

  StreamController<List<Widget>> _controller = StreamController<List<Widget>>();

  @override
  initState() {
    if (widget.widgetMap.length <= 1) {
      throw ErrorDescription(
          "Sliding Stack Widget needs at minimum two widgets.");
    }
    super.initState();

    this.widgetDisplay = widget.widgetMap.keys.toList();
    _widgetDeltas = [];

    _screenHeight = widget.height;
    _screenWidth = widget.width;

    _dividerWidth = _screenWidth * 0.05;
    _maxHeight = _screenHeight * 0.95;
    _barHeight = _screenHeight - _maxHeight;
    _bottomOfScreen =
        _screenHeight - _barHeight - (widget.widgetMap.length) * _dividerWidth;

    slidingStackHeight = 0;

    double _height;
    for (int i = 0; i < widget.widgetMap.length; i++) {
      _height = _maxHeight / widget.widgetMap.length - _dividerWidth;
      slidingStackHeight += _height;
      _widgetDeltas.add(_height);
    }

    _bottomOfScreen = _bottomOfScreen.floorToDouble();

    buttonsSelected = List.generate(widget.widgetMap.length, (index) => true);

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

    initWidgetSliders();
  }

  void initWidgetSliders() {
    SlidingContainer? prevContainer = null;

    for (int i = 1; i < this.widgetDisplay.length; i++) {
      Icon iconOne = this.widgetDisplay[i - 1];
      Icon iconTwo = this.widgetDisplay[i];

      Widget widgetOne = widget.widgetMap[iconOne]!;
      Widget widgetTwo = widget.widgetMap[iconTwo]!;

      SlidingContainer topContainer;

      if (prevContainer == null) {
        topContainer = SlidingContainer(_widgetDeltas[i - 1], iconOne);
      } else {
        topContainer = prevContainer;
      }

      SlidingContainer bottomContainer =
          SlidingContainer(_widgetDeltas[i], iconTwo);

      SlidingStackModule stackComponent = SlidingStackModule(
          topContainer, bottomContainer, _dividerWidth, _bottomOfScreen);

      _slidingStacks.add(stackComponent);

      if (i > 1) {
        _slidingStacks[i - 2].lowerNeighbor = _slidingStacks[i - 1];
      }

      prevContainer = bottomContainer;
    }

    SlidingStackModule.calculateDeltas + calculateDeltas;
  }

  double calculateDeltas() {
    double total = 0;

    for (int i = 0; i < _slidingStacks.length; i++) {
      total += _slidingStacks[i].topContainer.height;
    }

    total += _slidingStacks[_slidingStacks.length - 1].bottomContainer.height;

    return total.floorToDouble();
  }

  void recalculateHeight() {
    int totalVisible = 0;
    buttonsSelected.forEach((element) {
      if (element) totalVisible++;
    });
    double _height = _maxHeight / totalVisible - _dividerWidth;
    slidingStackHeight = 0;
    for (int i = 0; i < buttonsSelected.length; i++) {
      if (buttonsSelected[i]) {
        slidingStackHeight += _height;

        if (i + 1 >= _slidingStacks.length) {
          _slidingStacks[i - 1].topContainer.height = _height;
          _slidingStacks[i - 1].bottomContainer.height = _height;

          _slidingStacks[i - 1].topContainer.updateHeight();
          _slidingStacks[i - 1].bottomContainer.updateHeight();
        } else {
          _slidingStacks[i].topContainer.height = _height;
          _slidingStacks[i].bottomContainer.height = _height;

          _slidingStacks[i].topContainer.updateHeight();
          _slidingStacks[i].bottomContainer.updateHeight();
        }
      }
    }
  }

  void setStackVisibility(int i, bool value) {
    if (i > 0 && i + 1 <= _slidingStacks.length) {
      _slidingStacks[i - 1]
          .updateBottomContainer(_slidingStacks[i].topContainer);
    }
    if (i >= _slidingStacks.length) {
      _slidingStacks[i - 1].bottomVisible.value = value;
      _slidingStacks[i - 1].updateWidget();
    } else {
      _slidingStacks[i].topVisible.value = value;
      _slidingStacks[i].sliderVisible.value = value;
      _slidingStacks[i].updateWidget();
    }
  }

  void removedPanelsCheck() {
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

    for (int i = 0; i < buttonsSelected.length; i++) {
      if (buttonsSelected[i]) {
        setStackVisibility(i, true);
        continue;
      }
      setStackVisibility(i, false);
    }
    recalculateHeight();
  }

  @override
  Widget build(BuildContext context) {
    removedPanelsCheck();

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: _maxHeight,
          width: _screenWidth * 0.06,
          child: iconList,
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
                  children: _slidingStacks,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
