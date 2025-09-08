import 'package:equatable/equatable.dart';

enum TaskStatus { todo, inProgress, review, overdue, done }

enum TaskPriority { low, medium, high }

class TaskItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final String assigneeName;
  final String assigneeAvatar;
  final DateTime createdAt;
  final DateTime dueAt;
  final TaskStatus status;
  final TaskPriority priority;
  final List<String> tags;
  final int spentHours;
  final int estimateHours;
  final int progress; // 0..100

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.assigneeName,
    required this.assigneeAvatar,
    required this.createdAt,
    required this.dueAt,
    required this.status,
    required this.priority,
    required this.tags,
    required this.spentHours,
    required this.estimateHours,
    required this.progress,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    String? assigneeId,
    String? assigneeName,
    String? assigneeAvatar,
    DateTime? createdAt,
    DateTime? dueAt,
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? tags,
    int? spentHours,
    int? estimateHours,
    int? progress,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      assigneeAvatar: assigneeAvatar ?? this.assigneeAvatar,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      spentHours: spentHours ?? this.spentHours,
      estimateHours: estimateHours ?? this.estimateHours,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        assigneeId,
        assigneeName,
        assigneeAvatar,
        createdAt,
        dueAt,
        status,
        priority,
        tags,
        spentHours,
        estimateHours,
        progress,
      ];
}

class TasksSummary extends Equatable {
  final int total;
  final int inProgress;
  final int todo;
  final int review;
  final int overdue;
  final int done;

  const TasksSummary({
    required this.total,
    required this.inProgress,
    required this.todo,
    required this.review,
    required this.overdue,
    required this.done,
  });

  TasksSummary copyWith({
    int? total,
    int? inProgress,
    int? todo,
    int? review,
    int? overdue,
    int? done,
  }) => TasksSummary(
        total: total ?? this.total,
        inProgress: inProgress ?? this.inProgress,
        todo: todo ?? this.todo,
        review: review ?? this.review,
        overdue: overdue ?? this.overdue,
        done: done ?? this.done,
      );

  @override
  List<Object?> get props => [total, inProgress, todo, review, overdue, done];
}


