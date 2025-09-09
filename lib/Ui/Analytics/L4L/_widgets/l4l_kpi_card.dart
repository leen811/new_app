import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class L4LKpiCard extends StatelessWidget {
  final String title;
  final double value;
  final double deltaPct;
  final bool inverted;
  final List<double> spark;
  const L4LKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.deltaPct,
    required this.inverted,
    required this.spark,
  });
  @override
  Widget build(BuildContext context) {
    final good = inverted ? deltaPct < 0 : deltaPct > 0;
    final arrow = good
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final color = good ? const Color(0xFF16A34A) : const Color(0xFFEF4444);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 120.0;
        final double tsf = MediaQuery.of(
          context,
        ).textScaleFactor.clamp(1.0, 1.4);
        final double scale = ((h / 120.0).clamp(0.5, 1.1)) / tsf;
        final double pad = (12.0 * scale).clamp(8.0, 14.0).toDouble();
        final double titleFs = (12.0 * scale).clamp(9.0, 13.0).toDouble();
        final double valueFs = (20.0 * scale).clamp(14.0, 22.0).toDouble();
        // final double sparkH = (22.0 * scale).clamp(16.0, 24.0).toDouble();
        final double gap = (6.0 * scale).clamp(2.0, 6.0).toDouble();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6E9F0), width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleFs,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: gap),
                Text(
                  value.toStringAsFixed(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: valueFs,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: gap / 2),
                Expanded(child: _sparkline()),
                SizedBox(height: gap / 2),
                Row(
                  children: [
                    Icon(
                      arrow,
                      size: (13 * scale).clamp(10.0, 14.0),
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${deltaPct.toStringAsFixed(1)}%',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: (12.0 * scale).clamp(9.0, 13.0).toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sparkline() {
    final maxVal = spark.isEmpty ? 1.0 : spark.reduce((a, b) => a > b ? a : b);
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spark.isEmpty ? 1 : (spark.length - 1).toDouble(),
        minY: 0,
        maxY: maxVal <= 0 ? 1 : maxVal,
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              spark.length,
              (i) => FlSpot(i.toDouble(), spark[i]),
            ),
            isCurved: true,
            color: const Color(0xFF7C3AED),
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF7C3AED).withOpacity(0.06),
            ),
          ),
        ],
      ),
    );
  }
}
