import 'package:bloc/bloc.dart';
import '../../Data/Repositories/team_tasks_repository.dart';
import '../../Data/Models/team_tasks_models.dart';
import 'team_tasks_event.dart';
import 'team_tasks_state.dart';

class TeamTasksBloc extends Bloc<TeamTasksEvent, TeamTasksState> {
  final TeamTasksRepository repository;
  String _query = '';
  String _filter = 'all';
  List<TaskItem> _items = const [];
  TasksSummary _summary = const TasksSummary(total: 0, inProgress: 0, todo: 0, review: 0, overdue: 0, done: 0);

  TeamTasksBloc(this.repository) : super(TasksInitial()) {
    on<TasksLoad>(_onLoad);
    on<TasksSearchChanged>(_onSearch);
    on<TasksFilterChanged>(_onFilter);
    on<TasksProgressChanged>(_onProgress);
    on<TaskStatusChanged>(_onStatusChanged);
    on<TaskSendMessage>(_onSendMessage);
    on<TaskOpenDetails>(_onOpenDetails);
    on<TaskCreateSubmitted>(_onCreateSubmitted);
  }

  Future<void> _onLoad(TasksLoad event, Emitter<TeamTasksState> emit) async {
    emit(TasksLoading());
    try {
      final (sum, list) = await repository.fetch(query: _query, filter: _filter);
      _summary = sum;
      _items = list;
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    } catch (e) {
      emit(const TasksError('تعذر تحميل المهام'));
    }
  }

  Future<void> _onSearch(TasksSearchChanged event, Emitter<TeamTasksState> emit) async {
    _query = event.query;
    try {
      final (sum, list) = await repository.fetch(query: _query, filter: _filter);
      _summary = sum;
      _items = list;
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    } catch (e) {
      emit(const TasksError('تعذر البحث في المهام'));
    }
  }

  Future<void> _onFilter(TasksFilterChanged event, Emitter<TeamTasksState> emit) async {
    _filter = event.filter;
    try {
      final (sum, list) = await repository.fetch(query: _query, filter: _filter);
      _summary = sum;
      _items = list;
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    } catch (e) {
      emit(const TasksError('تعذر تطبيق الفلتر'));
    }
  }

  Future<void> _onProgress(TasksProgressChanged event, Emitter<TeamTasksState> emit) async {
    // Optimistic update
    final idx = _items.indexWhere((t) => t.id == event.id);
    if (idx == -1) return;
    final optimistic = List<TaskItem>.from(_items);
    optimistic[idx] = optimistic[idx].copyWith(progress: event.percent);
    emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: optimistic));

    try {
      final updated = await repository.update(event.id, progress: event.percent);
      final newList = List<TaskItem>.from(optimistic);
      newList[idx] = updated;
      _items = newList;
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    } catch (_) {
      // revert
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    }
  }

  Future<void> _onStatusChanged(TaskStatusChanged event, Emitter<TeamTasksState> emit) async {
    final idx = _items.indexWhere((t) => t.id == event.id);
    if (idx == -1) return;
    final optimistic = List<TaskItem>.from(_items);
    optimistic[idx] = optimistic[idx].copyWith(status: event.status);
    emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: optimistic));
    try {
      final updated = await repository.update(event.id, status: event.status);
      final newList = List<TaskItem>.from(optimistic);
      newList[idx] = updated;
      _items = newList;
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    } catch (_) {
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    }
  }

  Future<void> _onSendMessage(TaskSendMessage event, Emitter<TeamTasksState> emit) async {
    await repository.sendMessage(event.id, event.message);
  }

  Future<void> _onOpenDetails(TaskOpenDetails event, Emitter<TeamTasksState> emit) async {
    // reserved for possible future use (e.g., loading full details)
    await repository.getById(event.id);
  }

  Future<void> _onCreateSubmitted(TaskCreateSubmitted event, Emitter<TeamTasksState> emit) async {
    try {
      final created = await repository.create(TaskItem(
        id: 'draft',
        title: event.title,
        description: event.description,
        assigneeId: event.assigneeId,
        assigneeName: 'عضو فريق',
        assigneeAvatar: '',
        createdAt: DateTime.now(),
        dueAt: event.dueAt,
        status: TaskStatus.todo,
        priority: event.priority,
        tags: event.tags,
        spentHours: 0,
        estimateHours: event.estimateHours,
        progress: 0,
      ));
      _items = [created, ..._items];
      // Recompute summary
      final total = _items.length;
      final inProgress = _items.where((e) => e.status == TaskStatus.inProgress).length;
      final todo = _items.where((e) => e.status == TaskStatus.todo).length;
      final review = _items.where((e) => e.status == TaskStatus.review).length;
      final overdue = _items.where((e) => e.status == TaskStatus.overdue).length;
      final done = _items.where((e) => e.status == TaskStatus.done).length;
      _summary = TasksSummary(total: total, inProgress: inProgress, todo: todo, review: review, overdue: overdue, done: done);
      emit(TasksLoaded(summary: _summary, query: _query, filter: _filter, items: _items));
    } catch (e) {
      // keep state
    }
  }
}


