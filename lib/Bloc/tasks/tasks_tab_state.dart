import 'package:equatable/equatable.dart';
import '../../Data/Models/kpi_overview.dart';

abstract class TasksTabState extends Equatable {
  const TasksTabState();
  @override
  List<Object?> get props => [];
}

class TasksTabInitial extends TasksTabState {}

class TasksTabLoading extends TasksTabState {}

class TasksTabSuccess extends TasksTabState {
  final int index;
  final KpiOverview? overview;
  final bool loadingOverview;
  const TasksTabSuccess({required this.index, this.overview, this.loadingOverview = false});
  TasksTabSuccess copyWith({int? index, KpiOverview? overview, bool? loadingOverview}) =>
      TasksTabSuccess(index: index ?? this.index, overview: overview ?? this.overview, loadingOverview: loadingOverview ?? this.loadingOverview);
  @override
  List<Object?> get props => [index, overview, loadingOverview];
}

class TasksTabError extends TasksTabState {
  final String message;
  const TasksTabError(this.message);
  @override
  List<Object?> get props => [message];
}


