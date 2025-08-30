import 'package:flutter/material.dart';
import 'star_bar.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key, required this.weightPct, required this.title, required this.value, required this.onChanged});
  final int weightPct;
  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE6EAF2))),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const Spacer(),
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFE6EAF2))),
            child: Row(children: [Text('${((value / 5) * 100).round()}%', style: const TextStyle(color: Color(0xFF667085), fontSize: 12))]),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text('${value.toStringAsFixed(1)}/5', style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(child: StarBar(value: value, onChanged: onChanged, size: 22)),
        ]),
      ]),
    );
  }
}


