import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/perf360/perf360_bloc.dart';
import '../../Bloc/perf360/perf360_event.dart';
import '../../Bloc/perf360/perf360_state.dart';
import '../../Data/Repositories/perf360_repository.dart';
import 'tabs/overview_tab.dart';
import 'tabs/new_eval_tab.dart';
import 'tabs/results_tab.dart';
import 'tabs/analytics_tab.dart';
import 'package:animations/animations.dart';
import '../Common/press_fx.dart';

class Perf360Page extends StatelessWidget {
  const Perf360Page({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => Perf360Bloc(ctx.read<IPerf360Repository>())..add(Perf360Opened()),
      child: Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0))).withPressFX(),
        centerTitle: true,
        title: Column(children: const [
          Text('نظام تقييم الأداء 360 درجة', style: TextStyle(color: Colors.black)),
          SizedBox(height: 2),
        ]),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: Color(0xFFE6EAF2))),
      ),
      body: BlocBuilder<Perf360Bloc, Perf360State>(builder: (context, state) {
        if (state is Perf360Loading) return const Center(child: CircularProgressIndicator());
        if (state is Perf360Error) return Center(child: Text(state.message));
        final s = state as Perf360Success;
        final tabs = [const OverviewTab(), const NewEvalTab(), const ResultsTab(), const AnalyticsTab()];
        return Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(children: const [
              Row(children: [Icon(Icons.insert_chart_outlined), SizedBox(width: 6), Text('نظام تقييم الأداء 360 درجة', style: TextStyle(fontWeight: FontWeight.w800))]),
              SizedBox(height: 4),
              Align(alignment: Alignment.centerRight, child: Text('تقييم شامل من جميع الزوايا - الذات، الرؤساء، الزملاء، والمرؤوسين', style: TextStyle(color: Color(0xFF667085), fontSize: 12))),
            ]),
          ),
          const Divider(height: 1, color: Color(0xFFE6EAF2)),
          const SizedBox(height: 8),
          // Segmented tabs
          _PerfTabs(index: s.tabIndex),
          const SizedBox(height: 8),
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, primary, secondary) => FadeThroughTransition(animation: primary, secondaryAnimation: secondary, child: child),
              child: Builder(builder: (context) {
                if (s.tabIndex == 2) {
                  context.read<Perf360Bloc>().add(Perf360ResultsOpened());
                }
                if (s.tabIndex == 3) {
                  context.read<Perf360Bloc>().add(Perf360AnalyticsOpened());
                }
                return IndexedStack(index: s.tabIndex, children: tabs);
              }),
            ),
          ),
        ]);
      }),
    ));
  }
}

class _PerfTabs extends StatelessWidget {
  const _PerfTabs({required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    const labels = ['نظرة عامة', 'تقييم جديد', 'النتائج', 'التحليلات'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(6),
      height: 44,
      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(24)),
      child: LayoutBuilder(builder: (context, cns) {
        final w = cns.maxWidth / labels.length;
        return Stack(children: [
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            start: index * w,
            top: 0,
            bottom: 0,
            child: Container(
              width: w,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
              ),
            ),
          ),
          Row(children: List.generate(labels.length, (i) {
            final active = i == index;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.read<Perf360Bloc>().add(Perf360TabChanged(i)),
                child: Center(child: AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 200), style: TextStyle(color: active ? const Color(0xFF2F56D9) : const Color(0xFF667085), fontWeight: FontWeight.w700), child: Text(labels[i]))),
              ).withPressFX(),
            );
          })),
        ]);
      }),
    );
  }
}


