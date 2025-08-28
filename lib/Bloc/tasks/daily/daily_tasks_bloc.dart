import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../../Data/Repositories/tasks_repository.dart';
import 'daily_tasks_event.dart';
import 'daily_tasks_state.dart';

class DailyTasksBloc extends Bloc<DailyTasksEvent, DailyTasksState> {
  final ITasksRepository repository;
  DailyTasksBloc(this.repository) : super(DailyTasksInitial()) {
    on<DailyTasksFetch>(_onFetch);
    on<DailyTasksRefresh>(_onFetch);
    on<DailyTaskToggleComplete>(_onToggle);
    on<DailyTaskTimerStart>(_onTimerStart);
    on<DailyTaskTimerStop>(_onTimerStop);
    on<DailyTaskTicked>(_onTicked);
    on<DailyTaskAdded>(_onAdded);
    on<DailyTaskUpdated>(_onUpdated);
  }

  final Map<String, Timer> _timers = {};

  Future<void> _onFetch(DailyTasksEvent event, Emitter<DailyTasksState> emit) async {
    emit(DailyTasksLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final items = await repository.fetchDailyTasks();
      if (items.isEmpty) emit(DailyTasksEmpty()); else emit(DailyTasksSuccess(items));
    } catch (e) {
      emit(const DailyTasksError('تعذر تحميل مهام اليوم'));
    }
  }

  Future<void> _onToggle(DailyTaskToggleComplete event, Emitter<DailyTasksState> emit) async {
    if (state is! DailyTasksSuccess) return;
    final list = List.of((state as DailyTasksSuccess).items);
    final idx = list.indexWhere((e) => e.id == event.id);
    if (idx == -1) return;
    final newDone = !list[idx].done;
    list[idx] = list[idx].copyWith(done: newDone);
    emit(DailyTasksSuccess(list));
    await repository.toggleComplete(event.id, newDone);
  }

  Future<void> _onTimerStart(DailyTaskTimerStart event, Emitter<DailyTasksState> emit) async {
    if (state is! DailyTasksSuccess) return;
    final list = List.of((state as DailyTasksSuccess).items);
    final idx = list.indexWhere((e) => e.id == event.id);
    if (idx != -1) {
      list[idx] = list[idx].copyWith(isRunning: true);
      emit(DailyTasksSuccess(list));
    }
    _timers[event.id]?.cancel();
    _timers[event.id] = Timer.periodic(const Duration(seconds: 1), (_) {
      add(DailyTaskTicked(event.id));
    });
    await repository.startTimer(event.id);
  }

  Future<void> _onTimerStop(DailyTaskTimerStop event, Emitter<DailyTasksState> emit) async {
    _timers[event.id]?.cancel();
    _timers.remove(event.id);
    if (state is DailyTasksSuccess) {
      final list = List.of((state as DailyTasksSuccess).items);
      final idx = list.indexWhere((e) => e.id == event.id);
      if (idx != -1) {
        list[idx] = list[idx].copyWith(isRunning: false);
        emit(DailyTasksSuccess(list));
      }
    }
    final seconds = (state is DailyTasksSuccess)
        ? ((state as DailyTasksSuccess).items.firstWhere((e) => e.id == event.id, orElse: () => (state as DailyTasksSuccess).items.first).timerSeconds)
        : 0;
    await repository.stopTimer(event.id, seconds);
  }

  Future<void> _onTicked(DailyTaskTicked event, Emitter<DailyTasksState> emit) async {
    if (state is! DailyTasksSuccess) return;
    final list = List.of((state as DailyTasksSuccess).items);
    final idx = list.indexWhere((e) => e.id == event.id);
    if (idx == -1) return;
    list[idx] = list[idx].copyWith(timerSeconds: list[idx].timerSeconds + 1, isRunning: true);
    emit(DailyTasksSuccess(list));
  }

  Future<void> _onAdded(DailyTaskAdded event, Emitter<DailyTasksState> emit) async {
    final current = state;
    if (current is DailyTasksSuccess) {
      final list = List.of(current.items)..insert(0, event.item);
      emit(DailyTasksSuccess(list));
    }
  }

  Future<void> _onUpdated(DailyTaskUpdated event, Emitter<DailyTasksState> emit) async {
    final current = state;
    if (current is DailyTasksSuccess) {
      final list = List.of(current.items);
      final idx = list.indexWhere((e) => e.id == event.item.id);
      if (idx != -1) {
        list[idx] = event.item;
        emit(DailyTasksSuccess(list));
      }
    }
  }
}


