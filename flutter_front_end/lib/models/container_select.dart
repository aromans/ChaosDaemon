import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';

class SelectedContainer extends ChangeNotifier {
  SystemContainer? selectedContainer;

  void select(SystemContainer container) {
    selectedContainer = container;

    notifyListeners();
  }
}