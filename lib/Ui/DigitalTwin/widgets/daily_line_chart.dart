import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyLineChart extends StatelessWidget {
  const DailyLineChart({super.key, required this.values, required this.labels});
  final List<int> values;
  final List<String> labels;
  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).accessibleNavigation;
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (labels.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) => Padding(padding: const EdgeInsets.only(top: 4), child: Text(labels[v.toInt()], style: const TextStyle(fontSize: 10))))),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(drawVerticalLine: false, horizontalInterval: 25, getDrawingHorizontalLine: (y) => FlLine(color: const Color(0xFFE9EDF4), strokeWidth: 1)),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.white, getTooltipItems: (spots) => spots.map((s) => LineTooltipItem('${s.y.toInt()}', const TextStyle(color: Color(0xFF7C3AED)))).toList()),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i].toDouble())),
            isCurved: true,
            color: const Color(0xFF7C3AED),
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF7C3AED).withOpacity(0.06)),
            curveSmoothness: reduce ? 0 : 0.2,
          ),
        ],
      ),
      duration: reduce ? Duration.zero : const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }
}


