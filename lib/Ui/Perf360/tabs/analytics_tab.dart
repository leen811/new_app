import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
import '../../../Bloc/perf360/perf360_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/insight_section.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Perf360Bloc, Perf360State>(builder: (context, state) {
      if (state is! Perf360Success) return const SizedBox.shrink();
      final s = state;
      if (s.analytics == null) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(height: 120, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 12),
            Container(height: 120, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 12),
            Container(height: 120, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 16),
            Container(height: 300, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16))),
          ]),
        );
      }
      final a = s.analytics!;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Top metrics grid (one column on mobile)
          Column(children: const []),
          LayoutBuilder(builder: (context, cns) {
            final isWide = cns.maxWidth > 720;
            final items = [
              MetricCard(icon: Icons.trending_up, iconColor: const Color(0xFF16A34A), valueText: '+${a.improvementDelta}', caption: 'تحسن عن الدورة السابقة'),
              MetricCard(icon: Icons.emoji_events, iconColor: const Color(0xFF3B82F6), valueText: '${a.completionPct}%', caption: 'نسبة اكتمال التقييمات'),
              MetricCard(icon: Icons.center_focus_strong, iconColor: const Color(0xFF7C3AED), valueText: '${a.improvementPoints}', caption: 'نقاط التحسين المحددة'),
            ];
            if (isWide) {
              return Row(children: [
                Expanded(child: items[0]),
                const SizedBox(width: 12),
                Expanded(child: items[1]),
                const SizedBox(width: 12),
                Expanded(child: items[2]),
              ]);
            }
            return Column(children: [items[0], const SizedBox(height: 12), items[1], const SizedBox(height: 12), items[2]]);
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Align(alignment: Alignment.centerRight, child: Text('التحليل الذكي والتوصيات', style: TextStyle(fontWeight: FontWeight.w800))),
              const SizedBox(height: 12),
              InsightSection(title: 'نقاط القوة', bullets: a.strengths, startColor: const Color(0xFF22C55E), endColor: const Color(0xFF10B981)),
              InsightSection(title: 'نقاط التحسين', bullets: a.improvements, startColor: const Color(0xFFF59E0B), endColor: const Color(0xFFFB923C)),
              InsightSection(title: 'التوصيات', bullets: a.recommendations, startColor: const Color(0xFF60A5FA), endColor: const Color(0xFF3B82F6)),
            ]),
          ),
        ]),
      );
    });
  }
}


