import 'package:flutter/material.dart';

// أنواع الإجازات
enum LeaveType {
  annual('سنوية'),
  sick('مرضية'),
  emergency('طارئة');

  const LeaveType(this.displayName);
  final String displayName;
}

// أنواع الاستئذان
enum PermissionType {
  earlyLeave('خروج مبكر'),
  lateArrival('تأخير'),
  workHours('ساعات ضمن الدوام');

  const PermissionType(this.displayName);
  final String displayName;
}

// حالات الطلبات
enum RequestStatus {
  approved('موافق عليها'),
  pending('قيد المراجعة'),
  rejected('مرفوضة');

  const RequestStatus(this.displayName);
  final String displayName;

  Color get color {
    switch (this) {
      case RequestStatus.approved:
        return const Color(0xFF10B981);
      case RequestStatus.pending:
        return const Color(0xFFF59E0B);
      case RequestStatus.rejected:
        return const Color(0xFFEF4444);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case RequestStatus.approved:
        return const Color(0xFFD1FAE5);
      case RequestStatus.pending:
        return const Color(0xFFFEF3C7);
      case RequestStatus.rejected:
        return const Color(0xFFFEE2E2);
    }
  }
}

// رصيد الإجازات
class LeaveBalance {
  final int annual;
  final int sick;
  final int emergency;

  const LeaveBalance({
    required this.annual,
    required this.sick,
    required this.emergency,
  });

  factory LeaveBalance.empty() => const LeaveBalance(
        annual: 0,
        sick: 0,
        emergency: 0,
      );
}

// طلب إجازة
class LeaveRequest {
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String? medicalAttachment; // TODO: للمستقبل

  const LeaveRequest({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.medicalAttachment,
  });

  int get days => endDate.difference(startDate).inDays + 1;
}

// طلب استئذان
class PermissionRequest {
  final PermissionType type;
  final DateTime date;
  final TimeOfDay from;
  final TimeOfDay to;
  final String reason;

  const PermissionRequest({
    required this.type,
    required this.date,
    required this.from,
    required this.to,
    required this.reason,
  });

  Duration get duration {
    final fromMinutes = from.hour * 60 + from.minute;
    final toMinutes = to.hour * 60 + to.minute;
    final diffMinutes = toMinutes - fromMinutes;
    return Duration(minutes: diffMinutes);
  }

  String get durationText {
    final duration = this.duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hoursس $minutesد';
  }
}

// سجل إجازة
class LeaveRecord {
  final String id;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final String reason;
  final RequestStatus status;
  final DateTime submittedAt;

  const LeaveRecord({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.reason,
    required this.status,
    required this.submittedAt,
  });
}

// سجل استئذان
class PermissionRecord {
  final String id;
  final PermissionType type;
  final DateTime date;
  final TimeOfDay from;
  final TimeOfDay to;
  final Duration duration;
  final String reason;
  final RequestStatus status;
  final DateTime submittedAt;

  const PermissionRecord({
    required this.id,
    required this.type,
    required this.date,
    required this.from,
    required this.to,
    required this.duration,
    required this.reason,
    required this.status,
    required this.submittedAt,
  });

  String get durationText {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hoursس $minutesد';
  }
}
