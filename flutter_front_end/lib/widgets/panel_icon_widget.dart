import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/delegate.dart';

class PanelIconWidget {
  String name;
  Icon icon;
  Widget widget;

  late Delegate update;

  PanelIconWidget({
    required this.name,
    required this.icon,
    required this.widget,
  }) {
    update = Delegate();
  }

  void Update() {
    update();
  }
}
