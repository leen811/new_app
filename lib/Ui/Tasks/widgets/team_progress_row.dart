import 'package:flutter/material.dart';
import '../../../Data/Models/team_progress_item.dart';

class TeamProgressRow extends StatelessWidget {
  const TeamProgressRow({super.key, required this.item});
  final TeamProgressItem item;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF6F8FC), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text('${item.percent}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const Spacer(), Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600))]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(minHeight: 8, value: item.percent / 100, color: const Color(0xFF2F56D9), backgroundColor: const Color(0xFFE6EAF2))),
        const SizedBox(height: 8),
        Row(children: [
          Text('ينتهي ${item.deadlineLabel}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
          const Spacer(),
          Text('مشاركون ${item.participants}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
        ])
      ]),
    );
  }
}


