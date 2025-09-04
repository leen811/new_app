import 'package:equatable/equatable.dart';
import '../../Data/Models/manager_dashboard_models.dart';

abstract class ManagerDashboardState extends Equatable {
  const ManagerDashboardState();

  @override
  List<Object?> get props => [];
}

class ManagerInitial extends ManagerDashboardState {
  const ManagerInitial();
}

class ManagerLoading extends ManagerDashboardState {
  const ManagerLoading();
}

class ManagerLoaded extends ManagerDashboardState {
  final ManagerDashboardData data;

  const ManagerLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ManagerError extends ManagerDashboardState {
  final String message;

  const ManagerError({required this.message});

  @override
  List<Object?> get props => [message];
}
