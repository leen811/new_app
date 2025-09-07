import 'package:flutter/material.dart';

class EvalCycleSummary {
  final int totalEmployees;
  final int assigned;
  final int submitted;
  final int reviewers;
  final DateTimeRange period;
  const EvalCycleSummary({required this.totalEmployees, required this.assigned, required this.submitted, required this.reviewers, required this.period});
}

class EvalAssignmentItem {
  final String employeeId;
  final String name;
  final String department;
  final bool submitted;
  final int receivedReviews;
  final int expectedReviews;
  const EvalAssignmentItem({required this.employeeId, required this.name, required this.department, required this.submitted, required this.receivedReviews, required this.expectedReviews});
}

class EvalSettings {
  final bool self;
  final bool manager;
  final bool peers;
  final bool subordinates;
  final DateTimeRange period;
  const EvalSettings({required this.self, required this.manager, required this.peers, required this.subordinates, required this.period});
}

abstract class IPerf360AdminRepository {
  Future<EvalCycleSummary> getSummary();
  Future<List<EvalAssignmentItem>> listAssignments({String? department});
  Future<EvalSettings> getSettings();
  Future<void> saveSettings(EvalSettings s);
}

class MockPerf360AdminRepository implements IPerf360AdminRepository {
  @override
  Future<EvalCycleSummary> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday % 7));
    final end = start.add(const Duration(days: 6));
    return EvalCycleSummary(totalEmployees: 250, assigned: 230, submitted: 168, reviewers: 520, period: DateTimeRange(start: start, end: end));
  }

  @override
  Future<List<EvalAssignmentItem>> listAssignments({String? department}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final all = <EvalAssignmentItem>[
      const EvalAssignmentItem(employeeId: 'u1', name: 'أحمد محمد', department: 'التكنولوجيا', submitted: true, receivedReviews: 4, expectedReviews: 5),
      const EvalAssignmentItem(employeeId: 'u2', name: 'سارة الزهراني', department: 'التسويق', submitted: false, receivedReviews: 1, expectedReviews: 4),
      const EvalAssignmentItem(employeeId: 'u3', name: 'محمد القحطاني', department: 'المبيعات', submitted: true, receivedReviews: 5, expectedReviews: 5),
      const EvalAssignmentItem(employeeId: 'u4', name: 'نوره العتيبي', department: 'الموارد البشرية', submitted: false, receivedReviews: 0, expectedReviews: 3),
    ];
    if (department == null || department.isEmpty || department == 'جميع الأقسام') return all;
    return all.where((e) => e.department == department).toList();
  }

  @override
  Future<EvalSettings> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return EvalSettings(self: true, manager: true, peers: true, subordinates: false, period: DateTimeRange(start: start, end: end));
  }

  @override
  Future<void> saveSettings(EvalSettings s) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}


