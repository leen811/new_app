import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
import '../../../Bloc/perf360/perf360_state.dart';
import '../../../Bloc/perf360/perf360_event.dart';
import '../widgets/star_bar.dart';
import '../widgets/category_row.dart';
import '../widgets/preview_panel.dart';

class NewEvalTab extends StatelessWidget {
  const NewEvalTab({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.select((Perf360Bloc b) => b.state) as Perf360Success;
    final kinds = const ['التقييم الذاتي', 'تقييم زميل', 'تقييم مرؤوس'];
    String kindLabel(String k) => k == 'self' ? kinds[0] : (k == 'peer' ? kinds[1] : kinds[2]);
    String toKey(String l) => l == kinds[0] ? 'self' : (l == kinds[1] ? 'peer' : 'subordinate');
    return ListView(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        LayoutBuilder(builder: (context, cns) {
          final isWide = cns.maxWidth > 720;
          final formCard = _FormCard(kinds: kinds, kindLabel: kindLabel, toKey: toKey, state: s);
          final preview = PreviewPanel(score: s.previewScore);
          if (isWide) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: formCard),
              const SizedBox(width: 12),
              Expanded(child: preview),
            ]);
          }
          return Column(children: [formCard, const SizedBox(height: 12), preview]);
        }),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.kinds, required this.kindLabel, required this.toKey, required this.state});
  final List<String> kinds;
  final String Function(String) kindLabel;
  final String Function(String) toKey;
  final Perf360Success state;
  @override
  Widget build(BuildContext context) {
    final s = state;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [Icon(Icons.star_border), SizedBox(width: 6), Text('تقييم جديد', style: TextStyle(fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        DropdownMenu<String>(
          initialSelection: kindLabel(s.form.kind),
          onSelected: (v) { if (v != null) context.read<Perf360Bloc>().add(Perf360FormKindChanged(toKey(v))); },
          label: const Text('نوع التقييم'),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFF8FAFF),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFE6EAF2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFE6EAF2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
          dropdownMenuEntries: kinds.map((e) => DropdownMenuEntry<String>(value: e, label: e, leadingIcon: const Icon(Icons.tune_rounded))).toList(),
        ),
        const SizedBox(height: 12),
        if (s.form.kind != 'self')
          DropdownMenu<String>(
            initialSelection: s.form.targetId,
            onSelected: (v) { if (v != null) context.read<Perf360Bloc>().add(Perf360FormTargetChanged(v)); },
            label: const Text('اختر الشخص المراد تقييمه'),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFF8FAFF),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFE6EAF2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFE6EAF2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
            dropdownMenuEntries: s.peers.map((u) => DropdownMenuEntry<String>(value: u.id, label: u.name, leadingIcon: const Icon(Icons.person_rounded))).toList(),
          ),
        const SizedBox(height: 12),
        const Text('التقييم العام', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(children: [
          Text('${s.form.overall.toStringAsFixed(1)}/5', style: const TextStyle(color: Color(0xFF667085))),
          const SizedBox(width: 8),
          Expanded(child: StarBar(value: s.form.overall, onChanged: (v) => context.read<Perf360Bloc>().add(Perf360FormOverallChanged(v)), size: 24, gap: 6)),
        ]),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFE6EAF2)),
        const SizedBox(height: 12),
        const Text('التقييم التفصيلي', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        ...s.form.categories.map((c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CategoryRow(
                weightPct: c.weightPct,
                title: c.name,
                value: c.score ?? 0,
                onChanged: (v) => context.read<Perf360Bloc>().add(Perf360FormCategoryChanged(c.name, v)),
              ),
            )),
        const SizedBox(height: 12),
        TextField(
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'أضف تعليقاتك وتوصياتك هنا...'),
          onChanged: (t) => context.read<Perf360Bloc>().add(Perf360FormNotesChanged(t)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => context.read<Perf360Bloc>().add(const Perf360FormSubmit()),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('إرسال التقييم'), SizedBox(width: 6), Icon(Icons.check, size: 18)]),
          ),
        ),
      ]),
    );
  }
}


