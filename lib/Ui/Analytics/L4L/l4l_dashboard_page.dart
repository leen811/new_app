import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/L4L/l4l_bloc.dart';
import '../../../Bloc/L4L/l4l_event.dart';
import '../../../Bloc/L4L/l4l_state.dart';
import '../../../Data/Repositories/l4l_repository.dart';
import '../../../Data/Models/l4l_models.dart';
import '../../../l10n/l10n.dart';

import '_widgets/l4l_filters_bar.dart';
import '_widgets/l4l_kpi_card.dart';
import '_widgets/l4l_timeseries_chart.dart';
import '_widgets/l4l_heatmap.dart';
import '_widgets/l4l_comparison_table.dart';
import '_widgets/l4l_skeleton.dart';

class L4LDashboardPage extends StatelessWidget {
  const L4LDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(S.of(context).l4l_title),
        ),
        leading: BackButton(color: Colors.black87),
      ),
      body: BlocProvider(
        create: (_) =>
            L4LBloc(repository: MockL4LRepository())..add(const L4LLoad()),
        child: const _L4LBody(),
      ),
    );
  }
}

class _L4LBody extends StatefulWidget {
  const _L4LBody();
  @override
  State<_L4LBody> createState() => _L4LBodyState();
}

class _L4LBodyState extends State<_L4LBody> {
  int _periodIndex = 1; // week default
  int _compareIndex = 1; // week vs prev

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<L4LBloc, L4LState>(
      builder: (context, state) {
        if (state is L4LLoading || state is L4LInitial) {
          return const L4LSkeleton();
        }
        if (state is L4LError) {
          return Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          context.read<L4LBloc>().add(const L4LRefresh()),
                      child: Text(S.of(context).common_retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final loaded = state as L4LLoaded;

        return RefreshIndicator(
          onRefresh: () async =>
              context.read<L4LBloc>().add(const L4LRefresh()),
          color: const Color(0xFF2F56D9),
          backgroundColor: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: L4LFiltersBar(
                  periodIndex: _periodIndex,
                  onPeriodChanged: (i) {
                    setState(() => _periodIndex = i);
                    context.read<L4LBloc>().add(
                      L4LChangePeriod(
                        [
                          L4LPeriod.day,
                          L4LPeriod.week,
                          L4LPeriod.month,
                          L4LPeriod.year,
                        ][i],
                      ),
                    );
                  },
                  compareIndex: _compareIndex,
                  onCompareChanged: (i) {
                    setState(() => _compareIndex = i);
                    context.read<L4LBloc>().add(
                      L4LChangeCompare(
                        [
                          L4LCompare.day_vs_same_day_last_year,
                          L4LCompare.week_vs_prev_week,
                          L4LCompare.month_vs_prev_month,
                          L4LCompare.year_vs_last_year,
                        ][i],
                      ),
                    );
                  },
                  breadcrumb: loaded.breadcrumb,
                  onBreadcrumbTap: (level) {
                    context.read<L4LBloc>().add(L4LChangeLevel(level));
                  },
                  level: loaded.level,
                  onLevelChanged: (lv) {
                    context.read<L4LBloc>().add(L4LChangeLevel(lv));
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: loaded.kpiDefs.map((def) {
                    final v = loaded.data.kpis.firstWhere(
                      (e) => e.key == def.key,
                    );
                    final spark =
                        (loaded.data.series['${def.key}.current'] ?? [])
                            .map((e) => e.v)
                            .toList();
                    return L4LKpiCard(
                      title: def.title,
                      value: v.current,
                      deltaPct: v.deltaPct,
                      inverted: def.isInverted,
                      spark: spark,
                    );
                  }).toList(),
                ),
              ),
              SliverToBoxAdapter(child: _TimeseriesSection(loaded: loaded)),
              SliverToBoxAdapter(child: _HeatmapSection(loaded: loaded)),
              SliverToBoxAdapter(child: _ComparisonTable(loaded: loaded)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}

// removed unused local widgets; dedicated widgets are in _widgets/*

class _TimeseriesSection extends StatelessWidget {
  final L4LLoaded loaded;
  const _TimeseriesSection({required this.loaded});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        child: SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: L4LTimeseriesChart(
              current: loaded.kpiDefs.isEmpty
                  ? const []
                  : (loaded
                            .data
                            .series['${loaded.kpiDefs.first.key}.current'] ??
                        const []),
              baseline: loaded.kpiDefs.isEmpty
                  ? const []
                  : (loaded
                            .data
                            .series['${loaded.kpiDefs.first.key}.baseline'] ??
                        const []),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeatmapSection extends StatelessWidget {
  final L4LLoaded loaded;
  const _HeatmapSection({required this.loaded});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        child: SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: L4LHeatmap(cells: loaded.data.heat),
          ),
        ),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final L4LLoaded loaded;
  const _ComparisonTable({required this.loaded});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        child: L4LComparisonTable(
          kpis: loaded.data.kpis,
          onDrill: () {
            final next = _nextLevel(loaded.level);
            if (next != null) {
              context.read<L4LBloc>().add(L4LChangeLevel(next));
            }
          },
        ),
      ),
    );
  }

  L4LLevel? _nextLevel(L4LLevel current) {
    switch (current) {
      case L4LLevel.organization:
        return L4LLevel.branch;
      case L4LLevel.branch:
        return L4LLevel.department;
      case L4LLevel.department:
        return L4LLevel.team;
      case L4LLevel.team:
        return L4LLevel.employee;
      case L4LLevel.employee:
        return null;
    }
  }
}
