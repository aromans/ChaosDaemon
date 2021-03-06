import 'package:flutter/material.dart';

import 'dark_mode_switch.dart';

import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class StatusBar extends StatelessWidget {
  String serverStatus = "OK";
  String daemonStatus = "OK";

  StatusBar(this.serverStatus, this.daemonStatus) {}

  TextStyle labelStyle = TextStyle(color: Colors.white);

  TextStyle statusStyle(String status) {
    switch (status) {
      case "OK":
        return TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
      default:
        return TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);
    return Container(
      height: 35,
      child: BottomAppBar(
        //color: Color.fromARGB(255, 54, 49, 48),
        color: status.darkModeEnabled
            ? Color.fromARGB(255, 19, 21, 22)
            : Color.fromARGB(255, 45, 46, 46),
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10)),
                Text("Server Connection Status: ", style: labelStyle),
                Text("${serverStatus}", style: statusStyle(serverStatus)),
                Text("\t\t\t|\t\t\t", style: labelStyle),
                Text("\tDaemon Connection Status: ", style: labelStyle),
                Text("${daemonStatus}", style: statusStyle(daemonStatus)),
                const Spacer(),
                DarkModeSwitch()
              ],
            )),
      ),
    );
  }
}
