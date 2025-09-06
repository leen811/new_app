import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class EmpAttendanceEvent extends Equatable {
  const EmpAttendanceEvent();
  @override
  List<Object?> get props => [];
}

class EmpLoadWeek extends EmpAttendanceEvent {
  final String employeeId; final DateTime anchor; final DateTimeRange? range;
  const EmpLoadWeek({required this.employeeId, required this.anchor, this.range});
  @override
  List<Object?> get props => [employeeId, anchor, range];
}

class EmpChangeRange extends EmpAttendanceEvent {
  final DateTimeRange range; const EmpChangeRange(this.range);
  @override
  List<Object?> get props => [range];
}

class EmpSelectDay extends EmpAttendanceEvent {
  final int index; const EmpSelectDay(this.index);
  @override
  List<Object?> get props => [index];
}

class EmpChangeTab extends EmpAttendanceEvent {
  final int index; const EmpChangeTab(this.index);
  @override
  List<Object?> get props => [index];
}


