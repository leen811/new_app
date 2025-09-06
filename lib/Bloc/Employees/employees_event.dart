import 'package:equatable/equatable.dart';
import '../../Data/Models/employee_models.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();
  @override
  List<Object?> get props => [];
}

class EmployeesLoad extends EmployeesEvent {
  const EmployeesLoad();
}

class EmployeesQueryChanged extends EmployeesEvent {
  final String query;
  const EmployeesQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class EmployeesDepartmentChanged extends EmployeesEvent {
  final String? department;
  const EmployeesDepartmentChanged(this.department);
  @override
  List<Object?> get props => [department];
}

class EmployeesStatusChanged extends EmployeesEvent {
  final EmployeeStatus? status;
  const EmployeesStatusChanged(this.status);
  @override
  List<Object?> get props => [status];
}


