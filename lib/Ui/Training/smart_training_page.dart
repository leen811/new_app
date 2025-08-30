import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/training/training_bloc.dart';
import '../../Bloc/training/training_event.dart';
import '../../Bloc/training/training_state.dart';
import '../../Data/Repositories/training_repository.dart';
import '../../Core/Navigation/app_routes.dart';

class SmartTrainingPage extends StatelessWidget {
  const SmartTrainingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TrainingBloc(ctx.read<ITrainingRepository>())..add(TrainingOpened()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0))),
        title: Column(children: const [
          Text('التدريب الذكي', style: TextStyle(color: Colors.black)),
          SizedBox(height: 2),
          Text('اقتراحات تدريبية مخصصة وتنبيهات الأداء', style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
        ]),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: Color(0xFFE6EAF2))),
      ),
      body: BlocBuilder<TrainingBloc, TrainingState>(builder: (context, state) {
        if (state is TrainingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TrainingError) return Center(child: Text(state.message));
        final s = state as TrainingSuccess;
        return ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('تنبيهات الأداء', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
            const SizedBox(height: 8),
            ...s.alerts.map((a) => _AlertCard(alert: a)).expand((w) => [Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: w), const SizedBox(height: 8)]),
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: const [Icon(Icons.north_east, size: 16), SizedBox(width: 6), Text('تتبّع تطور المهارات', style: TextStyle(fontWeight: FontWeight.w800))])),
            const SizedBox(height: 8),
            ...s.skills.map((sk) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: _SkillRow(skill: sk))).toList(),
          ],
        );
      }),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});
  final dynamic alert;
  Color _severityColor(String s) => s == 'عالي' ? const Color(0xFFE11D48) : s == 'متوسط' ? const Color(0xFFF59E0B) : const Color(0xFF2F56D9);
  @override
  Widget build(BuildContext context) {
    final c = _severityColor(alert.severity);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2)), boxShadow: [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 4, height: 120, decoration: BoxDecoration(color: c, borderRadius: const BorderRadiusDirectional.only(topStart: Radius.circular(16), bottomStart: Radius.circular(16)))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(999)), child: Text(alert.severity, style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12))),
              ]),
              const SizedBox(height: 6),
              Text(alert.body, style: const TextStyle(color: Color(0xFF667085))),
              const SizedBox(height: 6),
              Row(children: [const Text('💡 '), Expanded(child: Text(alert.recommend, style: const TextStyle(color: Color(0xFF2F56D9))))]),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: OutlinedButton(onPressed: () => context.goSmartTrainingCourses(), child: const Text('عرض الكورسات'))),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.skill});
  final dynamic skill;
  @override
  Widget build(BuildContext context) {
    final current = skill.currentPct / 100.0;
    final target = skill.targetPct / 100.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(skill.skillName)),
        Text('${skill.currentPct}% / ${skill.targetPct}%'),
      ]),
      const SizedBox(height: 6),
      Stack(children: [
        Container(height: 10, decoration: BoxDecoration(color: const Color(0xFFD6DBE3), borderRadius: BorderRadius.circular(999))),
        LayoutBuilder(builder: (context, cns) => AnimatedContainer(duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic, width: cns.maxWidth * target, height: 10, decoration: BoxDecoration(color: const Color(0xFFD6DBE3), borderRadius: BorderRadius.circular(999)))),
        LayoutBuilder(builder: (context, cns) => AnimatedContainer(duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic, width: cns.maxWidth * current, height: 10, decoration: BoxDecoration(color: const Color(0xFF2F56D9), borderRadius: BorderRadius.circular(999)))),
      ]),
    ]);
  }
}


