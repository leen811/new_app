import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/attendance_repository.dart';
import 'emp_attendance_event.dart';
import 'emp_attendance_state.dart';
import '../../Data/Models/attendance_models.dart';

class EmpAttendanceBloc extends Bloc<EmpAttendanceEvent, EmpAttendanceState> {
  final AttendanceDataRepository repository;
  EmpAttendanceBloc(this.repository) : super(const EmpInitial()) {
    on<EmpLoadWeek>(_onLoadWeek);
    on<EmpChangeRange>(_onChangeRange);
    on<EmpSelectDay>(_onSelectDay);
    on<EmpChangeTab>(_onChangeTab);
  }

  Future<void> _onLoadWeek(EmpLoadWeek event, Emitter<EmpAttendanceState> emit) async {
    // لا تُظهر شاشة تحميل كاملة عند التبديل بين الأسابيع،
    // أظهر التحميل فقط إذا لم تكن هناك بيانات سابقة
    if (state is EmpInitial) {
      emit(const EmpLoading());
    }
    try {
      final week = await repository.fetchEmployeeWeek(employeeId: event.employeeId, anchor: event.anchor, range: event.range);
      // اختر اليوم الحالي داخل الأسبوع إن أمكن
      final today = DateTime.now();
      int index = week.days.indexWhere((d) => _isSameDate(d.day, today));
      if (index < 0) index = 0;
      // احتفظ بالتبويب الحالي ان وُجد
      final previousTabIndex = state is EmpLoaded ? (state as EmpLoaded).tabIndex : 0;
      final overview = _computeOverview(week);
      emit(EmpLoaded(employeeId: event.employeeId, anchor: event.anchor, range: event.range, selectedIndex: index, tabIndex: previousTabIndex, week: week, overview: overview));
    } catch (e) {
      emit(EmpError(e.toString()));
    }
  }

  Future<void> _onChangeRange(EmpChangeRange event, Emitter<EmpAttendanceState> emit) async {
    if (state is EmpLoaded) {
      final s = state as EmpLoaded;
      // اجعل مرساة الأسبوع بداية الفترة لضمان توحيد العرض في Overview و Work Hours
      add(EmpLoadWeek(employeeId: s.employeeId, anchor: event.range.start, range: event.range));
    }
  }

  void _onSelectDay(EmpSelectDay event, Emitter<EmpAttendanceState> emit) {
    if (state is EmpLoaded) {
      final s = state as EmpLoaded;
      emit(s.copyWith(selectedIndex: event.index));
    }
  }

  void _onChangeTab(EmpChangeTab event, Emitter<EmpAttendanceState> emit) {
    if (state is EmpLoaded) {
      final s = state as EmpLoaded;
      emit(s.copyWith(selectedIndex: s.selectedIndex, tabIndex: event.index));
    }
  }

  WeekOverview _computeOverview(EmployeeWeekAttendance week) {
    const int shiftMinutes = 8 * 60;
    int gross = 0, breaks = 0, net = 0, overtime = 0;
    int completed = 0, partial = 0, absent = 0;
    for (final d in week.days) {
      int dayGross = 0, dayBreaks = 0;
      if (d.sessions.isEmpty) {
        absent++;
        continue;
      }
      for (final s in d.sessions) {
        dayGross += s.outAt.difference(s.inAt).inMinutes;
        dayBreaks += s.breaksMinutes;
      }
      final dayNet = dayGross - dayBreaks;
      if (dayNet >= shiftMinutes) completed++; else if (dayNet > 0) partial++; else absent++;
      gross += dayGross; breaks += dayBreaks; net += dayNet;
      overtime += (dayNet - shiftMinutes) > 0 ? (dayNet - shiftMinutes) : 0;
    }
    return WeekOverview(
      workNet: Duration(minutes: net),
      workGross: Duration(minutes: gross),
      breaks: Duration(minutes: breaks),
      overtime: Duration(minutes: overtime),
      daysCompleted: completed,
      daysPartial: partial,
      daysAbsent: absent,
    );
  }

  // بناء الملخص اليومي لتبويب Work Hours
  List<DaySummary> computeDaySummaries(EmployeeWeekAttendance week) {
    const int shiftMinutes = 8 * 60;
    return week.days.map((d){
      if (d.sessions.isEmpty) {
        return DaySummary(day: d.day, firstIn: null, firstOut: null, breakDur: Duration.zero, netDur: Duration.zero, overtime: Duration.zero, status: DayStatus.absent);
      }
      d.sessions.sort((a,b)=> a.inAt.compareTo(b.inAt));
      final first = d.sessions.first;
      int gross = 0, breaks = 0;
      for (final s in d.sessions){
        gross += s.outAt.difference(s.inAt).inMinutes;
        breaks += s.breaksMinutes;
      }
      final net = gross - breaks;
      final status = net >= shiftMinutes ? DayStatus.completed : (net>0 ? DayStatus.partial : DayStatus.absent);
      final overtime = net > shiftMinutes ? net - shiftMinutes : 0;
      return DaySummary(
        day: d.day,
        firstIn: first.inAt,
        firstOut: first.outAt,
        breakDur: Duration(minutes: breaks),
        netDur: Duration(minutes: net),
        overtime: Duration(minutes: overtime),
        status: status,
      );
    }).toList();
  }
  bool _isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}


