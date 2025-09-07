import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Models/leaves_models.dart';
import '../../Data/Repositories/leaves_repository.dart';
import 'leaves_event.dart';
import 'leaves_state.dart';

class LeavesBloc extends Bloc<LeavesEvent, LeavesState> {
  final LeavesRepository repository;

  // مخزن عوامل التصفية
  String _query = '';
  LeaveType? _type;
  LeaveStatus? _status;
  String? _dept;
  DateTimeRange? _range;

  int _currentTab = 0;

  LeavesBloc(this.repository) : super(const LeavesInitial()) {
    on<LeavesLoad>(_onLoad);
    on<LeavesChangeTab>(_onChangeTab);
    on<LeavesSearchChanged>(_onSearch);
    on<LeavesFilterChanged>(_onFilter);
    on<LeavesApprove>(_onApprove);
    on<LeavesReject>(_onReject);
    on<LeavesMonthChanged>(_onMonth);
    // LeavesViewDetails handled in UI via bottom sheet
  }

  Future<void> _onLoad(LeavesLoad event, Emitter<LeavesState> emit) async {
    emit(const LeavesLoading());
    try {
      final (summary, items) = await repository.fetch(
        query: _query, type: _type, status: _status, department: _dept, range: _range,
      );
      final now = DateTime.now();
      final events = await repository.fetchCalendarMonth(year: now.year, month: now.month, department: _dept);
      emit(LeavesLoaded(
        currentTab: _currentTab,
        summary: summary,
        query: _query,
        type: _type,
        status: _status,
        dept: _dept,
        range: _range,
        requests: items,
        monthEvents: events,
      ));
    } catch (e) {
      emit(LeavesError('فشل تحميل البيانات'));
    }
  }

  Future<void> _onChangeTab(LeavesChangeTab event, Emitter<LeavesState> emit) async {
    _currentTab = event.index;
    final s = state;
    if (s is LeavesLoaded) {
      emit(s.copyWith(currentTab: _currentTab));
    }
  }

  Future<void> _onSearch(LeavesSearchChanged event, Emitter<LeavesState> emit) async {
    _query = event.query;
    await _refetch(emit);
  }

  Future<void> _onFilter(LeavesFilterChanged event, Emitter<LeavesState> emit) async {
    _type = event.type ?? _type;
    _status = event.status ?? _status;
    _dept = event.dept ?? _dept;
    _range = event.range ?? _range;
    await _refetch(emit);
  }

  Future<void> _onApprove(LeavesApprove event, Emitter<LeavesState> emit) async {
    try {
      await repository.approve(id: event.id, managerNote: event.note);
      await _refetch(emit, keepLoading: true);
    } catch (e) {
      // ignore for mock
    }
  }

  Future<void> _onReject(LeavesReject event, Emitter<LeavesState> emit) async {
    try {
      await repository.reject(id: event.id, managerNote: event.note);
      await _refetch(emit, keepLoading: true);
    } catch (e) {
      // ignore for mock
    }
  }

  Future<void> _onMonth(LeavesMonthChanged event, Emitter<LeavesState> emit) async {
    final s = state;
    if (s is! LeavesLoaded) return;
    final events = await repository.fetchCalendarMonth(year: event.year, month: event.month, department: _dept);
    emit(s.copyWith(monthEvents: events));
  }

  Future<void> _refetch(Emitter<LeavesState> emit, {bool keepLoading = false}) async {
    if (!keepLoading) emit(const LeavesLoading());
    try {
      final (summary, items) = await repository.fetch(
        query: _query, type: _type, status: _status, department: _dept, range: _range,
      );
      final now = DateTime.now();
      final events = await repository.fetchCalendarMonth(year: now.year, month: now.month, department: _dept);
      emit(LeavesLoaded(
        currentTab: _currentTab,
        summary: summary,
        query: _query,
        type: _type,
        status: _status,
        dept: _dept,
        range: _range,
        requests: items,
        monthEvents: events,
      ));
    } catch (e) {
      emit(LeavesError('فشل تحميل البيانات'));
    }
  }
}


