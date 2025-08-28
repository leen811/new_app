import 'package:flutter/material.dart';
import '../../../Data/Models/performance_overview.dart';

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key, required this.perf});
  final PerformanceOverview perf;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Text('نظرة عامة على الأداء', style: TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(width: 6),
          Icon(Icons.north_east, color: Colors.green, size: 16),
        ]),
        const SizedBox(height: 12),
        _Bar(label: 'الإنتاجية', pct: perf.productivityPct),
        const SizedBox(height: 12),
        _Bar(label: 'جودة العمل', pct: perf.qualityPct),
        const SizedBox(height: 12),
        _Bar(label: 'الحضور', pct: perf.attendancePct),
        const SizedBox(height: 12),
        _Bar(label: 'العمل الجماعي', pct: perf.teamworkPct),
      ]),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.label, required this.pct});
  final String label;
  final int pct;
  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).accessibleNavigation;
    final value = pct / 100.0;
    final animationDuration = reduced ? Duration.zero : const Duration(milliseconds: 600);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(label)), Text('$pct%')]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: TweenAnimationBuilder<double>(
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0, end: value),
          builder: (context, v, _) => LinearProgressIndicator(value: v, minHeight: 8, color: const Color(0xFF2F56D9), backgroundColor: const Color(0xFFE9EDF4)),
        ),
      ),
    ]);
  }
}


