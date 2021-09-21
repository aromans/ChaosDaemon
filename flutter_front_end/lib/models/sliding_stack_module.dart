import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';
import 'package:collection/collection.dart';

Color randomColor() {
  return Color.fromARGB(
    255,
    Random().nextInt(255),
    Random().nextInt(255),
    Random().nextInt(255),
  );
}

class SlidingStackModule extends StatefulWidget {
  late SlidingContainer topContainer;
  late SlidingContainer bottomContainer;

  late final SlidingContainer originalBottom;

  late double dividerWidth;
  late double _bottomOfScreen;

  late double totalComponentHeight;

  late ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  late ValueNotifier<bool> topVisible = ValueNotifier<bool>(true);
  late ValueNotifier<bool> sliderVisible = ValueNotifier<bool>(true);
  late ValueNotifier<bool> bottomVisible = ValueNotifier<bool>(false);

  late SlidingStackModule? prev;
  late SlidingStackModule? next;

  static TypeDelegate<double> calculateDeltas = TypeDelegate();

  /// The front most element is the closest to the last element in the stack.
  /// Sorted by (LastElement - ElementIndex)
  static PriorityQueue<int> elementStack = PriorityQueue();

  late Widget slider;

  static int nearEndElementIndex() => elementStack.first;

  SlidingStackModule(this.topContainer, this.bottomContainer, this.dividerWidth,
      this._bottomOfScreen) {
    totalComponentHeight =
        topContainer.height.value + bottomContainer.height.value;
    slider = generateSlider();
    originalBottom = this.bottomContainer;
  }

  void updateWidget() {
    visible.value = !visible.value;
  }

  void resetBottomContainer() {
    this.bottomContainer = this.originalBottom;
    slider = generateSlider();
  }

  void updateBottomContainer(SlidingStackModule module) {
    this.bottomContainer = module.bottomContainer;
    slider = generateSlider();
  }

  Widget generateSlider() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        double testTopHeight, testBottomHeight;

        testTopHeight = topContainer.height.value + details.delta.dy;
        testBottomHeight = bottomContainer.height.value - details.delta.dy;

        if (testTopHeight <= 0.005) {
          topContainer.height.value = 0;
          bottomContainer.height.value = _bottomOfScreen -
              (SlidingStackModule.calculateDeltas()[0]! -
                  topContainer.height.value -
                  bottomContainer.height.value);
        } else if (testBottomHeight <= 0.005) {
          bottomContainer.height.value = 0;
          topContainer.height.value = _bottomOfScreen -
              (SlidingStackModule.calculateDeltas()[0]! -
                  topContainer.height.value -
                  bottomContainer.height.value);
        } else {
          topContainer.height.value = testTopHeight;
          bottomContainer.height.value = testBottomHeight;
        }
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
                    child: Icon(
                  this.topContainer.icon.value,
                  color: Colors.white,
                )),
                TextSpan(
                  text: " & ",
                ),
                WidgetSpan(
                  child: Icon(
                    this.bottomContainer.icon.value,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  State<SlidingStackModule> createState() => _SlidingStackModuleState();
}

class _SlidingStackModuleState extends State<SlidingStackModule> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    return ValueListenableBuilder<bool>(
        valueListenable: widget.visible,
        builder: (BuildContext context, bool value, Widget? child) {
          return Column(
            children: [
              Visibility(
                  maintainState: true,
                  key: ValueKey(widget.topVisible),
                  visible: widget.topVisible.value,
                  child: widget.topContainer),
              Visibility(
                  maintainState: true,
                  key: ValueKey(widget.sliderVisible),
                  visible: widget.sliderVisible.value,
                  child: widget.slider),
              Visibility(
                  maintainState: true,
                  key: ValueKey(widget.bottomVisible),
                  visible: widget.bottomVisible.value,
                  child: widget.bottomContainer),
            ],
          );
        });
  }
}

class SlidingContainer extends StatelessWidget {
  late ValueNotifier<double> height;
  late Color color;
  late Widget widget;
  late ValueNotifier<IconData> icon;

  SlidingContainer(
      {required double height, required IconData icon, required Widget widget}) {
    // if (color == null) {
    //   this.color = randomColor();
    // } else {
    //   this.color = color;
    // }

    this.height = ValueNotifier(height);
    this.icon = ValueNotifier(icon);
    this.widget = widget;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: height,
      builder: (BuildContext context, double value, Widget? child) {
        return Container(
          height: height.value,
          width: double.infinity,
          child: Container(
            child: this.widget,
          ),
        );
      },
    );
  }
}
