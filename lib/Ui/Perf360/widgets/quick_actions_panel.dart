import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
import '../../../Bloc/perf360/perf360_event.dart';

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: const [Icon(Icons.flash_on, color: Color(0xFF16A34A)), SizedBox(width: 6), Text('إجراءات سريعة', style: TextStyle(fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        FilledButton(onPressed: () => context.read<Perf360Bloc>().add(Perf360TabChanged(1)), child: const Text('تقييم ذاتي')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('عرض التقارير')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('تحديد الأهداف')),
      ]),
    );
  }
}


