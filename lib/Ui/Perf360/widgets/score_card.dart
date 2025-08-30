import 'package:flutter/material.dart';
import 'star_bar.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.title, required this.value, required this.completed});
  final String title;
  final double value;
  final bool completed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: (completed ? const Color(0xFFDCFCE7) : const Color(0xFFFFF7ED)), borderRadius: BorderRadius.circular(999)), child: Text(completed ? 'مكمل' : 'في الانتظار', style: TextStyle(color: completed ? const Color(0xFF16A34A) : const Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.w700))),
          const Spacer(),
          Text(value.toStringAsFixed(1)),
        ]),
        const SizedBox(height: 6),
        StarBar(value: value, onChanged: (_) {}, size: 18, readOnly: true),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }
}


