import 'package:flutter/material.dart';
import '../../../Data/Models/kpi_overview.dart';

class KpiRow extends StatelessWidget {
  const KpiRow({super.key, required this.data});
  final KpiOverview data;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiCard(icon: Icons.track_changes, value: '${data.achievementPct}%', label: 'معدل الإنجاز'),
      _KpiCard(icon: Icons.access_time, value: '${data.workMinutes}', label: 'دقيقة عمل'),
      _KpiCard(icon: Icons.emoji_events_outlined, value: '${data.activeChallenges}', label: 'تحديات نشطة'),
      _KpiCard(icon: Icons.check_box_outlined, value: '${data.tasksTodayDone}/${data.tasksTodayTotal}', label: 'مهام اليوم'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.9,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: cards,
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: const [BoxShadow(color: Color(0x0F0B1524), blurRadius: 10, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: const Color(0xFFF6F8FC), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE6EAF2))),
            child: Icon(icon, color: const Color(0xFF2F56D9)),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
          ]),
        ],
      ),
    );
  }
}


