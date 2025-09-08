import 'package:equatable/equatable.dart';
import '../../Data/Models/team_tasks_models.dart';

abstract class TeamTasksEvent extends Equatable {
  const TeamTasksEvent();
  @override
  List<Object?> get props => [];
}

class TasksLoad extends TeamTasksEvent {
  const TasksLoad();
}

class TasksSearchChanged extends TeamTasksEvent {
  final String query;
  const TasksSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class TasksFilterChanged extends TeamTasksEvent {
  final String filter; // 'all' or describeEnum(TaskStatus)
  const TasksFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class TasksProgressChanged extends TeamTasksEvent {
  final String id;
  final int percent; // 0..100
  const TasksProgressChanged(this.id, this.percent);
  @override
  List<Object?> get props => [id, percent];
}

class TaskStatusChanged extends TeamTasksEvent {
  final String id;
  final TaskStatus status;
  const TaskStatusChanged(this.id, this.status);
  @override
  List<Object?> get props => [id, status];
}

class TaskSendMessage extends TeamTasksEvent {
  final String id;
  final String message;
  const TaskSendMessage(this.id, this.message);
  @override
  List<Object?> get props => [id, message];
}

class TaskOpenDetails extends TeamTasksEvent {
  final String id;
  const TaskOpenDetails(this.id);
  @override
  List<Object?> get props => [id];
}

class TaskCreateSubmitted extends TeamTasksEvent {
  final String title;
  final String description;
  final String assigneeId;
  final TaskPriority priority;
  final int estimateHours;
  final DateTime dueAt;
  final String? category;
  final List<String> tags;
  const TaskCreateSubmitted({
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.priority,
    required this.estimateHours,
    required this.dueAt,
    this.category,
    this.tags = const [],
  });
  @override
  List<Object?> get props => [title, description, assigneeId, priority, estimateHours, dueAt, category, tags];
}


