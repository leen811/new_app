import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Meetings/meetings_bloc.dart';
import '../../Bloc/Meetings/meetings_event.dart';
import '../../Bloc/Meetings/meetings_state.dart';
import '../../Data/Repositories/meetings_repository.dart';
import '../Leaves/_widgets/segmented_tabs.dart';
import '_widgets/summary_kpi_bars.dart';
import '_widgets/filters_bar.dart';
import '_widgets/meeting_card.dart';
import '_widgets/skeleton_meetings.dart';
import '_widgets/schedule_sheet.dart';

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MeetingsBloc(MockMeetingsRepository())..add(const MeetingsLoad()),
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
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Colors.black87)),
        title: const Text('إدارة الاجتماعات', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => showScheduleMeetingSheet(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('اجتماع جديد'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MeetingsBloc, MeetingsState>(
        builder: (context, state) {
          if (state is MeetingsLoading || state is MeetingsInitial) {
            return const SkeletonMeetings();
          }
          if (state is MeetingsError) {
            return Center(child: Text(state.message));
          }
          final s = state as MeetingsLoaded;
          final tabs = [
            'القادمة (${s.kpis.scheduled})',
            'المكتملة (${s.kpis.completed})',
            'المؤرّخة',
          ];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SummaryKpiBars(kpis: s.kpis)),
              SliverPersistentHeader(
                pinned: true,
                delegate: SegmentedTabsDelegate(
                  height: 70,
                  tabs: tabs,
                  currentIndex: s.currentTab,
                  onChanged: (i) => context.read<MeetingsBloc>().add(MeetingsChangeTab(i)),
                ),
              ),
              SliverToBoxAdapter(
                child: FiltersBar(
                  query: s.query,
                  onQuery: (q) => context.read<MeetingsBloc>().add(MeetingsSearchChanged(q)),
                  onPlatform: (_) {},
                  onPriority: (_) {},
                  onRange: (_) {},
                ),
              ),
              SliverList.builder(
                itemCount: s.items.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: MeetingCard(item: s.items[i]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}


