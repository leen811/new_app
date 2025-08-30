import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
import '../../../Bloc/perf360/perf360_state.dart';
import 'star_bar.dart';

class SummaryHeader extends StatelessWidget {
  const SummaryHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.select((Perf360Bloc b) => b.state) as Perf360Success;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Text('👨‍💻', style: TextStyle(fontSize: 26))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.me.name, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text('${s.me.role} — ${s.me.dept}', style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
        ])),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        Text('${s.summary.overall} من 5'),
        const SizedBox(width: 8),
        StarBar(value: s.summary.overall, onChanged: (_) {}, size: 18, readOnly: true),
      ]),
    ]);
  }
}


