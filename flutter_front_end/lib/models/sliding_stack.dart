import 'dart:async';
import 'dart:collection';
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

  late int displayedStacks = 0;

  StreamController<String> _controller = StreamController<String>();

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

    displayedStacks = widget.widgetMap.length;

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

    SlidingStackModule? parent = null;
    SlidingStackModule? child = null;

    for (int i = 1; i < this.widgetDisplay.length; i++) {
      Icon iconOne = this.widgetDisplay[i - 1];
      Icon iconTwo = this.widgetDisplay[i];

      Widget widgetOne = widget.widgetMap[iconOne]!;
      Widget widgetTwo = widget.widgetMap[iconTwo]!;

      SlidingContainer topContainer;

      if (prevContainer == null) {
        topContainer =
            SlidingContainer(height: _widgetDeltas[i - 1], icon: iconOne.icon!);
      } else {
        topContainer = prevContainer;
      }

      SlidingContainer bottomContainer =
          SlidingContainer(height: _widgetDeltas[i], icon: iconTwo.icon!);

      SlidingStackModule stackComponent = SlidingStackModule(
          topContainer, bottomContainer, _dividerWidth, _bottomOfScreen);

      if (i + 1 >= this.widgetDisplay.length) {
        stackComponent.bottomVisible.value = true;
      }

      _slidingStacks.add(stackComponent);

      prevContainer = bottomContainer;
    }

    int lastElement = _slidingStacks.length;

    SlidingStackModule.elementStack.add(lastElement - 0);

    for (int i = 1; i < _slidingStacks.length; i++) {
      _slidingStacks[i - 1].next = _slidingStacks[i];
      _slidingStacks[i].prev = _slidingStacks[i - 1];

      if (i != lastElement) {
        SlidingStackModule.elementStack.add(lastElement - i);
      }
    }

    _slidingStacks[0].prev = _slidingStacks[_slidingStacks.length - 1];
    _slidingStacks[_slidingStacks.length - 1].next = _slidingStacks[0];

    SlidingStackModule.calculateDeltas + calculateDeltas;
  }

  double calculateDeltas() {
    double total = 0;

    for (int i = 0; i < _slidingStacks.length; i++) {
      if (buttonsSelected[i])
        total += _slidingStacks[i].topContainer.height.value;
    }

    if (buttonsSelected[buttonsSelected.length - 1])
      total += _slidingStacks[_slidingStacks.length - 1]
          .bottomContainer
          .height
          .value;

    return total.floorToDouble();
  }

  void recalculateHeight() {
    double _height = _maxHeight / displayedStacks - _dividerWidth;
    slidingStackHeight = 0;
    for (int i = 0; i < buttonsSelected.length; i++) {
      if (buttonsSelected[i]) {
        slidingStackHeight += _height;

        if (i + 1 >= _slidingStacks.length) {
          _slidingStacks[i - 1].topContainer.height.value = _height;
          _slidingStacks[i - 1].bottomContainer.height.value = _height;
        } else {
          _slidingStacks[i].topContainer.height.value = _height;
          _slidingStacks[i].bottomContainer.height.value = _height;
        }
      }
    }
  }

  void setStackVisibility(int i, bool value) {
    if (i > 0 && i + 1 <= _slidingStacks.length) {
      if (!value)
        _slidingStacks[i - 1].updateBottomContainer(_slidingStacks[i]);
      else {
        _slidingStacks[i - 1].resetBottomContainer();
      }
    }
    if (i >= _slidingStacks.length) {
      _slidingStacks[i - 1].bottomVisible.value = value;
      _slidingStacks[i - 1].updateWidget();
    } else {
      _slidingStacks[i].topVisible.value = value;
      _slidingStacks[i].updateWidget();
    }
  }

  void validateSliderVisibility(int index) {
    // If the element selected was the last element in the stack
    if (index >= _slidingStacks.length) {
      _slidingStacks[index - 1].sliderVisible.value =
          _slidingStacks[index - 1].bottomVisible.value &&
              _slidingStacks[index - 1].topVisible.value;

      // Grab the element closest to the last element
      int lastIndex =
          _slidingStacks.length - SlidingStackModule.nearEndElementIndex();

      // Determine if this last element needs its slider value disabled or enabled
      bool checkTwo = (_slidingStacks[lastIndex].topVisible.value &&
          !_slidingStacks[index - 1].bottomVisible.value);

      if (checkTwo) {
        _slidingStacks[lastIndex].sliderVisible.value = false;
        _slidingStacks[lastIndex].updateWidget();
      } else if (_slidingStacks[lastIndex].topVisible.value) {
        _slidingStacks[lastIndex].sliderVisible.value = true;
        _slidingStacks[lastIndex].updateWidget();
      }

      return;
    }
    // If the element is the first element in the stack
    else if (index == 0) {
      _slidingStacks[index].sliderVisible.value =
          _slidingStacks[index].topVisible.value;

      bool checkTwo = (!_slidingStacks[index].bottomVisible.value ||
          !_slidingStacks[index + 1].topVisible.value);

      if (checkTwo) {
        _slidingStacks[index].sliderVisible.value = false;
      }

      if (_slidingStacks[index].topVisible.value) {
        _slidingStacks[index].sliderVisible.value = true;
      }
      return;
    }

    // For all other elements in the stack
    bool checkTwo = (!_slidingStacks[index - 1].bottomVisible.value ||
        !_slidingStacks[index - 1].topVisible.value);

    if (checkTwo) {
      _slidingStacks[index].sliderVisible.value = false;
      // If this element was in the stack, remove it
      if (SlidingStackModule.elementStack
          .contains((_slidingStacks.length - index))) {
        SlidingStackModule.elementStack.remove((_slidingStacks.length - index));
      }
    }

    if (_slidingStacks[index].topVisible.value) {
      _slidingStacks[index].sliderVisible.value = true;
      // Re-add the element to the stack
      SlidingStackModule.elementStack.add((_slidingStacks.length - index));
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

          if (buttonsSelected[index]) {
            displayedStacks++;
            setStackVisibility(index, true);
          } else {
            displayedStacks--;
            setStackVisibility(index, false);
          }
          validateSliderVisibility(index);
          recalculateHeight();
        });
      },
    );
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
