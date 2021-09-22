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
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 100,
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 2),
        itemCount: container.getStats().length,
        itemBuilder: (_, i) => Card(
          elevation: 5.0,
          shadowColor: Colors.black,
          color: Color.fromARGB(255, 0, 0, 139),
          child: Container(
              padding: EdgeInsets.only(top: 10.0),
              width: 100,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                  [
                    Text(
                      statKeys[i],
                      style: textTheme.headline1!
                          .copyWith(color: Colors.white.withOpacity(0.75)),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 7.5),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        statVals[i],
                        style: textTheme.headline1!.copyWith(fontSize: 36),
                      ),
                    ),
                ],
              ),
            ),

        ),
      ),
    );
  }
}
