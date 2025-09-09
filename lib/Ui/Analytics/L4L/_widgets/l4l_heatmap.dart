import 'package:flutter/material.dart';
import '../../../../Data/Models/l4l_models.dart';

class L4LHeatmap extends StatelessWidget {
  final List<HeatCell> cells;
  const L4LHeatmap({super.key, required this.cells});
  @override
  Widget build(BuildContext context) {
    final values = cells.map((e) => e.v).toList();
    final minV = values.isEmpty ? 0.0 : values.reduce((a, b) => a < b ? a : b);
    final maxV = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    return LayoutBuilder(builder: (context, c) {
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: cells.map((cell) {
          final t = maxV == minV ? 0.5 : (cell.v - minV) / (maxV - minV);
          final color = Color.lerp(const Color(0xFFE5E7EB), const Color(0xFF2563EB), t)!;
          return Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)));
        }).toList(),
      );
    });
  }
}


