import 'dart:math';
import 'package:flutter/material.dart';
import '../Models/leaves_models.dart';

/// واجهة مستودع الإجازات
abstract class LeavesRepository {
  Future<(LeavesSummary, List<LeaveRequest>)> fetch({
    String query = '',
    LeaveType? type,
    LeaveStatus? status,
    String? department,
    DateTimeRange? range,
  });

  Future<LeaveRequest> getById(String id);

  Future<void> approve({required String id, String? managerNote});

  Future<void> reject({required String id, String? managerNote});

  Future<void> cancel({required String id, String? managerNote});

  Future<List<LeaveRequest>> fetchCalendarMonth({
    required int year,
    required int month,
    String? department,
  });
}

/// تنفيذ مبدئي Mock لاحتياجات العرض والاختبار
class MockLeavesRepository implements LeavesRepository {
  final List<LeaveRequest> _all = _seed();

  static List<LeaveRequest> _seed() {
    final now = DateTime.now();
    final d = <LeaveRequest>[];
    int id = 1;
    // طلبات سنوية
    d.addAll(List.generate(6, (i) {
      final start = DateTime(now.year, now.month, max(1, i + 1));
      final end = start.add(Duration(days: 2 + (i % 2)));
      return LeaveRequest(
        id: 'L${id++}',
        employeeId: 'E${100 + i}',
        employeeName: 'موظف ${i + 1}',
        title: 'إجازة سنوية',
        department: i % 2 == 0 ? 'التكنولوجيا' : 'المبيعات',
        type: LeaveType.annual,
        status: i % 3 == 0 ? LeaveStatus.pending : LeaveStatus.approved,
        createdAt: start.subtract(const Duration(days: 3)),
        startAt: start,
        endAt: end,
        timeFrom: null,
        timeTo: null,
        note: i % 2 == 0 ? 'سفر عائلي' : null,
        approverName: i % 3 == 0 ? 'مسؤول المناوبات' : 'مدير الموارد',
        daysRequested: end.difference(start).inDays + 1,
        balanceBefore: 21 - (i * 2),
        balanceAfter: 21 - (i * 2) - (end.difference(start).inDays + 1),
      );
    }));

    // مرضية
    d.addAll(List.generate(3, (i) {
      final start = DateTime(now.year, now.month, max(1, 10 + i));
      final end = start.add(const Duration(days: 1));
      return LeaveRequest(
        id: 'L${id++}',
        employeeId: 'E${200 + i}',
        employeeName: 'موظف م${i + 1}',
        title: 'إجازة مرضية',
        department: 'التكنولوجيا',
        type: LeaveType.sick,
        status: i == 0 ? LeaveStatus.pending : LeaveStatus.approved,
        createdAt: start.subtract(const Duration(days: 1)),
        startAt: start,
        endAt: end,
        note: 'إنفلونزا',
        approverName: 'قائد الفريق',
        daysRequested: 2,
        balanceBefore: 21,
        balanceAfter: 21,
      );
    }));

    // بدون راتب
    d.add(LeaveRequest(
      id: 'L${id++}',
      employeeId: 'E301',
      employeeName: 'موظف بلا راتب',
      title: 'إجازة بدون راتب',
      department: 'التسويق',
      type: LeaveType.unpaid,
      status: LeaveStatus.rejected,
      createdAt: now.subtract(const Duration(days: 12)),
      startAt: DateTime(now.year, now.month, max(1, now.day - 9)),
      endAt: DateTime(now.year, now.month, max(1, now.day - 6)),
      note: 'ظرف خاص',
      approverName: 'مدير الموارد',
      daysRequested: 4,
      balanceBefore: 21,
      balanceAfter: 21,
    ));

    // استئذانات (ساعات في نفس اليوم)
    d.addAll(List.generate(5, (i) {
      final day = max(1, (now.day - 2 + i));
      final date = DateTime(now.year, now.month, day);
      final from = TimeOfDay(hour: 10 + (i % 3), minute: 0);
      final to = TimeOfDay(hour: from.hour + 2, minute: 0);
      return LeaveRequest(
        id: 'L${id++}',
        employeeId: 'E${400 + i}',
        employeeName: 'موظف س${i + 1}',
        title: 'استئذان',
        department: i % 2 == 0 ? 'التكنولوجيا' : 'الموارد البشرية',
        type: LeaveType.permission,
        status: i.isEven ? LeaveStatus.pending : LeaveStatus.approved,
        createdAt: date.subtract(const Duration(days: 1)),
        startAt: date,
        endAt: date,
        timeFrom: from,
        timeTo: to,
        note: i == 2 ? 'مراجعة طبية' : null,
        approverName: 'قائد الفريق',
        daysRequested: 0,
        balanceBefore: 21,
        balanceAfter: 21,
      );
    }));

    return d;
  }

