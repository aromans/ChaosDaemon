import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_front_end/models/dark_mode_status.dart';

class DarkModeSwitch extends StatefulWidget {
  DarkModeSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DarkModeSwitchState();
}

class DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);

    return Container(
      child: Row(
        children: [
          const Icon(CupertinoIcons.sun_max),
          const SizedBox(
            width: 10,
          ),
          CupertinoSwitch(
              activeColor: Color.fromARGB(255, 88, 176, 156),
              value: status.darkModeEnabled,
              onChanged: (bool val) {
                setState(() {
                  status.toggle(val);
                });
              }),
          const SizedBox(
            width: 10,
          ),
          const Icon(CupertinoIcons.moon_stars)
        ],
      ),
    );
  }
}
