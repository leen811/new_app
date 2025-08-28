import 'package:flutter/material.dart';
import '../../../Data/Models/challenge_item.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, required this.item});
  final ChallengeItem item;
  @override
  Widget build(BuildContext context) {
    final mePct = item.meProgress.toDouble();
    final teamPct = (item.teamProgress / item.total) * 100;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(item.desc, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
          ])),
          Text(item.deadlineLabel, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
        ]),
        const SizedBox(height: 12),
        _progressBar(label: 'تقدمي', percent: mePct),
        const SizedBox(height: 8),
        _progressBar(label: 'تقدّم الفريق ${item.teamProgress}/${item.total}', percent: teamPct),
        const SizedBox(height: 8),
        Text('المكافأة: 500 كوين + شهادة إنجاز', style: const TextStyle(fontSize: 12, color: Color(0xFF23408A), fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _progressBar({required String label, required double percent}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 12))), Text('${percent.toStringAsFixed(0)}%')]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(minHeight: 8, value: percent / 100, color: const Color(0xFF2F56D9), backgroundColor: const Color(0xFFE6EAF2)),
      ),
    ]);
  }
}


