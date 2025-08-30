import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_state.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
// import '../../../Bloc/perf360/perf360_event.dart';
import '../widgets/star_bar.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Perf360Bloc, Perf360State>(builder: (context, state) {
      if (state is! Perf360Success) return const SizedBox.shrink();
      final s = state;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6EAF2)),
              boxShadow: [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // 1) Title row
              Row(children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('ملخص التقييم الحالي', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline, color: Color(0xFF667085))),
              ]),
              const Divider(height: 1, color: Color(0xFFE6EAF2)),
              const SizedBox(height: 12),

              // 2) User info (centered)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Text('👨‍💻', style: TextStyle(fontSize: 26))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.me.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(height: 2),
                  const Text('مطوّر واجهات أمامية', style: TextStyle(fontSize: 13, color: Color(0xFF667085))),
                  const SizedBox(height: 2),
                  const Text('التقنية', style: TextStyle(fontSize: 12, color: Color(0xFF98A2B3))),
                ]),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Text('5 من', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                SizedBox(width: 6),
                Text('4.2', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w700, fontSize: 16)),
                SizedBox(width: 6),
                Icon(Icons.star, color: Color(0xFFF59E0B), size: 18),
              ]),

              const SizedBox(height: 16),
              // 3) 2x2 grid results
              LayoutBuilder(builder: (context, cns) {
                return GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.9,
                  ),
                  children: [
                    _ScoreTile(label: 'التقييم الذاتي', value: s.summary.self, completed: true),
                    _ScoreTile(label: 'تقييم المدير', value: s.summary.manager, completed: true),
                    _ScoreTile(label: 'peers', value: s.summary.peers, completed: true),
                    const _SubordinatesTile(),
                  ],
                );
              }),
            ]),
          ),
        ],
      );
    });
  }
}
class _ScoreTile extends StatelessWidget {
  const _ScoreTile({required this.label, required this.value, required this.completed});
  final String label; final double value; final bool completed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(999)),
            child: const Center(child: Text('مكمل', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
          const SizedBox(width: 6),
          StarBar(value: value, onChanged: (_) {}, size: 18, readOnly: true),
        ]),
      ]),
    );
  }
}

class _SubordinatesTile extends StatelessWidget {
  const _SubordinatesTile();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('subordinates', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(999)),
            child: const Center(child: Text('معلق', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
          ),
        ]),
        const SizedBox(height: 8),
        Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFFDE68A))),
          child: Row(mainAxisSize: MainAxisSize.min, children: const [
            Icon(Icons.schedule, color: Color(0xFFF59E0B), size: 16),
            SizedBox(width: 6),
            Text('في الانتظار', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }
}
