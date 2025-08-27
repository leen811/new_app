import 'package:bloc/bloc.dart';
import '../../Data/Repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final ITasksRepository repository;
  TasksBloc(this.repository) : super(TasksInitial()) {
    on<TasksFetch>(_onFetch);
    on<TasksToggleDone>(_onToggle);
  }

  Future<void> _onFetch(TasksFetch event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final tasks = await repository.fetchTasks();
      if (tasks.isEmpty) emit(TasksEmpty()); else emit(TasksLoaded(tasks));
    } catch (e) {
      emit(const TasksError('تعذر تحميل المهام'));
    }
  }

  Future<void> _onToggle(TasksToggleDone event, Emitter<TasksState> emit) async {
    if (state is! TasksLoaded) return;
    final current = (state as TasksLoaded).tasks.map((e) => Map<String, dynamic>.from(e)).toList();
    final idx = current.indexWhere((t) => t['id'] == event.id);
    if (idx != -1) {
      current[idx]['done'] = !(current[idx]['done'] as bool);
      emit(TasksLoaded(current));
    }
  }
}


