import 'package:flutter/material.dart';
import 'package:flutter_front_end/system_overview/models/system_container.dart';
import 'package:flutter_front_end/system_overview/models/system_container_set.dart';

class PanelStatWidget extends StatelessWidget {
  final String containerName;
  PanelStatWidget({required this.containerName});

  int calcNumOfCols(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 500) {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemContainer container = SystemContainerSet.findById(containerName);
    List<String> statKeys = container.getStats().keys.toList();
    List<String> statVals = container.getStats().values.toList();
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: calcNumOfCols(context),
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 2),
        itemCount: container.getStats().length,
        itemBuilder: (_, i) => Card(
          elevation: 5.0,
          shadowColor: Colors.black,
          color: Color.fromARGB(255, 0, 0, 139),
          child: GridTile(
            header: Container(
              padding: EdgeInsets.only(top: 10.0),
              alignment: Alignment.topCenter,
              child: Text(
                statKeys[i],
                style: textTheme.headline1!
                    .copyWith(color: Colors.white.withOpacity(0.75)),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(bottom: 7.5),
              alignment: Alignment.bottomCenter,
              child: Text(
                statVals[i],
                style: textTheme.headline1!.copyWith(fontSize: 36),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
