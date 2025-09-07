import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../Data/Models/leaves_models.dart';

abstract class LeavesEvent extends Equatable {
  const LeavesEvent();
  @override
  List<Object?> get props => [];
}

class LeavesLoad extends LeavesEvent {
  const LeavesLoad();
}

class LeavesChangeTab extends LeavesEvent {
  final int index;
  const LeavesChangeTab(this.index);
  @override
  List<Object?> get props => [index];
}

class LeavesSearchChanged extends LeavesEvent {
  final String query;
  const LeavesSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class LeavesFilterChanged extends LeavesEvent {
  final LeaveType? type;
  final LeaveStatus? status;
  final String? dept;
  final DateTimeRange? range;
  const LeavesFilterChanged({this.type, this.status, this.dept, this.range});
  @override
  List<Object?> get props => [type, status, dept, range];
}

class LeavesApprove extends LeavesEvent {
  final String id;
  final String? note;
  const LeavesApprove(this.id, {this.note});
  @override
  List<Object?> get props => [id, note];
}

class LeavesReject extends LeavesEvent {
  final String id;
  final String? note;
  const LeavesReject(this.id, {this.note});
  @override
  List<Object?> get props => [id, note];
}

class LeavesViewDetails extends LeavesEvent {
  final String id;
  const LeavesViewDetails(this.id);
  @override
  List<Object?> get props => [id];
}

class LeavesMonthChanged extends LeavesEvent {
  final int year;
  final int month;
  const LeavesMonthChanged(this.year, this.month);
  @override
  List<Object?> get props => [year, month];
}


