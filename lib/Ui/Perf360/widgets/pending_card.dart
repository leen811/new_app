import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
import '../../../Bloc/perf360/perf360_state.dart';
import '../../../Bloc/perf360/perf360_event.dart';

class PendingCard extends StatelessWidget {
  const PendingCard({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.select((Perf360Bloc b) => b.state) as Perf360Success;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('تقييمات معلّقة', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        if (s.pending.isEmpty)
          const Text('لا يوجد تقييمات معلّقة')
        else
          ...s.pending.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE6EAF2)), borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
                  title: Text(p.target.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(p.target.role),
                  trailing: FilledButton.tonal(
                    onPressed: () => context.read<Perf360Bloc>().add(Perf360StartPending(p.id)),
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFEDD5)),
                    child: const Text('ابدأ التقييم'),
                  ),
                ),
              )),
      ]),
    );
  }
}


