import 'package:dio/dio.dart';
import '../Models/geofence_models.dart';

abstract class IPolicyRepository {
  Future<AttendancePolicy> fetchAttendancePolicy();
}

class PolicyRepository implements IPolicyRepository {
  final Dio dio;
  PolicyRepository(this.dio);
  @override
  Future<AttendancePolicy> fetchAttendancePolicy() async {
    final r = await dio.get('attendance/policy');
    return AttendancePolicy.fromJson(Map<String, dynamic>.from(r.data as Map));
  }
}


