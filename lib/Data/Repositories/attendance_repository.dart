import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../Models/attendance_models.dart';

abstract class AttendanceDataRepository {
  Future<List<EmployeePresence>> fetchTodayPresence({String? query, String? department});
  Future<EmployeeWeekAttendance> fetchEmployeeWeek({required String employeeId, required DateTime anchor, DateTimeRange? range});
}

class MockAttendanceDataRepository implements AttendanceDataRepository {
  @override
  Future<List<EmployeePresence>> fetchTodayPresence({String? query, String? department}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = <EmployeePresence>[
      EmployeePresence(id: 'u1', name: 'أحمد محمد السالم', department: 'التكنولوجيا', avatarUrl: 'https://i.pravatar.cc/100?img=12', isCheckedIn: true, lastCheckInAt: DateTime.now().subtract(const Duration(minutes: 35)), lastLocationName: 'الرياض – بوابة A', lastLocation: (24.7136, 46.6753)),
      const EmployeePresence(id: 'u2', name: 'سارة أحمد الزهراني', department: 'التسويق', isCheckedIn: true, lastCheckInAt: null, lastLocationName: 'جدة – HQ', lastLocation: null),
      EmployeePresence(id: 'u3', name: 'محمد عبدالله القحطاني', department: 'المبيعات', avatarUrl: 'https://i.pravatar.cc/100?img=5', isCheckedIn: false, lastCheckInAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)), lastLocationName: 'الرياض – HQ بوابة B', lastLocation: (24.7136, 46.6753)),
      EmployeePresence(id: 'u4', name: 'نوره سعد العتيبي', department: 'الموارد البشرية', avatarUrl: 'https://i.pravatar.cc/100?img=32', isCheckedIn: true, lastCheckInAt: DateTime.now().subtract(const Duration(minutes: 10)), lastLocationName: 'الدمام – فرع 2', lastLocation: (26.4344, 50.1030)),
      const EmployeePresence(id: 'u5', name: 'خالد الأحمد', department: 'التصميم', isCheckedIn: false, lastCheckInAt: null, lastLocationName: 'منزل', lastLocation: null),
    ];

    Iterable<EmployeePresence> list = all;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim();
      list = list.where((e) => e.name.contains(q) || e.department.contains(q));
    }
    if (department != null && department.isNotEmpty && department != 'جميع الأقسام') {
      list = list.where((e) => e.department == department);
    }
    return list.toList();
  }

  @override
  Future<EmployeeWeekAttendance> fetchEmployeeWeek({required String employeeId, required DateTime anchor, DateTimeRange? range}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // إذا تم تمرير Range نستخدمه كما هو ونبني جميع الأيام ضمنه
    if (range != null) {
      final start = DateTime(range.start.year, range.start.month, range.start.day);
      final end = DateTime(range.end.year, range.end.month, range.end.day);
      final totalDays = end.difference(start).inDays + 1;
      final days = <EmployeeDayAttendance>[];
      for (int i = 0; i < totalDays; i++) {
        final day = start.add(Duration(days: i));
        List<AttendanceSession> sessions = [];
        if (i % 2 == 0) {
          sessions.add(AttendanceSession(
            inAt: DateTime(day.year, day.month, day.day, 8, 15),
            outAt: DateTime(day.year, day.month, day.day, 17, 5),
            inLocation: 'HQ بوابة A',
            outLocation: 'HQ موقف B',
            note: 'خروج مبكر 5د',
          ));
        }
        if (i == 2 || i == 5) {
          sessions.add(AttendanceSession(
            inAt: DateTime(day.year, day.month, day.day, 19, 0),
            outAt: DateTime(day.year, day.month, day.day, 21, 15),
            inLocation: 'منزل',
            outLocation: 'منزل',
            note: 'عمل إضافي',
          ));
        }
        days.add(EmployeeDayAttendance(day, sessions));
      }
      return EmployeeWeekAttendance(start, days);
    }

    // احسب بداية الأسبوع (الأحد) عندما لا يوجد Range
    final weekday = anchor.weekday; // 1=Mon..7=Sun
    final weekStart = DateTime(anchor.year, anchor.month, anchor.day).subtract(Duration(days: weekday % 7));
    List<EmployeeDayAttendance> days = [];
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      List<AttendanceSession> sessions = [];
      if (i % 2 == 0) {
        sessions.add(AttendanceSession(
          inAt: DateTime(day.year, day.month, day.day, 8, 15),
          outAt: DateTime(day.year, day.month, day.day, 17, 5),
          inLocation: 'HQ بوابة A',
          outLocation: 'HQ موقف B',
          note: 'خروج مبكر 5د',
        ));
      }
      if (i == 2 || i == 5) {
        sessions.add(AttendanceSession(
          inAt: DateTime(day.year, day.month, day.day, 19, 0),
          outAt: DateTime(day.year, day.month, day.day, 21, 15),
          inLocation: 'منزل',
          outLocation: 'منزل',
          note: 'عمل إضافي',
        ));
      }
      days.add(EmployeeDayAttendance(day, sessions));
    }
    return EmployeeWeekAttendance(weekStart, days);
  }
}
abstract class IAttendanceRepository {
  Future<Map<String, dynamic>> checkIn({required double lat, required double lng});
  Future<Map<String, dynamic>> checkOut({required double lat, required double lng});
  Future<Map<String, dynamic>> breakStart({double? lat, double? lng});
  Future<Map<String, dynamic>> breakStop({double? lat, double? lng});
}

class AttendanceRepository implements IAttendanceRepository {
  final Dio dio;
  AttendanceRepository(this.dio);

  @override
  Future<Map<String, dynamic>> checkIn({required double lat, required double lng}) async {
    final r = await dio.post('attendance/check-in', data: {'lat': lat, 'lng': lng});
    return Map<String, dynamic>.from(r.data as Map);
  }

  @override
  Future<Map<String, dynamic>> checkOut({required double lat, required double lng}) async {
    final r = await dio.post('attendance/check-out', data: {'lat': lat, 'lng': lng});
    return Map<String, dynamic>.from(r.data as Map);
  }

  @override
  Future<Map<String, dynamic>> breakStart({double? lat, double? lng}) async {
    final r = await dio.post('attendance/break/start', data: {'lat': lat, 'lng': lng});
    return Map<String, dynamic>.from(r.data as Map);
  }

  @override
  Future<Map<String, dynamic>> breakStop({double? lat, double? lng}) async {
    final r = await dio.post('attendance/break/stop', data: {'lat': lat, 'lng': lng});
    return Map<String, dynamic>.from(r.data as Map);
  }
}


