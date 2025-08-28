import 'package:equatable/equatable.dart';

abstract class TasksTabEvent extends Equatable {
  const TasksTabEvent();
  @override
  List<Object?> get props => [];
}

class TasksTabChanged extends TasksTabEvent {
  final int index;
  const TasksTabChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class TasksOverviewRequested extends TasksTabEvent {}


