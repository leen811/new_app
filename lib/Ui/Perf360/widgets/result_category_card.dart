import 'package:flutter/material.dart';
import 'overall_progress_bar.dart';

class ResultCategoryCard extends StatelessWidget {
  const ResultCategoryCard({super.key, required this.category, required this.overall, required this.self, required this.manager, required this.peers, required this.subs});
  final String category;
  final double overall;
  final double self;
  final double manager;
  final double peers;
  final double subs;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header row
        Row(children: [
          Text(category, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const Spacer(),
          Row(children: [Text(overall.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)), const SizedBox(width: 4), const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18)])
        ]),
        const SizedBox(height: 8),
        // Columns titles
        Row(children: const [
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text('الذاتي', style: TextStyle(color: Color(0xFF667085), fontSize: 13)))),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text('المدير', style: TextStyle(color: Color(0xFF667085), fontSize: 13)))),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text('الزملاء', style: TextStyle(color: Color(0xFF667085), fontSize: 13)))),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text('المرؤوسين', style: TextStyle(color: Color(0xFF667085), fontSize: 13)))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text(self.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF111827))))),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text(manager.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF111827))))),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text(peers.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF111827))))),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text(subs.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF111827))))),
        ]),
        const SizedBox(height: 10),
        OverallProgressBar(value: (overall / 5.0)),
      ]),
    );
  }
}


