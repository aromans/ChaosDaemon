import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

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

  late double dividerWidth;
  late double _bottomOfScreen;

  late double totalComponentHeight;

  late bool isLastElement;

  late ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  static TypeDelegate<double> calculateDeltas = TypeDelegate();

  late Widget slider;

  SlidingStackModule(this.topContainer, this.bottomContainer, this.dividerWidth,
      this._bottomOfScreen, this.isLastElement,
      {Key? key})
      : super(key: key) {
    totalComponentHeight = topContainer.height + bottomContainer.height;
    updateBottomContainer(this.bottomContainer);
  }

  void updateBottomContainer(SlidingContainer bottom) {
    this.bottomContainer = bottom;
    slider = generateSlider();
  }

  Widget generateSlider() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        topContainer.height += details.delta.dy;
        bottomContainer.height -= details.delta.dy;
        if (topContainer.height <= 0.05) {
          topContainer.height = 0;
          bottomContainer.height = _bottomOfScreen -
              (SlidingStackModule.calculateDeltas()[0]! -
                  topContainer.height -
                  bottomContainer.height) -
              details.delta.dy;
        } else if (bottomContainer.height <= 0.05) {
          bottomContainer.height = 0;
          topContainer.height = _bottomOfScreen -
              (SlidingStackModule.calculateDeltas()[0]! -
                  topContainer.height -
                  bottomContainer.height) -
              details.delta.dy;
        }
        topContainer.updateHeight();
        bottomContainer.updateHeight();
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
                  topContainer.icon.icon,
                  color: Colors.white,
                )),
                TextSpan(
                  text: " & ",
                ),
                WidgetSpan(
                  child: Icon(
                    bottomContainer.icon.icon,
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
          if (widget.isLastElement) {
            return Visibility(
              key: ValueKey(widget.visible),
              visible: widget.visible.value,
              child: Column(
                children: [
                  widget.topContainer,
                  widget.slider,
                  widget.bottomContainer
                ],
              ),
            );
          } else {
            return Visibility(
              key: ValueKey(widget.visible),
              visible: widget.visible.value,
              child: Column(
                children: [widget.topContainer, widget.slider],
              ),
            );
          }
        });
  }
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

  void updateHeight() {
    height = height.abs();
    if (height < 0.1) height = 0;
    _controller.add(height);
  }

  @override
  Widget build(BuildContext context) {
    _controller.close();
    _controller = StreamController<double>();

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
