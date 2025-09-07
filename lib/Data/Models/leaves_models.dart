import 'package:flutter/material.dart';

/// أنواع الإجازات والاستئذانات
enum LeaveType { annual, sick, unpaid, urgent, permission }

/// حالة الطلب
enum LeaveStatus { pending, approved, rejected, cancelled }

/// نموذج طلب إجازة/استئذان
class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String title;
  final String department;
  final LeaveType type;
  final LeaveStatus status;
  final DateTime createdAt;
  final DateTime startAt;
  final DateTime endAt;
  final TimeOfDay? timeFrom; // للاستئذان
  final TimeOfDay? timeTo;   // للاستئذان
  final String? note;        // ملاحظة الموظف
  final String approverName; // المسؤول الحالي
  final int daysRequested;   // محسوب من النطاق
  final int balanceBefore;   // رصيد قبل
  final int balanceAfter;    // رصيد بعد

  const LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.title,
    required this.department,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
    this.timeFrom,
    this.timeTo,
    this.note,
    required this.approverName,
    required this.daysRequested,
    required this.balanceBefore,
    required this.balanceAfter,
  });

  bool get isPermission => type == LeaveType.permission;
}

/// ملخص علوي للطلبات
class LeavesSummary {
  final int pending;
  final int onLeaveNow;
  final int todayOut;
  final int avgResponseHrs;

  const LeavesSummary({
    required this.pending,
    required this.onLeaveNow,
    required this.todayOut,
    required this.avgResponseHrs,
  });
}


