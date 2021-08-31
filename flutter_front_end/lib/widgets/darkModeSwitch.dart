import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class DarkModeSwitch extends StatefulWidget {
  bool darkModeToggle = false;
  DarkModeSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DarkModeSwitchState();
}

class DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const Icon(CupertinoIcons.sun_max),
          const SizedBox(
            width: 10,
          ),
          CupertinoSwitch(
              value: widget.darkModeToggle,
              onChanged: (bool val) {
                setState(() {
                  widget.darkModeToggle = val;
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
