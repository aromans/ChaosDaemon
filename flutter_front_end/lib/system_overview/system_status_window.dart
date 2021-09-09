import 'dart:ui';
import 'package:charts_flutter/flutter.dart' hide Color;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_front_end/widgets/panel_icon_widget.dart';
import 'package:provider/provider.dart';

/* OURS */
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'widgets/container_card/system_container_widget.dart';
import 'models/system_container_set.dart';
import 'package:flutter_front_end/widgets/expandable_panel_horz.dart';

class DataPoint {
  final int x;
  final int y;

  DataPoint(this.x, this.y);
}

class TestLineChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestLineChartState();
  }
}

class _TestLineChartState extends State<TestLineChart> {
  
  
  @override
  Widget build(BuildContext context) {}
}

//ignore: must_be_immutable
class SystemStatusWindow extends StatefulWidget {
  SystemStatusWindow({Key? key}) : super(key: key);

  int numOfCols = 3;

  @override
  State<StatefulWidget> createState() {
    return _SystemStatusWindowState();
  }
}

class _SystemStatusWindowState extends State<SystemStatusWindow> {
  @override
  Widget build(BuildContext context) {
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    int numOfCols = 3;

    BoxDecoration systemTopPanelDecoration = BoxDecoration(
      color: Color.fromARGB(255, 19, 21, 22),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );

    List<Series<DataPoint, int>> _createLineSampleData() {
      final data = [
        new DataPoint(0, 5),
        new DataPoint(1, 25),
        new DataPoint(2, 100),
        new DataPoint(3, 75),
      ];
      return [
        new Series<DataPoint, int>(
          id: 'Random',
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          domainFn: (DataPoint point, _) => point.x,
          measureFn: (DataPoint point, _) => point.y,
          data: data,
        )
      ];
    }

    List<Series<DataPoint, String>> _createBarSampleData() {
      final data = [
        new DataPoint(0, 5),
        new DataPoint(1, 25),
        new DataPoint(2, 100),
        new DataPoint(3, 75),
      ];
      return [
        new Series<DataPoint, String>(
          id: 'Random',
          colorFn: (_, __) => MaterialPalette.red.shadeDefault,
          domainFn: (DataPoint point, _) => point.x.toString(),
          measureFn: (DataPoint point, _) => point.y,
          data: data,
        )
      ];
    }

    LineChart testLineChart = LineChart(_createLineSampleData());
    BarChart testBarChart = BarChart(_createBarSampleData());
    Map<String, PanelIconWidget> testWidgetMap = {};

    PanelIconWidget lineChart = PanelIconWidget(
      name: 'Line Chart',
      icon: Icon(CupertinoIcons.graph_circle),
      widget: testLineChart,
    );

    PanelIconWidget barChart = PanelIconWidget(
      name: 'Bar Chart',
      icon: Icon(CupertinoIcons.chart_bar),
      widget: testBarChart,
    );

    testWidgetMap['Line Chart'] = lineChart;
    testWidgetMap['Bar Chart'] = barChart;

    // if (screenWidth < 718) {
    //   numOfCols = 1;
    // } else if (screenWidth >= 718 && screenWidth < 1036) {
    //   numOfCols = 2;
    // } else if (screenWidth >= 1036 && screenWidth < 1354) {
    //   numOfCols = 3;
    // } else if (screenWidth >= 1354 && screenWidth < 1672) {
    //   numOfCols = 4;
    // } else if (screenWidth >= 1672 && screenWidth < 1990) {
    //   numOfCols = 5;
    // } else {
    //   numOfCols = 6;
    // }

    // TODO: Add to UTILS class
    BoxDecoration ContainerBoxStyle(
        Color color, double radius, double borderWidth) {
      return BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(
            width: borderWidth,
            color: color,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 20).withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ]);
    }

    return Scaffold(
      backgroundColor: status.darkModeEnabled
          ? Color.fromARGB(255, 0, 0, 61)
          : Color.fromARGB(255, 238, 240, 235),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* TOP SYSTEM OVERVIEW */
          Container(
            margin: EdgeInsets.all(20),
            child: ExpandablePanelHorz(
              topSide: true,
              maxHeight: 300,
              panelDecor: ContainerBoxStyle(
                Color.fromARGB(255, 46, 40, 54),
                30.0,
                3.0,
              ),
              iconWidgets: testWidgetMap,
            ),
          ),

          /* CONTAINER GRID */
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: ContainerGrid(numOfCols: numOfCols),
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerGrid extends StatelessWidget {
  const ContainerGrid({
    Key? key,
    required this.numOfCols,
  }) : super(key: key);

  final int numOfCols;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numOfCols,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 2),
      itemBuilder: (_, i) => SystemContainerWidget(
        containerName: SystemContainerSet.items[i].id,
        creationDate: SystemContainerSet.items[i].creationDate,
      ),
      itemCount: SystemContainerSet.itemCount,
    );
  }
}
