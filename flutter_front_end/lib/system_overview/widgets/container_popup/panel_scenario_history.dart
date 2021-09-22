import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/models/system_container_set.dart';

class PanelScenarioHistory extends StatelessWidget {
  final String containerName;
  PanelScenarioHistory({required this.containerName});

  Widget getScenarioIcon(String outcome) {
    switch (outcome) {
      case 'pass':
        return Icon(
          CupertinoIcons.check_mark_circled,
          color: Colors.blue,
          size: 48,
        );
      case 'heal':
        return Icon(
          CupertinoIcons.plus_circle,
          color: Colors.greenAccent.shade400,
          size: 48,
        );
      case 'fail':
        return Icon(
          CupertinoIcons.xmark_circle,
          color: Colors.redAccent.shade700,
          size: 48,
        );
      default:
        return Icon(CupertinoIcons.flame);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemContainer container = SystemContainerSet.findById(containerName);
    List<String> timeStamps = container.getScenarioHistory().keys.toList();
    List<String> scenarioVals = container.getScenarioHistory().values.toList();
    TextTheme textTheme = Theme.of(context).textTheme;
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          reverse: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 200,
              maxCrossAxisExtent: 110,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 0.5,),
          itemCount: timeStamps.length,
          itemBuilder: (_, i) => RotatedBox(
            quarterTurns: 3,
            child: Card(
              elevation: 5.0,
              shadowColor: Colors.black,
              color: Color.fromARGB(255, 0, 0, 139),
              child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  width: 100,
                  height: 200,
                  // alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                      [
                        Text(
                          timeStamps[i],
                          textAlign: TextAlign.center,
                          style: textTheme.headline1!.copyWith(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2),
                          alignment: Alignment.bottomCenter,
                          child: getScenarioIcon(scenarioVals[i]),
                        ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
