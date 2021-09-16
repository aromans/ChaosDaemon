import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_front_end/models/delegate.dart';

class EventListQueue<T> extends ListQueue<T> {
  Delegate eventDelegate = Delegate();

  operator +(Function fn) => eventDelegate + fn;
  operator -(Function fn) => eventDelegate - fn;

  @override
  void add(T value) {
    super.add(value);
    eventDelegate();
  }
}
