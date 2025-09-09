import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../Data/Models/l4l_models.dart';
import '../../Data/Repositories/l4l_repository.dart';
import 'l4l_event.dart';
import 'l4l_state.dart';

class L4LBloc extends Bloc<L4LEvent, L4LState> {
  final L4LRepository repository;

  L4LBloc({required this.repository}) : super(L4LInitial()) {
    on<L4LLoad>(_onLoad);
    on<L4LChangePeriod>(_onChangePeriod);
    on<L4LChangeCompare>(_onChangeCompare);
    on<L4LChangeLevel>(_onChangeLevel);
    on<L4LChangeRange>(_onChangeRange);
    on<L4LRefresh>(_onRefresh);
  }

  List<KpiDefinition> get _defaultKpis => const [
        KpiDefinition(key: 'revenue_total', title: 'revenue_total'),
        KpiDefinition(key: 'revenue_by_department', title: 'revenue_by_department'),
        KpiDefinition(key: 'attendance_support', title: 'attendance_support'),
        KpiDefinition(key: 'avg_completion_time', title: 'avg_completion_time', isInverted: true),
        KpiDefinition(key: 'challenges_engagement', title: 'challenges_engagement'),
      ];

  Future<void> _onLoad(L4LLoad event, Emitter<L4LState> emit) async {
    emit(L4LLoading());
    try {
      final period = L4LPeriod.week;
      final compare = L4LCompare.week_vs_prev_week;
      final level = L4LLevel.organization;
      final range = _defaultRange(period);
      final defs = _defaultKpis;
      final data = await repository.fetch(period: period, compare: compare, level: level, range: range, kpiKeys: defs.map((e) => e.key).toList());
      emit(L4LLoaded(period: period, compare: compare, level: level, levelId: null, range: range, kpiDefs: defs, data: data, breadcrumb: const [L4LLevel.organization]));
    } catch (e) {
      emit(L4LError(e.toString()));
    }
  }

  Future<void> _onChangePeriod(L4LChangePeriod event, Emitter<L4LState> emit) async {
    final current = state is L4LLoaded ? state as L4LLoaded : null;
    if (current == null) return;
    emit(L4LLoading());
    final newRange = _defaultRange(event.period);
    final data = await repository.fetch(period: event.period, compare: current.compare, level: current.level, levelId: current.levelId, range: newRange, kpiKeys: current.kpiDefs.map((e) => e.key).toList());
    emit(current.copyWith(period: event.period, range: newRange, data: data));
  }

  Future<void> _onChangeCompare(L4LChangeCompare event, Emitter<L4LState> emit) async {
    final current = state is L4LLoaded ? state as L4LLoaded : null;
    if (current == null) return;
    emit(L4LLoading());
    final data = await repository.fetch(period: current.period, compare: event.compare, level: current.level, levelId: current.levelId, range: current.range, kpiKeys: current.kpiDefs.map((e) => e.key).toList());
    emit(current.copyWith(compare: event.compare, data: data));
  }

  Future<void> _onChangeLevel(L4LChangeLevel event, Emitter<L4LState> emit) async {
    final current = state is L4LLoaded ? state as L4LLoaded : null;
    if (current == null) return;
    emit(L4LLoading());
    final data = await repository.fetch(period: current.period, compare: current.compare, level: event.level, levelId: event.id, range: current.range, kpiKeys: current.kpiDefs.map((e) => e.key).toList());
    final updatedCrumbs = _rebuildCrumbs(event.level);
    emit(current.copyWith(level: event.level, levelId: event.id, data: data, breadcrumb: updatedCrumbs));
  }

  Future<void> _onChangeRange(L4LChangeRange event, Emitter<L4LState> emit) async {
    final current = state is L4LLoaded ? state as L4LLoaded : null;
    if (current == null) return;
    emit(L4LLoading());
    final data = await repository.fetch(period: current.period, compare: current.compare, level: current.level, levelId: current.levelId, range: event.range, kpiKeys: current.kpiDefs.map((e) => e.key).toList());
    emit(current.copyWith(range: event.range, data: data));
  }

  Future<void> _onRefresh(L4LRefresh event, Emitter<L4LState> emit) async {
    final current = state is L4LLoaded ? state as L4LLoaded : null;
    if (current == null) return;
    emit(L4LLoading());
    final data = await repository.fetch(period: current.period, compare: current.compare, level: current.level, levelId: current.levelId, range: current.range, kpiKeys: current.kpiDefs.map((e) => e.key).toList());
    emit(current.copyWith(data: data));
  }

  DateTimeRange _defaultRange(L4LPeriod p) {
    final now = DateTime.now();
    switch (p) {
      case L4LPeriod.day:
        return DateTimeRange(start: DateTime(now.year, now.month, now.day), end: DateTime(now.year, now.month, now.day, 23, 59, 59));
      case L4LPeriod.week:
        final start = now.subtract(Duration(days: now.weekday % 7));
        final end = start.add(const Duration(days: 6, hours: 23, minutes: 59));
        return DateTimeRange(start: DateTime(start.year, start.month, start.day), end: end);
      case L4LPeriod.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
      case L4LPeriod.year:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
    }
  }

  List<L4LLevel> _rebuildCrumbs(L4LLevel to) {
    const path = [
      L4LLevel.organization,
      L4LLevel.branch,
      L4LLevel.department,
      L4LLevel.team,
      L4LLevel.employee,
    ];
    final idx = path.indexOf(to);
    return path.take(idx + 1).toList();
  }
}


