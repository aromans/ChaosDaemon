import 'package:flutter/material.dart';

class animationInfo<T> {
  late T start;
  late T end;
  late Interval timeline;

  animationInfo(this.start, this.end, this.timeline);
}