import 'package:equatable/equatable.dart';
import '../../Data/Models/employee_home_models.dart';

abstract class EmployeeHomeState extends Equatable {
  const EmployeeHomeState();

  @override
  List<Object?> get props => [];
}

class EmployeeHomeLoading extends EmployeeHomeState {}

class EmployeeHomeReady extends EmployeeHomeState {
  final EmployeeSnapshot snapshot;

  const EmployeeHomeReady(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

class EmployeeHomeError extends EmployeeHomeState {
  final String message;

  const EmployeeHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
