import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PanelGraph extends StatelessWidget {
  PanelGraph();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(),
    );
  }
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

double xPos = 11;

List<FlSpot> addData() {
  FlSpot chosen = spotListData[Random().nextInt(spotListData.length)];
  xPos += 0.1 + Random().nextDouble() * 2;
  spotListData.add(FlSpot(xPos, chosen.y));

  return spotListData;
}
