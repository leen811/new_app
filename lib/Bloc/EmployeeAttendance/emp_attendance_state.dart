import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../Data/Models/attendance_models.dart';

abstract class EmpAttendanceState extends Equatable {
  const EmpAttendanceState();
  @override
  List<Object?> get props => [];
}

class EmpInitial extends EmpAttendanceState { const EmpInitial(); }
class EmpLoading extends EmpAttendanceState { const EmpLoading(); }

class EmpLoaded extends EmpAttendanceState {
  final String employeeId;
  final DateTime anchor;
  final DateTimeRange? range;
  final int selectedIndex;
  final int tabIndex;
  final EmployeeWeekAttendance week;
  final WeekOverview overview;
  const EmpLoaded({required this.employeeId, required this.anchor, required this.range, required this.selectedIndex, required this.tabIndex, required this.week, required this.overview});
  EmpLoaded copyWith({String? employeeId, DateTime? anchor, DateTimeRange? range, int? selectedIndex, int? tabIndex, EmployeeWeekAttendance? week, WeekOverview? overview}) => EmpLoaded(
    employeeId: employeeId ?? this.employeeId,
    anchor: anchor ?? this.anchor,
    range: range ?? this.range,
    selectedIndex: selectedIndex ?? this.selectedIndex,
    tabIndex: tabIndex ?? this.tabIndex,
    week: week ?? this.week,
    overview: overview ?? this.overview,
  );
  @override
  List<Object?> get props => [employeeId, anchor, range, selectedIndex, tabIndex, week, overview];
}

class EmpError extends EmpAttendanceState { final String message; const EmpError(this.message); @override List<Object?> get props => [message]; }


