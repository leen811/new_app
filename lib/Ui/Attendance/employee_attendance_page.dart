import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/EmployeeAttendance/emp_attendance_bloc.dart';
import '../../Bloc/EmployeeAttendance/emp_attendance_event.dart';
import '../../Bloc/EmployeeAttendance/emp_attendance_state.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '_widgets/session_card.dart';
import '_widgets/kpi_small_card.dart';
import '_widgets/day_work_row.dart';

class EmployeeAttendancePage extends StatelessWidget {
  final String employeeId;
  final String name;
  final String? avatarUrl;
  const EmployeeAttendancePage({super.key, required this.employeeId, required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('$name', style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => EmpAttendanceBloc(MockAttendanceDataRepository())..add(EmpLoadWeek(employeeId: employeeId, anchor: DateTime.now())),
          child: BlocBuilder<EmpAttendanceBloc, EmpAttendanceState>(
            builder: (context, state) {
              if (state is EmpLoading || state is EmpInitial) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: const [
                    _SkeletonBar(),
                    SizedBox(height: 12),
                    _SkeletonTabs(),
                    SizedBox(height: 12),
                    _SkeletonRow(),
                    SizedBox(height: 10),
                    _SkeletonRow(),
                    SizedBox(height: 10),
                    _SkeletonRow(),
                  ],
                );
              }
              if (state is EmpError) {
                return Center(child: Text(state.message));
              }
              final s = state as EmpLoaded;
              // final days = s.week.days.map((d) => d.day).toList();
              // final sessions = s.week.days[s.selectedIndex].sessions;
              String fmtDur(Duration d){final h=d.inHours;final m=(d.inMinutes%60).toString().padLeft(2,'0');return '$h:$m';}
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _WeekNavBar(
                    range: s.range,
                    anchor: s.anchor,
                    onPrev: () {
                      final prev = s.anchor.subtract(const Duration(days: 7));
                      context.read<EmpAttendanceBloc>().add(EmpLoadWeek(employeeId: s.employeeId, anchor: prev));
                    },
                    onNext: () {
                      final next = s.anchor.add(const Duration(days: 7));
                      context.read<EmpAttendanceBloc>().add(EmpLoadWeek(employeeId: s.employeeId, anchor: next));
                    },
                    onPick: () async {
                      final picked = await showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), locale: const Locale('ar'));
                      if (picked != null) context.read<EmpAttendanceBloc>().add(EmpChangeRange(picked));
                    },
                  ),
                  const SizedBox(height: 12),
                  // Segmented tabs (Overview / Work Hours)
                  Container(
                    height: 40,
                    decoration: BoxDecoration(color: const Color(0xFFF3F6FC), borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Expanded(child: _segTab(context, 'Overview', s.tabIndex==0, ()=>context.read<EmpAttendanceBloc>().add(const EmpChangeTab(0)))) ,
                      Expanded(child: _segTab(context, 'Work Hours', s.tabIndex==1, ()=>context.read<EmpAttendanceBloc>().add(const EmpChangeTab(1)))),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  if (s.tabIndex==0) ...[
                    // Overview
                    Row(children:[
                      Expanded(child: AttKpiSmallCard(label: 'ساعات العمل (صافي)', value: fmtDur(s.overview.workNet))),
                      const SizedBox(width:12),
                      Expanded(child: AttKpiSmallCard(label: 'ساعات العمل (إجمالي)', value: fmtDur(s.overview.workGross))),
                    ]),
                    const SizedBox(height: 12),
                    Row(children:[
                      Expanded(child: AttKpiSmallCard(label: 'إجمالي البريك', value: fmtDur(s.overview.breaks))),
                      const SizedBox(width:12),
                      Expanded(child: AttKpiSmallCard(label: 'الأوفر تايم', value: fmtDur(s.overview.overtime))),
                    ]),
                    const SizedBox(height: 12),
                    Row(children:[
                      _statusBadgeWidget('مكتمل', s.overview.daysCompleted, const Color(0xFF16A34A)),
                      const SizedBox(width: 8),
                      _statusBadgeWidget('جزئي', s.overview.daysPartial, const Color(0xFFF59E0B)),
                      const SizedBox(width: 8),
                      _statusBadgeWidget('غائب', s.overview.daysAbsent, const Color(0xFF9AA3B2)),
                    ]),
                  ] else ...[
                    // Work Hours list
                    ...s.week.days.map((d)=> DayWorkRow(day: d, shiftMinutes: 8*60, onTap: (){
                      // show details bottom sheet
                      showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), builder: (_){
                        return Directionality(textDirection: TextDirection.rtl, child: Padding(padding: const EdgeInsets.fromLTRB(16,12,16,24), child: ListView(children: d.sessions.isEmpty? [const Text('لا سجلات لهذا اليوم')] : d.sessions.map((ss)=> SessionCard(session: ss)).toList())));
                      });
                    })),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _segTab(BuildContext context, String label, bool selected, VoidCallback onTap){
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(color: selected? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: selected?[BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0,2))]:null),
        child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: selected? Theme.of(context).colorScheme.primary: const Color(0xFF6B7280)))),
      ),
    ),
  );
}

Widget _statusBadgeWidget(String label, int value, Color color){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(12)),
    child: Row(children:[
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text('$label: $value', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _WeekNavBar extends StatelessWidget {
  final DateTimeRange? range;
  final DateTime anchor;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onPick;
  const _WeekNavBar({required this.range, required this.anchor, required this.onPrev, required this.onNext, required this.onPick});
  @override
  Widget build(BuildContext context) {
    // إذا كان هناك Range مخصص نعرضه، وإلا نعرض أسبوع الأحد-السبت حول الـ anchor
    DateTime start;
    DateTime end;
    if (range != null) {
      start = DateTime(range!.start.year, range!.start.month, range!.start.day);
      end = DateTime(range!.end.year, range!.end.month, range!.end.day);
    } else {
      final weekday = anchor.weekday; // 1=Mon..7=Sun
      start = DateTime(anchor.year, anchor.month, anchor.day).subtract(Duration(days: weekday % 7));
      end = start.add(const Duration(days: 6));
    }

    String fmt(DateTime d) => '${d.year}/${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}';
    final label = '${fmt(start)} - ${fmt(end)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Row(
        children: [
          // في RTL: زر اليمين يعني أسبوع سابق
          IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left_rounded)),
          Expanded(
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          // في RTL: زر اليسار يعني أسبوع لاحق
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right_rounded)),
        ],
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar();
  @override
  Widget build(BuildContext context) => Container(height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)));
}

class _SkeletonTabs extends StatelessWidget {
  const _SkeletonTabs();
  @override
  Widget build(BuildContext context) => Container(height: 40, decoration: BoxDecoration(color: const Color(0xFFF3F6FC), borderRadius: BorderRadius.circular(12)));
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();
  @override
  Widget build(BuildContext context) => Row(children: const [
        Expanded(child: _SkeletonCard()),
        SizedBox(width: 12),
        Expanded(child: _SkeletonCard()),
      ]);
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();
  @override
  Widget build(BuildContext context) => Container(height: 64, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)));
}


