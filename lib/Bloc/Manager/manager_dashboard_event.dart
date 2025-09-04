import 'package:equatable/equatable.dart';

abstract class ManagerDashboardEvent extends Equatable {
  const ManagerDashboardEvent();

  @override
  List<Object?> get props => [];
}

class ManagerLoad extends ManagerDashboardEvent {
  const ManagerLoad();
}
