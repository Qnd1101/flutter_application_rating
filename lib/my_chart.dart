import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartData {
  static late List<String> days;
  static late List<double> ratings;
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 5,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.amber,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    text = ChartData.days[value.toInt()];
    // switch (value.toInt()) {
    //   case 0:
    //     text = 'Mn';
    //     break;
    //   case 1:
    //     text = 'Te';
    //     break;
    //   case 2:
    //     text = 'Wd';
    //     break;
    //   case 3:
    //     text = 'Tu';
    //     break;
    //   case 4:
    //     text = 'Fr';
    //     break;
    //   case 5:
    //     text = 'St';
    //     break;
    //   case 6:
    //     text = 'Sn';
    //     break;
    //   default:
    //     text = '';
    //     break;
    // }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        for (var k = 0; k < ChartData.days.length; k++)
          BarChartGroupData(
            x: k,
            barRods: [
              BarChartRodData(
                toY: ChartData.ratings[k],
                gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ),
      ];
}

class MyChart extends StatefulWidget {
  MyChart({
    super.key,
    required List<String> days,
    required List<double> ratings,
  }) {
    ChartData.days = days;
    ChartData.ratings = ratings;
  }

  @override
  State<StatefulWidget> createState() => MyChartState();
}

class MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(),
    );
  }
}
