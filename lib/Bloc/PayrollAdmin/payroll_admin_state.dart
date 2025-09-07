import 'package:meta/meta.dart';

import '../../Data/Models/payroll_admin_models.dart';

@immutable
sealed class AdminPayrollState {}

class AdminPayrollInitial extends AdminPayrollState {}

class AdminPayrollLoading extends AdminPayrollState {}

class AdminPayrollLoaded extends AdminPayrollState {
  final int currentTab;
  final PayrollDashboardSummary summary;
  final String query;
  final String filter;
  final List<EmployeePayrollRow> employees;

  AdminPayrollLoaded({
    required this.currentTab,
    required this.summary,
    required this.query,
    required this.filter,
    required this.employees,
  });

  AdminPayrollLoaded copyWith({
    int? currentTab,
    PayrollDashboardSummary? summary,
    String? query,
    String? filter,
    List<EmployeePayrollRow>? employees,
  }) => AdminPayrollLoaded(
        currentTab: currentTab ?? this.currentTab,
        summary: summary ?? this.summary,
        query: query ?? this.query,
        filter: filter ?? this.filter,
        employees: employees ?? this.employees,
      );
}

class AdminPayrollError extends AdminPayrollState {
  final String message;
  AdminPayrollError(this.message);
}


