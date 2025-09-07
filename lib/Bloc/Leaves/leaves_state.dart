import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../Data/Models/leaves_models.dart';

abstract class LeavesState extends Equatable {
  const LeavesState();
  @override
  List<Object?> get props => [];
}

class LeavesInitial extends LeavesState {
  const LeavesInitial();
}

class LeavesLoading extends LeavesState {
  const LeavesLoading();
}

class LeavesLoaded extends LeavesState {
  final int currentTab; // 0 الطلبات 1 التقويم 2 الإحصاءات
  final LeavesSummary summary;
  final String query;
  final LeaveType? type;
  final LeaveStatus? status;
  final String? dept;
  final DateTimeRange? range;
  final List<LeaveRequest> requests;
  final List<LeaveRequest> monthEvents;

  const LeavesLoaded({
    required this.currentTab,
    required this.summary,
    required this.query,
    required this.type,
    required this.status,
    required this.dept,
    required this.range,
    required this.requests,
    required this.monthEvents,
  });

  LeavesLoaded copyWith({
    int? currentTab,
    LeavesSummary? summary,
    String? query,
    LeaveType? type,
    LeaveStatus? status,
    String? dept,
    DateTimeRange? range,
    List<LeaveRequest>? requests,
    List<LeaveRequest>? monthEvents,
  }) => LeavesLoaded(
        currentTab: currentTab ?? this.currentTab,
        summary: summary ?? this.summary,
        query: query ?? this.query,
        type: type ?? this.type,
        status: status ?? this.status,
        dept: dept ?? this.dept,
        range: range ?? this.range,
        requests: requests ?? this.requests,
        monthEvents: monthEvents ?? this.monthEvents,
      );

  @override
  List<Object?> get props => [currentTab, summary, query, type, status, dept, range, requests, monthEvents];
}

class LeavesError extends LeavesState {
  final String message;
  const LeavesError(this.message);
  @override
  List<Object?> get props => [message];
}


