import 'package:equatable/equatable.dart';
import '../../Data/Models/employee_models.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();
  @override
  List<Object?> get props => [];
}

class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

class EmployeesLoaded extends EmployeesState {
  final String query;
  final String department;
  final EmployeeStatus? status;
  final EmployeesSummary summary;
  final List<Employee> list;

  const EmployeesLoaded({
    required this.query,
    required this.department,
    required this.status,
    required this.summary,
    required this.list,
  });

  EmployeesLoaded copyWith({
    String? query,
    String? department,
    EmployeeStatus? status,
    EmployeesSummary? summary,
    List<Employee>? list,
  }) {
    return EmployeesLoaded(
      query: query ?? this.query,
      department: department ?? this.department,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [query, department, status, summary, list];
}

class EmployeesError extends EmployeesState {
  final String message;
  const EmployeesError(this.message);
  @override
  List<Object?> get props => [message];
}


