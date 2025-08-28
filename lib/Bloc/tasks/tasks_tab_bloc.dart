import 'package:bloc/bloc.dart';

import '../../Data/Repositories/tasks_repository.dart';
import 'tasks_tab_event.dart';
import 'tasks_tab_state.dart';

class TasksTabBloc extends Bloc<TasksTabEvent, TasksTabState> {
  final ITasksRepository repository;
  TasksTabBloc(this.repository) : super(TasksTabInitial()) {
    on<TasksTabChanged>(_onTabChanged);
    on<TasksOverviewRequested>(_onOverview);
  }

  Future<void> _onTabChanged(TasksTabChanged event, Emitter<TasksTabState> emit) async {
    final s = state;
    if (s is TasksTabSuccess) {
      emit(s.copyWith(index: event.index));
    } else {
      emit(TasksTabSuccess(index: event.index));
    }
  }

  Future<void> _onOverview(TasksOverviewRequested event, Emitter<TasksTabState> emit) async {
    final current = state is TasksTabSuccess ? state as TasksTabSuccess : TasksTabSuccess(index: 0);
    emit(current.copyWith(loadingOverview: true));
    try {
      final o = await repository.fetchOverview();
      emit(current.copyWith(overview: o, loadingOverview: false));
    } catch (e) {
      emit(TasksTabError('تعذر تحميل المؤشرات'));
    }
  }
}


