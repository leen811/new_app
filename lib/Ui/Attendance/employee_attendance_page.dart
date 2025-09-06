import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/EmployeeAttendance/emp_attendance_bloc.dart';
import '../../Bloc/EmployeeAttendance/emp_attendance_event.dart';
import '../../Bloc/EmployeeAttendance/emp_attendance_state.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '_widgets/date_range_chip.dart';
import '_widgets/week_selector.dart';
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
      appBar: AppBar(title: Text('حضور $name'), centerTitle: true, leading: const BackButton()),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => EmpAttendanceBloc(MockAttendanceDataRepository())..add(EmpLoadWeek(employeeId: employeeId, anchor: DateTime.now())),
          child: BlocBuilder<EmpAttendanceBloc, EmpAttendanceState>(
            builder: (context, state) {
              if (state is EmpLoading || state is EmpInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is EmpError) {
                return Center(child: Text(state.message));
              }
              final s = state as EmpLoaded;
              final days = s.week.days.map((d) => d.day).toList();
              // final sessions = s.week.days[s.selectedIndex].sessions;
              String fmtDur(Duration d){final h=d.inHours;final m=(d.inMinutes%60).toString().padLeft(2,'0');return '$h:$m';}
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  Row(
                    children: [
                      DateRangeChip(
                        range: s.range,
                        onPick: () async {
                          final picked = await showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), locale: const Locale('ar'));
                          if (picked != null) context.read<EmpAttendanceBloc>().add(EmpChangeRange(picked));
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: WeekSelector(days: days, currentIndex: s.selectedIndex, onChanged: (i) => context.read<EmpAttendanceBloc>().add(EmpSelectDay(i)))),
                    ],
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


