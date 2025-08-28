import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/tasks/tasks_tab_bloc.dart';
import '../../Bloc/tasks/tasks_tab_event.dart';
import '../../Bloc/tasks/tasks_tab_state.dart';
import '../../Bloc/tasks/daily/daily_tasks_bloc.dart';
import '../../Bloc/tasks/daily/daily_tasks_event.dart';
import '../../Bloc/tasks/daily/daily_tasks_state.dart';
import '../../Bloc/tasks/challenges/challenges_bloc.dart';
import '../../Bloc/tasks/challenges/challenges_event.dart';
import '../../Bloc/tasks/challenges/challenges_state.dart';
import '../../Bloc/tasks/team/team_progress_bloc.dart';
import '../../Bloc/tasks/team/team_progress_event.dart';
import '../../Bloc/tasks/team/team_progress_state.dart';
import '../../Data/Repositories/tasks_repository.dart';
import 'widgets/kpi_row.dart';
import 'widgets/segmented_tabs.dart';
import 'widgets/task_card.dart';
import 'widgets/challenge_card.dart';
import 'widgets/team_progress_row.dart';

class TasksTabPage extends StatelessWidget {
  const TasksTabPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => TasksTabBloc(ctx.read<ITasksRepository>())..add(TasksOverviewRequested())..add(const TasksTabChanged(0))),
        BlocProvider(create: (ctx) => DailyTasksBloc(ctx.read<ITasksRepository>())..add(DailyTasksFetch())),
        BlocProvider(create: (ctx) => ChallengesBloc(ctx.read<ITasksRepository>())),
        BlocProvider(create: (ctx) => TeamProgressBloc(ctx.read<ITasksRepository>())),
      ],
      child: const _TasksBody(),
    );
  }
}

class _TasksBody extends StatelessWidget {
  const _TasksBody();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Text('تابع مهامك اليومية وشارك في التحديات الجماعية', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<TasksTabBloc, TasksTabState>(builder: (context, state) {
                final overview = state is TasksTabSuccess ? state.overview : null;
                if (overview == null) {
                  return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
                }
                return KpiRow(data: overview);
              }),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabsHeaderDelegate(child: BlocBuilder<TasksTabBloc, TasksTabState>(builder: (context, state) {
                final index = state is TasksTabSuccess ? state.index : 0;
                return SegmentedTabs(index: index, onChanged: (i) {
                  context.read<TasksTabBloc>().add(TasksTabChanged(i));
                  if (i == 0) context.read<DailyTasksBloc>().add(DailyTasksFetch());
                  if (i == 1) context.read<ChallengesBloc>().add(ChallengesFetch());
                  if (i == 2) context.read<TeamProgressBloc>().add(TeamProgressFetch());
                });
              })),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverFillRemaining(
              child: BlocBuilder<TasksTabBloc, TasksTabState>(builder: (context, state) {
                final index = state is TasksTabSuccess ? state.index : 0;
                switch (index) {
                  case 0:
                    return _DailyTab();
                  case 1:
                    return _ChallengesTab();
                  case 2:
                  default:
                    return _TeamTab();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyTasksBloc, DailyTasksState>(builder: (context, state) {
      if (state is DailyTasksLoading) {
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => Container(height: 120, margin: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),),
        );
      }
      if (state is DailyTasksError) return Center(child: Text(state.message));
      if (state is DailyTasksEmpty) return const Center(child: Text('لا توجد مهام لليوم'));
      final items = (state as DailyTasksSuccess).items;
      return RefreshIndicator(
        onRefresh: () async => context.read<DailyTasksBloc>().add(DailyTasksRefresh()),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => TaskCard(
            item: items[i],
            onToggle: () => context.read<DailyTasksBloc>().add(DailyTaskToggleComplete(items[i].id)),
            onTimerStart: () => context.read<DailyTasksBloc>().add(DailyTaskTimerStart(items[i].id)),
            onTimerStop: () => context.read<DailyTasksBloc>().add(DailyTaskTimerStop(items[i].id)),
          ),
        ),
      );
    });
  }
}

class _ChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesBloc, ChallengesState>(builder: (context, state) {
      if (state is ChallengesInitial) {
        // lazy load
        context.read<ChallengesBloc>().add(ChallengesFetch());
      }
      if (state is ChallengesLoading) return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      if (state is ChallengesError) return Center(child: Text(state.message));
      if (state is ChallengesEmpty) return const Center(child: Text('لا توجد تحديات'));
      final items = (state as ChallengesSuccess).items;
      return RefreshIndicator(
        onRefresh: () async => context.read<ChallengesBloc>().add(ChallengesRefresh()),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => ChallengeCard(item: items[i]),
        ),
      );
    });
  }
}

class _TeamTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProgressBloc, TeamProgressState>(builder: (context, state) {
      if (state is TeamProgressInitial) {
        context.read<TeamProgressBloc>().add(TeamProgressFetch());
      }
      if (state is TeamProgressLoading) return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      if (state is TeamProgressError) return Center(child: Text(state.message));
      if (state is TeamProgressEmpty) return const Center(child: Text('لا يوجد تقدم بعد'));
      final items = (state as TeamProgressSuccess).items;
      return RefreshIndicator(
        onRefresh: () async => context.read<TeamProgressBloc>().add(TeamProgressRefresh()),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => TeamProgressRow(item: items[i]),
        ),
      );
    });
  }
}

class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TabsHeaderDelegate({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(color: const Color(0xFFF8FAFC), padding: const EdgeInsets.only(bottom: 8), child: child);
  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}


