import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Data/Models/l4l_models.dart';

class L4LTimeseriesChart extends StatelessWidget {
  final List<TimeSeriesPoint> current;
  final List<TimeSeriesPoint> baseline;
  const L4LTimeseriesChart({
    super.key,
    required this.current,
    required this.baseline,
  });
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (current.length - 1).toDouble(),
        minY: 0,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 4,
          getDrawingHorizontalLine: (y) =>
              FlLine(color: const Color(0xFFE9EDF4), strokeWidth: 1),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.white),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              current.length,
              (i) => FlSpot(i.toDouble(), current[i].v),
            ),
            isCurved: true,
            color: const Color(0xFF7C3AED),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF7C3AED).withOpacity(0.06),
            ),
          ),
          LineChartBarData(
            spots: List.generate(
              baseline.length,
              (i) => FlSpot(i.toDouble(), baseline[i].v),
            ),
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF10B981).withOpacity(0.06),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}
