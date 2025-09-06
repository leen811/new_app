
/// حالات الموظف
enum EmployeeStatus { active, onLeave, inactive }

/// نموذج موظف مفصل مطابق للمواصفات
class Employee {
  final String id;
  final String name;
  final String roleTitle;
  final String department;
  final EmployeeStatus status;
  final double rating; // مثل 4.9
  final int value; // قيمة/نقاط (45)
  final int attendancePct; // 100
  final int points; // 98
  final String? avatarUrl; // اختياري

  const Employee({
    required this.id,
    required this.name,
    required this.roleTitle,
    required this.department,
    required this.status,
    required this.rating,
    required this.value,
    required this.attendancePct,
    required this.points,
    this.avatarUrl,
  });
}

/// ملخص أعداد الموظفين
class EmployeesSummary {
  final int total;
  final int active;
  final int onLeave;
  final int inactive;

  const EmployeesSummary({
    required this.total,
    required this.active,
    required this.onLeave,
    required this.inactive,
  });
}


