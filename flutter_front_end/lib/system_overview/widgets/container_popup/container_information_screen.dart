import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// user-defined
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/graph_filter_widget.dart';

@immutable
class ContainerInformationScreen extends StatefulWidget {
  static const String pageRoute = '/ContainerInformationScreen';
  ContainerInformationScreen();

  @override
  State<StatefulWidget> createState() => ContainerInformationScreenState();
}

class ContainerInformationScreenState
    extends State<ContainerInformationScreen> {
  @override
  Widget build(BuildContext context) {
    SystemContainer container = Provider.of<SystemContainer>(context);

    return Scaffold(
      body: Text(container.id),
    );
  }
}
