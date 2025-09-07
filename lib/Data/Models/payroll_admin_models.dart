import 'package:meta/meta.dart';

@immutable
class PayrollDashboardSummary {
  final int employeesCount;
  final int baseSalariesTotal; // الرواتب الأساسية
  final int deductionsTotal;
  final int allowancesTotal;
  final int bonusesTotal; // المكافآت
  final int netTotal; // صافي الرواتب

  const PayrollDashboardSummary({
    required this.employeesCount,
    required this.baseSalariesTotal,
    required this.deductionsTotal,
    required this.allowancesTotal,
    required this.bonusesTotal,
    required this.netTotal,
  });
}

@immutable
class EmployeePayrollRow {
  final String id;
  final String name;
  final String title;
  final String department;
  final bool active;
  final int baseSalary;
  final int allowances;
  final int deductions;
  final int bonuses;

  const EmployeePayrollRow({
    required this.id,
    required this.name,
    required this.title,
    required this.department,
    required this.active,
    required this.baseSalary,
    required this.allowances,
    required this.deductions,
    required this.bonuses,
  });

  int get net => baseSalary + allowances - deductions + bonuses;
}


