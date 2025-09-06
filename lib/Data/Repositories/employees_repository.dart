import 'package:dio/dio.dart';
import '../Models/employee_models.dart';

/// واجهة مصدر بيانات الموظفين
abstract class EmployeesRepository {
  Future<(EmployeesSummary, List<Employee>)> fetch({
    String? query,
    String? department,
    EmployeeStatus? status,
  });
}

/// مصدر بيانات وهمي مطابق للسكرينات
class MockEmployeesRepository implements EmployeesRepository {
  @override
  Future<(EmployeesSummary, List<Employee>)> fetch({
    String? query,
    String? department,
    EmployeeStatus? status,
  }) async {
    // بيانات مطابقة للسكرينات (5 موظفين)
    final all = <Employee>[
      const Employee(
        id: 'u1',
        name: 'أحمد محمد السالم',
        roleTitle: 'مطور واجهات أمامية',
        department: 'التكنولوجيا',
        status: EmployeeStatus.active,
        rating: 4.9,
        value: 45,
        attendancePct: 100,
        points: 98,
        avatarUrl: 'https://i.pravatar.cc/100?img=12',
      ),
      const Employee(
        id: 'u2',
        name: 'سارة أحمد الزهراني',
        roleTitle: 'مدير التسويق الرقمي',
        department: 'التسويق',
        status: EmployeeStatus.active,
        rating: 4.7,
        value: 42,
        attendancePct: 98,
        points: 95,
      ),
      const Employee(
        id: 'u3',
        name: 'محمد عبدالله القحطاني',
        roleTitle: 'مختص مبيعات أول',
        department: 'المبيعات',
        status: EmployeeStatus.active,
        rating: 4.5,
        value: 38,
        attendancePct: 96,
        points: 92,
        avatarUrl: 'https://i.pravatar.cc/100?img=5',
      ),
      const Employee(
        id: 'u4',
        name: 'نوره سعد العتيبي',
        roleTitle: 'مختص موارد بشرية',
        department: 'الموارد البشرية',
        status: EmployeeStatus.onLeave,
        rating: 4.6,
        value: 40,
        attendancePct: 94,
        points: 90,
        avatarUrl: 'https://i.pravatar.cc/100?img=32',
      ),
      const Employee(
        id: 'u5',
        name: 'خالد الأحمد',
        roleTitle: 'مصمم منتجات',
        department: 'التصميم',
        status: EmployeeStatus.inactive,
        rating: 4.3,
        value: 30,
        attendancePct: 88,
        points: 80,
      ),
    ];

    // فلترة بسيطة
    Iterable<Employee> list = all;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim();
      list = list.where((e) => e.name.contains(q) || e.roleTitle.contains(q) || e.department.contains(q));
    }
    if (department != null && department.isNotEmpty && department != 'جميع الأقسام') {
      list = list.where((e) => e.department == department);
    }
    if (status != null) {
      list = list.where((e) => e.status == status);
    }

    final total = all.length;
    final active = all.where((e) => e.status == EmployeeStatus.active).length;
    final onLeave = all.where((e) => e.status == EmployeeStatus.onLeave).length;
    final inactive = all.where((e) => e.status == EmployeeStatus.inactive).length;

    return (
      EmployeesSummary(total: total, active: active, onLeave: onLeave, inactive: inactive),
      list.toList(),
    );
  }
}

/// مصدر بيانات يستخدم Dio لاحقًا
class DioEmployeesRepository implements EmployeesRepository {
  final Dio dio;
  DioEmployeesRepository(this.dio);

  @override
  Future<(EmployeesSummary, List<Employee>)> fetch({
    String? query,
    String? department,
    EmployeeStatus? status,
  }) {
    throw UnimplementedError('سيتم تنفيذ الاستدعاء الشبكي لاحقًا');
  }
}


