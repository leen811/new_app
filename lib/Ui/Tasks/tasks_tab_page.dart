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
import '../../Data/Models/task_item.dart';
import '../widgets/app_button.dart';
import '../../Data/Repositories/tasks_repository.dart';
import 'widgets/kpi_row.dart';
import 'widgets/segmented_tabs.dart';
import 'widgets/task_card.dart';
import 'widgets/challenge_card.dart';
import 'widgets/team_progress_row.dart';
import '../Common/press_fx.dart';

class TasksTabPage extends StatefulWidget {
  const TasksTabPage({super.key});

  @override
  State<TasksTabPage> createState() => _TasksTabPageState();
}

class _TasksTabPageState extends State<TasksTabPage> with AutomaticKeepAliveClientMixin {
  late final TasksTabBloc _tasksTabBloc;
  late final DailyTasksBloc _dailyTasksBloc;
  late final ChallengesBloc _challengesBloc;
  late final TeamProgressBloc _teamProgressBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tasksTabBloc = TasksTabBloc(context.read<ITasksRepository>())
      ..add(TasksOverviewRequested())
      ..add(const TasksTabChanged(0));
    _dailyTasksBloc = DailyTasksBloc(context.read<ITasksRepository>())
      ..add(DailyTasksFetch());
    _challengesBloc = ChallengesBloc(context.read<ITasksRepository>());
    _teamProgressBloc = TeamProgressBloc(context.read<ITasksRepository>());
  }

  @override
  void dispose() {
    _tasksTabBloc.close();
    _dailyTasksBloc.close();
    _challengesBloc.close();
    _teamProgressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _tasksTabBloc),
        BlocProvider.value(value: _dailyTasksBloc),
        BlocProvider.value(value: _challengesBloc),
        BlocProvider.value(value: _teamProgressBloc),
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
      appBar: AppBar(
        title: const Center(child: Text('المهام')),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تابع مهامك اليومية وشارك في التحديات الجماعية',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<TasksTabBloc, TasksTabState>(
                builder: (context, state) {
                  if (state is TasksTabLoading) {
                    return const _TasksLoadingSkeleton();
                  } else if (state is TasksTabError) {
                    return _TasksErrorView(message: state.message);
                  } else if (state is TasksTabSuccess && state.overview != null) {
                    return KpiRow(data: state.overview!);
                  }
                  return const _TasksLoadingSkeleton();
                },
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 30)),

            SliverPersistentHeader(
              pinned: true,
              delegate: _TabsHeaderDelegate(
                child: BlocBuilder<TasksTabBloc, TasksTabState>(
                  builder: (context, state) {
                    final index = state is TasksTabSuccess ? state.index : 0;
                    return SegmentedTabs(
                      index: index,
                      onChanged: (i) {
                        context.read<TasksTabBloc>().add(TasksTabChanged(i));
                        if (i == 0)
                          context.read<DailyTasksBloc>().add(DailyTasksFetch());
                        if (i == 1)
                          context.read<ChallengesBloc>().add(ChallengesFetch());
                        if (i == 2)
                          context.read<TeamProgressBloc>().add(
                            TeamProgressFetch(),
                          );
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverFillRemaining(
              child: BlocBuilder<TasksTabBloc, TasksTabState>(
                builder: (context, state) {
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
                },
              ),
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
    return BlocBuilder<DailyTasksBloc, DailyTasksState>(
      builder: (context, state) {
        Widget header = Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'مهامك اليومية',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showAddTaskDialog(context),
                icon: const Icon(Icons.add, color: Color(0xFF2F56D9)),
              ).withPressFX(),
            ],
          ),
        );

        if (state is DailyTasksInitial || state is DailyTasksLoading) {
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == 0) return header;
              return Container(
                height: 120,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6EAF2)),
                ),
              );
            },
          );
        }
        if (state is DailyTasksError) {
          return ListView(
            children: [
              header,
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message),
                ),
              ),
            ],
          );
        }
        if (state is DailyTasksEmpty) {
          return ListView(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Text(
                  'مهامك اليومية',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('لا توجد مهام لليوم'),
                ),
              ),
            ],
          );
        }
        final items = (state as DailyTasksSuccess).items;
        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n is OverscrollNotification &&
                n.overscroll < 0 &&
                n.metrics.extentBefore == 0) {
              final bloc = context.read<DailyTasksBloc>();
              if (bloc.state is! DailyTasksLoading) {
                bloc.add(DailyTasksRefresh());
              }
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == 0) return header;
              final idx = i - 1;
              return TaskCard(
                item: items[idx],
                onToggle: () => context.read<DailyTasksBloc>().add(
                  DailyTaskToggleComplete(items[idx].id),
                ),
                onTimerStart: () => context.read<DailyTasksBloc>().add(
                  DailyTaskTimerStart(items[idx].id),
                ),
                onTimerStop: () => context.read<DailyTasksBloc>().add(
                  DailyTaskTimerStop(items[idx].id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

void _showAddTaskDialog(BuildContext context) {
  final pageContext = context; // capture outer context that has the providers
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String priority = 'متوسطة';
  DateTimeRange? range;
  final Set<String> selectedWorks = {'عمل'};
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'add_task',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, a1, a2) {
      const Color darkBlue = Color(0xFF1E3A8A);
      final theme = Theme.of(ctx).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: darkBlue, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: darkBlue, width: 2),
          ),
        ),
      );
      return Center(
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE6E8F0)),
          ),
          child: Theme(
            data: theme,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    String rangeLabel = range == null
                        ? 'اختر المدة'
                        : '${MaterialLocalizations.of(context).formatMediumDate(range!.start)} - ${MaterialLocalizations.of(context).formatMediumDate(range!.end)}';
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'إضافة مهمة جديدة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close),
                              splashRadius: 20,
                            ).withPressFX(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            hintText: 'عنوان المهمة',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'وصف المهمة (اختياري)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'أنواع العمل',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: -6,
                          children: [
                            for (final w in const [
                              'عمل',
                              'توثيق',
                              'تصميم',
                              'اجتماع',
                              'مراجعة',
                              'تطوير',
                            ])
                              FilterChip(
                                label: Text(w),
                                selected: selectedWorks.contains(w),
                                onSelected: (v) => setState(() {
                                  if (v)
                                    selectedWorks.add(w);
                                  else
                                    selectedWorks.remove(w);
                                }),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'المدة: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                final now = DateTime.now();
                                final r = await showDateRangePicker(
                                  context: context,
                                  firstDate: now.subtract(
                                    const Duration(days: 365),
                                  ),
                                  lastDate: now.add(
                                    const Duration(days: 365 * 3),
                                  ),
                                  initialDateRange:
                                      range ??
                                      DateTimeRange(
                                        start: now,
                                        end: now.add(const Duration(days: 1)),
                                      ),
                                );
                                if (r != null) setState(() => range = r);
                              },
                              child: Text(rangeLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: priority,
                          items: const [
                            DropdownMenuItem(
                              value: 'عالية',
                              child: Text('عالية'),
                            ),
                            DropdownMenuItem(
                              value: 'متوسطة',
                              child: Text('متوسطة'),
                            ),
                            DropdownMenuItem(
                              value: 'منخفضة',
                              child: Text('منخفضة'),
                            ),
                          ],
                          dropdownColor: Colors.white,
                          onChanged: (v) =>
                              setState(() => priority = v ?? 'متوسطة'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text(
                                'إلغاء',
                                style: TextStyle(color: darkBlue),
                              ),
                            ).withPressFX(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppButton(
                                label: 'إضافة',
                                color: darkBlue,
                                height: 44,
                                radius: BorderRadius.circular(10),
                                onPressed: () {
                                  final label = range == null
                                      ? ''
                                      : '${MaterialLocalizations.of(context).formatMediumDate(range!.start)} - ${MaterialLocalizations.of(context).formatMediumDate(range!.end)}';
                                  final item = TaskItem(
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    title: titleCtrl.text.trim(),
                                    desc: descCtrl.text.trim(),
                                    priority: priority,
                                    tags: selectedWorks.toList(),
                                    estimatedMin: 0,
                                    intlTimeLabel: label,
                                    category: selectedWorks.isNotEmpty
                                        ? selectedWorks.first
                                        : 'عمل',
                                    done: false,
                                    timerSeconds: 0,
                                  );
                                  pageContext.read<DailyTasksBloc>().add(
                                    DailyTaskAdded(item),
                                  );
                                  Navigator.pop(ctx);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _ChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesBloc, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengesInitial) {
          // lazy load
          context.read<ChallengesBloc>().add(ChallengesFetch());
        }
        if (state is ChallengesLoading)
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        if (state is ChallengesError) return Center(child: Text(state.message));
        if (state is ChallengesEmpty)
          return const Center(child: Text('لا توجد تحديات'));
        final items = (state as ChallengesSuccess).items;
        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n is OverscrollNotification &&
                n.overscroll < 0 &&
                n.metrics.extentBefore == 0) {
              final bloc = context.read<ChallengesBloc>();
              if (bloc.state is! ChallengesLoading) {
                bloc.add(ChallengesRefresh());
              }
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => ChallengeCard(item: items[i]),
          ),
        );
      },
    );
  }
}

