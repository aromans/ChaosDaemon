import 'package:flutter/material.dart';

class AnimationInfo<T> {
  late T start;
  late T end;
  late Interval timeline;

  AnimationInfo(this.start, this.end, this.timeline);
}