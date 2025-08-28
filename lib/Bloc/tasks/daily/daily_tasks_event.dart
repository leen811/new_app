import 'package:equatable/equatable.dart';

abstract class DailyTasksEvent extends Equatable {
  const DailyTasksEvent();
  @override
  List<Object?> get props => [];
}

class DailyTasksFetch extends DailyTasksEvent {}
class DailyTasksRefresh extends DailyTasksEvent {}
class DailyTaskToggleComplete extends DailyTasksEvent {
  final String id;
  const DailyTaskToggleComplete(this.id);
  @override
  List<Object?> get props => [id];
}
class DailyTaskTimerStart extends DailyTasksEvent { final String id; const DailyTaskTimerStart(this.id); @override List<Object?> get props => [id]; }
class DailyTaskTimerStop extends DailyTasksEvent { final String id; const DailyTaskTimerStop(this.id); @override List<Object?> get props => [id]; }


