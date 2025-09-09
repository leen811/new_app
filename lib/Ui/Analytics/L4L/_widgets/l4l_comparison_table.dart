import 'package:flutter/material.dart';
import '../../../../Data/Models/l4l_models.dart';

class L4LComparisonTable extends StatelessWidget {
  final List<KpiValue> kpis;
  final void Function()? onDrill;
  const L4LComparisonTable({super.key, required this.kpis, this.onDrill});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('KPI')),
          DataColumn(label: Text('Current')),
          DataColumn(label: Text('Baseline')),
          DataColumn(label: Text('Δ')),
          DataColumn(label: Text('Δ%')),
        ],
        rows: kpis.map((k) => DataRow(
          onSelectChanged: (_) => onDrill?.call(),
          cells: [
            DataCell(Text(k.key)),
            DataCell(Text(k.current.toStringAsFixed(1))),
            DataCell(Text(k.baseline.toStringAsFixed(1))),
            DataCell(Text(k.delta.toStringAsFixed(1))),
            DataCell(Text('${k.deltaPct.toStringAsFixed(1)}%')),
          ],
        )).toList(),
      ),
    );
  }
}


