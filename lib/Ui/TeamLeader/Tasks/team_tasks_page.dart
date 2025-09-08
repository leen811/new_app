import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Repositories/team_tasks_repository.dart';
import '../../../Bloc/TeamTasks/team_tasks_bloc.dart';
import '../../../Bloc/TeamTasks/team_tasks_event.dart';
import '../../../Bloc/TeamTasks/team_tasks_state.dart';
import '_widgets/summary_kpi_tiles.dart';
import '_widgets/filters_bar.dart';
import '_widgets/task_card.dart';
import '_widgets/skeleton_tasks.dart';
// details sheet imported indirectly by task_card
import '_widgets/task_create_sheet.dart';

class TeamTasksPage extends StatelessWidget {
  const TeamTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamTasksBloc(MockTeamTasksRepository())..add(const TasksLoad()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('إدارة مهام الفريق', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () => showTaskCreateSheetFull(context),
            icon: const Icon(Icons.add_task_rounded, color: Colors.black87),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: BlocBuilder<TeamTasksBloc, TeamTasksState>(
        builder: (context, state) {
          if (state is TasksLoading || state is TasksInitial) {
            return const SkeletonTasks();
          }
          if (state is TasksError) {
            return Center(child: Text(state.message));
          }
          final s = state as TasksLoaded;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SummaryKpiTiles(summary: s.summary),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FiltersBar(
                    query: s.query,
                    filter: s.filter,
                    onQuery: (q) => context.read<TeamTasksBloc>().add(TasksSearchChanged(q)),
                    onFilter: (f) => context.read<TeamTasksBloc>().add(TasksFilterChanged(f)),
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: s.items.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TaskCard(item: s.items[i]),
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

//


