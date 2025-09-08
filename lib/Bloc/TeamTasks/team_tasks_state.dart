import 'package:equatable/equatable.dart';
import '../../Data/Models/team_tasks_models.dart';

abstract class TeamTasksState extends Equatable {
  const TeamTasksState();
  @override
  List<Object?> get props => [];
}

class TasksInitial extends TeamTasksState {}
class TasksLoading extends TeamTasksState {}

class TasksLoaded extends TeamTasksState {
  final TasksSummary summary;
  final String query;
  final String filter;
  final List<TaskItem> items;
  const TasksLoaded({
    required this.summary,
    required this.query,
    required this.filter,
    required this.items,
  });

  TasksLoaded copyWith({
    TasksSummary? summary,
    String? query,
    String? filter,
    List<TaskItem>? items,
  }) => TasksLoaded(
        summary: summary ?? this.summary,
        query: query ?? this.query,
        filter: filter ?? this.filter,
        items: items ?? this.items,
      );

  @override
  List<Object?> get props => [summary, query, filter, items];
}

class TasksError extends TeamTasksState {
  final String message;
  const TasksError(this.message);
  @override
  List<Object?> get props => [message];
}


