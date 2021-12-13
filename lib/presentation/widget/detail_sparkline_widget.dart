import 'dart:math';

import 'package:clean_app/theme/palette.dart';
import 'package:clean_app/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailSparklineWidget extends StatefulWidget {
  final List<double>? sparkline;
  final List<FlSpot>? flSpotList;
  final bool showBarArea;
  final num pricePercentage;

  const DetailSparklineWidget({
    required this.sparkline,
    required this.flSpotList,
    required this.showBarArea,
    required this.pricePercentage,
    Key? key,
  }) : super(key: key);

  @override
  _SparklineWidgetState createState() => _SparklineWidgetState();
}

class _SparklineWidgetState extends State<DetailSparklineWidget> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(),
      swapAnimationCurve: Curves.linear,
    );
  }

  LineChartData mainData() {
    final List<Color> gradientColors = <Color>[
      if (widget.pricePercentage >= 0) Palette.accentBlue else Palette.errorRed,
      if (widget.pricePercentage >= 0) Palette.primary else Palette.lightRed,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (double value) {
          return FlLine(
            color: widget.pricePercentage >= 0
                ? Palette.darkBlue
                : Palette.darkRed,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (double value) {
          return FlLine(
            color: widget.pricePercentage >= 0
                ? const Color(0xff37434d)
                : const Color(0xff4D3737),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          showTitles: false,
          reservedSize: 40,
          getTextStyles: (BuildContext context, double value) =>
              TextStyles.overlay3Bold11,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (BuildContext context, double value) =>
              TextStyles.overlay3Bold11,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '1${'day'.tr()}';
              case 24:
                return '2${'day'.tr()}';
              case 48:
                return '3${'day'.tr()}';
              case 72:
                return '4${'day'.tr()}';
              case 96:
                return '5${'day'.tr()}';
              case 120:
                return '6${'day'.tr()}';
              case 144:
                return '7${'day'.tr()}';
            }
            return '';
          },
          interval: 1,
        ),
        show: true,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: widget.pricePercentage >= 0
                  ? Palette.darkBlue
                  : Palette.darkRed,
              width: 2),
          left: BorderSide(
              color: widget.pricePercentage >= 0
                  ? Palette.darkBlue
                  : Palette.darkRed,
              width: 2),
        ),
      ),
      minX: 0,
      maxX: widget.sparkline?.length.toDouble(),
      minY: widget.sparkline?.reduce(min),
      maxY: widget.sparkline?.reduce(max),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: widget.flSpotList,
          isCurved: false,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: widget.showBarArea,
            colors: gradientColors
                .map((Color color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }
}