class _TeamTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProgressBloc, TeamProgressState>(
      builder: (context, state) {
        if (state is TeamProgressInitial) {
          context.read<TeamProgressBloc>().add(TeamProgressFetch());
        }
        if (state is TeamProgressLoading)
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        if (state is TeamProgressError)
          return Center(child: Text(state.message));
        if (state is TeamProgressEmpty)
          return const Center(child: Text('لا يوجد تقدم بعد'));
        final items = (state as TeamProgressSuccess).items;
        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n is OverscrollNotification &&
                n.overscroll < 0 &&
                n.metrics.extentBefore == 0) {
              final bloc = context.read<TeamProgressBloc>();
              if (bloc.state is! TeamProgressLoading) {
                bloc.add(TeamProgressRefresh());
              }
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => TeamProgressRow(item: items[i]),
          ),
        );
      },
    );
  }
}

class _TasksLoadingSkeleton extends StatelessWidget {
  const _TasksLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _TasksErrorView extends StatelessWidget {
  final String message;

  const _TasksErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 32,
              color: const Color(0xFF64748B),
            ),
            const SizedBox(height: 8),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<TasksTabBloc>().add(TasksOverviewRequested());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text('إعادة المحاولة', style: TextStyle(fontSize: 12)),
            ).withPressFX(),
          ],
        ),
      ),
    );
  }
}

class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TabsHeaderDelegate({required this.child});
  final Widget child;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: const Color(0xFFF8FAFC),
    padding: const EdgeInsets.only(bottom: 8),
    child: child,
  );
  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
