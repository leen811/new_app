import 'package:equatable/equatable.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();
  @override
  List<Object?> get props => [];
}

class TasksFetch extends TasksEvent {}
class TasksToggleDone extends TasksEvent {
  final int id;
  const TasksToggleDone(this.id);
  @override
  List<Object?> get props => [id];
}


