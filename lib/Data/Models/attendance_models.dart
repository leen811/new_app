class EmployeePresence {
  final String id;
  final String name;
  final String department;
  final String? avatarUrl;
  final bool isCheckedIn;
  final DateTime? lastCheckInAt;
  final String? lastLocationName;
  final (double lat, double lng)? lastLocation;

  const EmployeePresence({
    required this.id,
    required this.name,
    required this.department,
    this.avatarUrl,
    required this.isCheckedIn,
    this.lastCheckInAt,
    this.lastLocationName,
    this.lastLocation,
  });
}

class AttendanceSession {
  final DateTime inAt;
  final DateTime outAt;
  final String inLocation;
  final String outLocation;
  final String? note;
  final int breaksMinutes; // افتراضي 0
  const AttendanceSession({
    required this.inAt,
    required this.outAt,
    required this.inLocation,
    required this.outLocation,
    this.note,
    this.breaksMinutes = 0,
  });
}

class EmployeeDayAttendance {
  final DateTime day;
  final List<AttendanceSession> sessions;
  const EmployeeDayAttendance(this.day, this.sessions);
}

class EmployeeWeekAttendance {
  final DateTime weekStart;
  final List<EmployeeDayAttendance> days;
  const EmployeeWeekAttendance(this.weekStart, this.days);
}

class WeekOverview {
  final Duration workNet;      // بدون البريك
  final Duration workGross;    // مع البريك
  final Duration breaks;       // مجموع البريك
  final Duration overtime;     // مجموع الأوفر تايم
  final int daysCompleted;     // حقق الدوام الكامل
  final int daysPartial;       // أقل من المعيار
  final int daysAbsent;        // لا سجلات
  const WeekOverview({
    required this.workNet,
    required this.workGross,
    required this.breaks,
    required this.overtime,
    required this.daysCompleted,
    required this.daysPartial,
    required this.daysAbsent,
  });
}

enum DayStatus { completed, partial, absent }

class DaySummary {
  final DateTime day;
  final DateTime? firstIn;   // أول تشيك إن
  final DateTime? firstOut;  // أول تشيك آوت (من نفس الجلسة الأولى)
  final Duration breakDur;
  final Duration netDur;     // مجموع (out-in) - break
  final Duration overtime;   // max(0, netDur - shiftStd)
  final DayStatus status;
  const DaySummary({
    required this.day,
    required this.firstIn,
    required this.firstOut,
    required this.breakDur,
    required this.netDur,
    required this.overtime,
    required this.status,
  });
}


