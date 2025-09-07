import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../Models/payroll_admin_models.dart';

@immutable
abstract class PayrollAdminRepository {
  Future<PayrollDashboardSummary> fetchDashboard();
  Future<List<EmployeePayrollRow>> fetchEmployees({String query = '', String filter = 'الكل'});
}

class MockPayrollAdminRepository implements PayrollAdminRepository {
  const MockPayrollAdminRepository();

  static const PayrollDashboardSummary _summary = PayrollDashboardSummary(
    employeesCount: 5,
    baseSalariesTotal: 70000,
    deductionsTotal: 2600,
    allowancesTotal: 9500,
    bonusesTotal: 5600,
    netTotal: 82500,
  );

  static final List<EmployeePayrollRow> _seed = [
    const EmployeePayrollRow(
      id: '1',
      name: 'أحمد محمد علي',
      title: 'مهندس برمجيات',
      department: 'تقنية المعلومات',
      active: true,
      baseSalary: 15000,
      allowances: 2000,
      deductions: 500,
      bonuses: 1000,
    ),
    const EmployeePayrollRow(
      id: '2',
      name: 'فاطمة أحمد حسن',
      title: 'مديرة مشاريع',
      department: 'إدارة المشاريع',
      active: true,
      baseSalary: 18000,
      allowances: 3000,
      deductions: 800,
      bonuses: 2000,
    ),
    const EmployeePayrollRow(
      id: '3',
      name: 'محمد عبدالله',
      title: 'أخصائي توظيف',
      department: 'الموارد البشرية',
      active: true,
      baseSalary: 12000,
      allowances: 2000,
      deductions: 400,
      bonuses: 300,
    ),
  ];

  @override
  Future<PayrollDashboardSummary> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _summary;
  }

  @override
  Future<List<EmployeePayrollRow>> fetchEmployees({String query = '', String filter = 'الكل'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Create a slightly larger list to enable scrolling
    final data = <EmployeePayrollRow>[
      ..._seed,
      const EmployeePayrollRow(
        id: '4',
        name: 'نورة سعيد',
        title: 'محللة نظم',
        department: 'تقنية المعلومات',
        active: true,
        baseSalary: 14000,
        allowances: 1800,
        deductions: 300,
        bonuses: 700,
      ),
      const EmployeePayrollRow(
        id: '5',
        name: 'سارة محمد',
        title: 'منسقة موارد',
        department: 'الموارد البشرية',
        active: true,
        baseSalary: 12500,
        allowances: 1500,
        deductions: 500,
        bonuses: 500,
      ),
      // Repeats to make the list scrollable in demos
      ..._seed.map((e) => EmployeePayrollRow(
            id: 'r-${e.id}',
            name: e.name,
            title: e.title,
            department: e.department,
            active: e.active,
            baseSalary: e.baseSalary,
            allowances: e.allowances,
            deductions: e.deductions,
            bonuses: e.bonuses,
          )),
    ];

    Iterable<EmployeePayrollRow> filtered = data;

    if (filter != 'الكل') {
      // Treat other filters as department name
      final f = filter.trim();
      filtered = filtered.where((e) => e.department == f);
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      filtered = filtered.where((e) =>
          e.name.toLowerCase().contains(q) ||
          e.title.toLowerCase().contains(q) ||
          e.department.toLowerCase().contains(q));
    }

    return filtered.toList(growable: false);
  }
}

class DioPayrollAdminRepository implements PayrollAdminRepository {
  final Dio dio;
  DioPayrollAdminRepository(this.dio);

  @override
  Future<PayrollDashboardSummary> fetchDashboard() {
    throw UnimplementedError('fetchDashboard is not implemented yet');
  }

  @override
  Future<List<EmployeePayrollRow>> fetchEmployees({String query = '', String filter = 'الكل'}) {
    throw UnimplementedError('fetchEmployees is not implemented yet');
  }
}


