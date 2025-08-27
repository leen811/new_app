import 'package:dio/dio.dart';

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


