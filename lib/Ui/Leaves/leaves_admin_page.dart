import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Leaves/leaves_bloc.dart';
import '../../Bloc/Leaves/leaves_event.dart';
import '../../Bloc/Leaves/leaves_state.dart';
import '../../Data/Repositories/leaves_repository.dart';
import '../../Data/Models/leaves_models.dart';
import 'package:google_fonts/google_fonts.dart';
import '_widgets/skeleton_leaves.dart';
import '_widgets/top_summary_cards.dart';
import '_widgets/filters_bar.dart';
import '_widgets/segmented_tabs.dart';
import '_widgets/request_card.dart';
import '_widgets/request_details_sheet.dart';
import '_widgets/team_calendar.dart';
import '_widgets/stats_section.dart';

class LeavesAdminPage extends StatelessWidget {
  const LeavesAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('إدارة الإجازات والاستئذانات', style: GoogleFonts.cairo()),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const BackButton(color: Colors.black),
        ),
        body: BlocProvider(
          create: (_) => LeavesBloc(MockLeavesRepository())..add(const LeavesLoad()),
          child: BlocConsumer<LeavesBloc, LeavesState>(
            listener: (ctx, st) {},
            builder: (ctx, st) {
              if (st is LeavesInitial || st is LeavesLoading) {
                return const LeavesSkeleton();
              }
              if (st is LeavesError) {
                return Center(child: Text(st.message));
              }
              final s = st as LeavesLoaded;
              // كشف التعارضات مع طلبات موافق عليها لنفس الموظف
              final Set<String> overlapIds = _buildOverlapIds(s.requests);
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    sliver: TopSummaryCards(
                      pending: s.summary.pending,
                      onLeaveNow: s.summary.onLeaveNow,
                      todayOut: s.summary.todayOut,
                      avgHrs: s.summary.avgResponseHrs,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: FiltersBar(
                      query: s.query,
                      selectedType: s.type,
                      selectedStatus: s.status,
                      department: s.dept,
                      range: s.range,
                      onQuery: (q) => ctx.read<LeavesBloc>().add(LeavesSearchChanged(q)),
                      onType: (t) => ctx.read<LeavesBloc>().add(LeavesFilterChanged(type: t)),
                      onStatus: (v) => ctx.read<LeavesBloc>().add(LeavesFilterChanged(status: v)),
                      onDept: (d) => ctx.read<LeavesBloc>().add(LeavesFilterChanged(dept: d)),
                      onRange: (r) => ctx.read<LeavesBloc>().add(LeavesFilterChanged(range: r)),
                    ),
                  ),

                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SegmentedTabsDelegate(
                      height: 70,
                      tabs: const ['الطلبات الواردة', 'تقويم الفريق', 'الإحصاءات'],
                      currentIndex: s.currentTab,
                      onChanged: (i) => ctx.read<LeavesBloc>().add(LeavesChangeTab(i)),
                    ),
                  ),

                  ...switch (s.currentTab) {
                    0 => [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        sliver: SliverList.separated(
                          itemCount: s.requests.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, i) => RequestCard(
                            data: s.requests[i],
                            onApprove: (id) => _noteThen(ctx, id, true),
                            onReject: (id) => _noteThen(ctx, id, false),
                            onView: (id) => _openDetails(ctx, id),
                            overlapWarning: overlapIds.contains(s.requests[i].id),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                    1 => [
                      SliverToBoxAdapter(
                        child: TeamCalendar(
                          monthEvents: s.monthEvents,
                          onMonthChanged: (y, m) => ctx.read<LeavesBloc>().add(LeavesMonthChanged(y, m)),
                          onTapRequest: (id) => _openDetails(ctx, id),
                        ),
                      ),
                    ],
                    2 => [
                      SliverToBoxAdapter(
                        child: StatsSection(data: s.requests),
                      ),
                    ],
                    _ => [const SliverToBoxAdapter(child: SizedBox.shrink())],
                  }
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _noteThen(BuildContext ctx, String id, bool approve) async {
  final controller = TextEditingController();
  final note = await showDialog<String?>(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: const Text('ملاحظة المدير (اختياري)'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'اكتب ملاحظة...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim().isEmpty ? null : controller.text.trim()), child: const Text('متابعة')),
        ],
      );
    },
  );
  if (approve) {
    ctx.read<LeavesBloc>().add(LeavesApprove(id, note: note));
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم قبول الطلب')));
  } else {
    ctx.read<LeavesBloc>().add(LeavesReject(id, note: note));
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم رفض الطلب')));
  }
}

Future<void> _openDetails(BuildContext ctx, String id) async {
  final bloc = ctx.read<LeavesBloc>();
  LeaveRequest? item;
  try {
    item = await bloc.repository.getById(id);
  } catch (_) {}
  if (item == null) return;
  // BottomSheet
  showModalBottomSheet(
    context: ctx,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) => RequestDetailsSheet(data: item!),
  );
}

Set<String> _buildOverlapIds(List<LeaveRequest> requests) {
  final approved = requests.where((e) => e.status == LeaveStatus.approved).toList();
  final Set<String> ids = {};
  for (final r in requests.where((e) => e.status == LeaveStatus.pending)) {
    for (final a in approved) {
      if (a.employeeId != r.employeeId) continue;
      final noOverlap = r.endAt.isBefore(a.startAt) || r.startAt.isAfter(a.endAt);
      if (!noOverlap) {
        ids.add(r.id);
        break;
      }
    }
  }
  return ids;
}


