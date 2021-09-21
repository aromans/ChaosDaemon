import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_list_item_widget.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_model.dart';
import 'package:flutter_front_end/system_overview/widgets/container_popup/log_set.dart';

class LogWidget extends StatefulWidget {
  @override
  _LogWidgetState createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> {
  late List<Log> logList = [];

  late List<Log> filteredLogList = [];

  @override
  initState() {
    super.initState();
    logList = LogSet.generate();

    filteredLogList = logList;
  }

  void filterLogList(String key) {
    setState(() {
      if (key.isEmpty) {
        filteredLogList = logList;
        filteredLogList.forEach((element) {element.highlightedSection = null;});
        return;
      }
      
      var newList = logList.where((element) => element.body.contains(key)).toList();
      newList.forEach((element) {element.highlightedSection = key;});
      filteredLogList = newList;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.075,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.060,
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  onChanged: filterLogList,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Color.fromARGB(255, 88, 176, 156),
                  cursorWidth: 3.0,
                  cursorHeight: 30.0,
                  cursorRadius: Radius.circular(1.0),
                  obscureText: false,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelText: '\u{1F50D} Search ...',
                    labelStyle: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                  ),
                ),
              ),
              Icon(CupertinoIcons.clock, color: Colors.white,),
              Icon(CupertinoIcons.exclamationmark, color: Colors.red,),
              Icon(CupertinoIcons.gear, color: Colors.green,),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 0, 0, 61),
            height: MediaQuery.of(context).size.height * 0.90,
            alignment: Alignment.topLeft,
            child: ListView.builder(
              padding: EdgeInsets.only(
                left: 1.0,
                right: 1.0,
              ),
              itemCount: filteredLogList.length,
              itemBuilder: (ctx, i) => LogListItem(
                log: filteredLogList[i],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
