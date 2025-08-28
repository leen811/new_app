import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/twin/digital_twin_bloc.dart';
import '../../Bloc/twin/digital_twin_event.dart';
import '../../Bloc/twin/digital_twin_state.dart';
import '../../Data/Repositories/digital_twin_repository.dart';

class DigitalTwinPage extends StatelessWidget {
  const DigitalTwinPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => DigitalTwinBloc(ctx.read<IDigitalTwinRepository>())..add(TwinOpened()),
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
        title: Column(children: const [
          Text('التوأم الرقمي', style: TextStyle(color: Colors.black)),
          SizedBox(height: 2),
          Text('تحليل ذكي وتوصيات مخصصة لتحسين أدائك', style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
        ]),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: Color(0xFFE6EAF2))),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: GestureDetector(
              onTap: () => context.read<DigitalTwinBloc>().add(TwinRefreshed()),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(999)), child: const Text('تحديث مباشر', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w700, fontSize: 12))),
            ),
          ),
        ],
      ),
      body: BlocBuilder<DigitalTwinBloc, DigitalTwinState>(
        builder: (context, state) {
          if (state is TwinLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TwinError) return Center(child: Text(state.message));
          final s = state as TwinSuccess;
          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollUpdateNotification) {
                if (n.metrics.pixels < -64 && !s.refreshing) {
                  context.read<DigitalTwinBloc>().add(TwinRefreshed());
                }
              }
              return false;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                _KpiGrid(overview: s.overview),
                const SizedBox(height: 12),
                _SegmentedTabs(index: s.tabIndex, onChanged: (i) => context.read<DigitalTwinBloc>().add(TwinTabChanged(i))),
                const SizedBox(height: 12),
                PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation, secondary) => FadeThroughTransition(animation: animation, secondaryAnimation: secondary, child: child),
                  child: s.tabIndex == 0 ? _Recommendations(recs: s.recs) : s.tabIndex == 1 ? _Charts(weekly: s.weekly, daily: s.daily) : const _InsightsPlaceholder(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==== Widgets (compact inline versions) ====

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.overview});
  final dynamic overview;
  @override
  Widget build(BuildContext context) {
    Widget card(IconData icon, String title, String value, {Color? valueColor, required Color iconColor}) {
      return Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2)), boxShadow: [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: CircleAvatar(backgroundColor: iconColor.withOpacity(0.10), child: Icon(icon, color: iconColor))),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: valueColor ?? const Color(0xFF2F56D9))),
        ]),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.3),
        children: [
          card(Icons.center_focus_strong, 'درجة التركيز', '${overview.focusPct}%', iconColor: const Color(0xFF7C3AED)),
          card(Icons.bolt, 'مستوى الطاقة', '${overview.energyPct}%', valueColor: const Color(0xFF10B981), iconColor: const Color(0xFF10B981)),
          card(Icons.trending_up, 'الإنتاجية الأسبوعية', '${overview.weeklyProdPct}%', iconColor: const Color(0xFF2F56D9)),
          card(Icons.person_outline, 'توازن الحياة', '${overview.lifeBalancePct}%', iconColor: const Color(0xFFF59E0B)),
          card(Icons.schedule, 'الساعات المثالية', '${overview.idealHours}h', iconColor: const Color(0xFF0EA5E9)),
          card(Icons.error_outline, 'مستوى التوتر', '${overview.stressPct}%', valueColor: const Color(0xFFEF4444), iconColor: const Color(0xFFEF4444)),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    final labels = const ['التوصيات المخصصة', 'تحليل الإنتاجية', 'الرؤى الذكية'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(24)),
      child: Row(children: List.generate(3, (i) {
        final active = i == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(18), boxShadow: active ? [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 10)] : null),
              child: Center(child: Text(labels[i], textAlign: TextAlign.center, style: TextStyle(color: active ? const Color(0xFF2F56D9) : const Color(0xFF667085), fontWeight: FontWeight.w700))),
            ),
          ),
        );
      })),
    );
  }
}

class _Recommendations extends StatelessWidget {
  const _Recommendations({required this.recs});
  final List<dynamic> recs;
  @override
  Widget build(BuildContext context) {
    Color badgeColor(String p) => p == 'عالي' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) {
        final r = recs[i];
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2)), boxShadow: [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: badgeColor(r.priority).withOpacity(0.12), borderRadius: BorderRadius.circular(999)), child: Text(r.priority, style: TextStyle(color: badgeColor(r.priority), fontWeight: FontWeight.w700, fontSize: 12))),
              const Spacer(),
              const CircleAvatar(radius: 14, backgroundColor: Color(0xFFF2F4F7), child: Icon(Icons.info_outline, size: 16, color: Color(0xFF667085))),
            ]),
            const SizedBox(height: 10),
            Text(r.title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(r.body, textAlign: TextAlign.justify, style: const TextStyle(color: Color(0xFF667085))),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: r.ctas.map<Widget>((c) => OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(shape: const StadiumBorder()), child: Text(c.label))).toList()),
          ]),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: recs.length,
    );
  }
}

class _Charts extends StatelessWidget {
  const _Charts({required this.weekly, required this.daily});
  final List<dynamic> weekly;
  final List<dynamic> daily;
  @override
  Widget build(BuildContext context) {
    // Placeholders for brevity; you can replace with fl_chart detailed charts later
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(children: [
        Container(height: 220, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))), child: const Center(child: Text('اتجاه الإنتاجية الأسبوعية'))),
        const SizedBox(height: 12),
        Container(height: 220, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))), child: const Center(child: Text('نمط الإنتاجية اليومي'))),
      ]),
    );
  }
}

class _InsightsPlaceholder extends StatelessWidget {
  const _InsightsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))), child: const Center(child: Text('سيتم إضافة رؤى ذكية قريبًا', style: TextStyle(color: Color(0xFF667085))))),
    );
  }
}

