import 'package:equatable/equatable.dart';
import '../../../Data/Models/task_item.dart';

abstract class DailyTasksState extends Equatable {
  const DailyTasksState();
  @override
  List<Object?> get props => [];
}

class DailyTasksInitial extends DailyTasksState {}
class DailyTasksLoading extends DailyTasksState {}
class DailyTasksEmpty extends DailyTasksState {}
class DailyTasksError extends DailyTasksState {
  final String message;
  const DailyTasksError(this.message);
  @override
  List<Object?> get props => [message];
}
class DailyTasksSuccess extends DailyTasksState {
  final List<TaskItem> items;
  const DailyTasksSuccess(this.items);
  @override
  List<Object?> get props => [items];
}


