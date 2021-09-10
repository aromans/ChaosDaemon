import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_front_end/widgets/panel_icon_widget.dart';
import 'package:provider/provider.dart';

// CHARTS
//import 'package:flutter_echarts/flutter_echarts.dart';

/* OURS */
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'widgets/container_card/system_container_widget.dart';
import 'models/system_container_set.dart';
import 'package:flutter_front_end/widgets/expandable_panel_horz.dart';

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
  Timer? timer;

  StreamController<String> controller = StreamController<String>();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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

    Map<String, PanelIconWidget> testWidgetMap = {};

    bool showAvg = false;

    controller.onListen = () {
      if (controller.hasListener) {
        print("HELLO, ITSM E");
      }
    };

    Widget obj = Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          color: Color(0xff232d37)),
      child: Padding(
        padding:
            const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(
          mainData(),
        ),
      ),
    );

    PanelIconWidget barChart = PanelIconWidget(
      name: 'Bar Chart',
      icon: Icon(CupertinoIcons.graph_circle),
      widget: obj,
    );

    PanelIconWidget barChart2 = PanelIconWidget(
      name: 'Bar Chart',
      icon: Icon(CupertinoIcons.chart_bar),
      widget: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            color: Color(0xff232d37)),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: LineChart(
            avgData(),
          ),
        ),
      ),
    );

    testWidgetMap['Bar Chart 2'] = barChart2;
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

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

List<FlSpot> spotListData = [
  FlSpot(0, Random().nextDouble() * 3),
  FlSpot(2.6, Random().nextDouble() * 2),
  FlSpot(4.9, Random().nextDouble() * 5),
  FlSpot(6.8, Random().nextDouble() * 3.1),
  FlSpot(8, Random().nextDouble() * 4),
  FlSpot(9.5, Random().nextDouble() * 3),
  FlSpot(11, Random().nextDouble() * 4),
];

List<FlSpot> avgListData = [
  FlSpot(0, 3.44),
  FlSpot(2.6, 3.44),
  FlSpot(4.9, 3.44),
  FlSpot(6.8, 3.44),
  FlSpot(8, 3.44),
  FlSpot(9.5, 3.44),
  FlSpot(11, 3.44),
];

double xPos = 11;

List<FlSpot> addData() {
  FlSpot chosen = spotListData[Random().nextInt(spotListData.length)];
  xPos += 0.1 + Random().nextDouble() * 2;
  spotListData.add(FlSpot(xPos, chosen.y));
  avgListData.add(FlSpot(xPos, 3.44));

  return spotListData;
}

LineChartData mainData() {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 32,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 75, //spotListData[spotListData.length - 1].x + 5,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: addData(),
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}

LineChartData avgData() {
  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          return '';
        },
        margin: 8,
        interval: 1,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 32,
        interval: 1,
        margin: 12,
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 75, //spotListData[spotListData.length - 1].x + 5,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: avgListData,
        isCurved: true,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!,
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!,
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!
              .withOpacity(0.1),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!
              .withOpacity(0.1),
        ]),
      ),
    ],
  );
}