  @override
  Future<(LeavesSummary, List<LeaveRequest>)> fetch({
    String query = '',
    LeaveType? type,
    LeaveStatus? status,
    String? department,
    DateTimeRange? range,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    Iterable<LeaveRequest> r = _all;
    if (query.isNotEmpty) {
      r = r.where((e) => e.employeeName.contains(query) || e.title.contains(query) || e.department.contains(query));
    }
    if (type != null) {
      r = r.where((e) => e.type == type);
    }
    if (status != null) {
      r = r.where((e) => e.status == status);
    }
    if (department != null && department.isNotEmpty) {
      r = r.where((e) => e.department == department);
    }
    if (range != null) {
      r = r.where((e) => !(e.endAt.isBefore(range.start) || e.startAt.isAfter(range.end)));
    }

    final now = DateTime.now();
    final onLeaveNow = _all.where((e) => !e.isPermission && e.startAt.isBefore(now.add(const Duration(days: 1))) && e.endAt.isAfter(now.subtract(const Duration(days: 1))) && e.status == LeaveStatus.approved).length;
    final todayOut = _all.where((e) => e.isPermission && e.startAt.year == now.year && e.startAt.month == now.month && e.startAt.day == now.day).length;
    final pending = _all.where((e) => e.status == LeaveStatus.pending).length;
    final summary = LeavesSummary(pending: pending, onLeaveNow: onLeaveNow, todayOut: todayOut, avgResponseHrs: 12);
    return (summary, r.toList());
  }

  @override
  Future<LeaveRequest> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _all.firstWhere((e) => e.id == id);
  }

  @override
  Future<void> approve({required String id, String? managerNote}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final i = _all.indexWhere((e) => e.id == id);
    if (i != -1) {
      final it = _all[i];
      _all[i] = LeaveRequest(
        id: it.id,
        employeeId: it.employeeId,
        employeeName: it.employeeName,
        title: it.title,
        department: it.department,
        type: it.type,
        status: LeaveStatus.approved,
        createdAt: it.createdAt,
        startAt: it.startAt,
        endAt: it.endAt,
        timeFrom: it.timeFrom,
        timeTo: it.timeTo,
        note: it.note,
        approverName: 'مدير الموارد',
        daysRequested: it.daysRequested,
        balanceBefore: it.balanceBefore,
        balanceAfter: it.balanceAfter,
      );
    }
  }

  @override
  Future<void> reject({required String id, String? managerNote}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final i = _all.indexWhere((e) => e.id == id);
    if (i != -1) {
      final it = _all[i];
      _all[i] = LeaveRequest(
        id: it.id,
        employeeId: it.employeeId,
        employeeName: it.employeeName,
        title: it.title,
        department: it.department,
        type: it.type,
        status: LeaveStatus.rejected,
        createdAt: it.createdAt,
        startAt: it.startAt,
        endAt: it.endAt,
        timeFrom: it.timeFrom,
        timeTo: it.timeTo,
        note: it.note,
        approverName: 'مدير الموارد',
        daysRequested: it.daysRequested,
        balanceBefore: it.balanceBefore,
        balanceAfter: it.balanceAfter,
      );
    }
  }

  @override
  Future<void> cancel({required String id, String? managerNote}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final i = _all.indexWhere((e) => e.id == id);
    if (i != -1) {
      final it = _all[i];
      _all[i] = LeaveRequest(
        id: it.id,
        employeeId: it.employeeId,
        employeeName: it.employeeName,
        title: it.title,
        department: it.department,
        type: it.type,
        status: LeaveStatus.cancelled,
        createdAt: it.createdAt,
        startAt: it.startAt,
        endAt: it.endAt,
        timeFrom: it.timeFrom,
        timeTo: it.timeTo,
        note: it.note,
        approverName: 'مدير الموارد',
        daysRequested: it.daysRequested,
        balanceBefore: it.balanceBefore,
        balanceAfter: it.balanceAfter,
      );
    }
  }

  @override
  Future<List<LeaveRequest>> fetchCalendarMonth({required int year, required int month, String? department}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _all.where((e) => e.startAt.year == year && e.startAt.month == month).toList();
  }
}


