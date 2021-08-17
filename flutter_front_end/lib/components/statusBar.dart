import 'package:flutter/material.dart';

class statusBar extends StatelessWidget {
  String serverStatus = "OK";
  String daemonStatus = "OK";

  statusBar(this.serverStatus, this.daemonStatus) {}

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
    return Container(
      height: 35,
      child: BottomAppBar(
        color: Colors.black,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: <Widget>[
                Text("Server Connection Status: ", style: labelStyle),
                Text("${serverStatus}", style: statusStyle(serverStatus)),
                Text("\t\t\t|\t\t\t", style: labelStyle),
                Text("\tDaemon Connection Status: ", style: labelStyle),
                Text("${daemonStatus}", style: statusStyle(daemonStatus)),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  tooltip: 'Love Me',
                )
              ],
            )),
      ),
    );
  }
}
