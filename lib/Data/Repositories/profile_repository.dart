import 'package:dio/dio.dart';

abstract class IProfileRepository {
  Future<Map<String, dynamic>> me();
  Future<Map<String, dynamic>> performance();
  Future<Map<String, dynamic>> personalInfo();
  Future<Map<String, dynamic>> updatePersonalInfo(Map<String, dynamic> payload);
}

class ProfileRepository implements IProfileRepository {
  final Dio dio;
  ProfileRepository(this.dio);
  @override
  Future<Map<String, dynamic>> me() async {
    final resp = await dio.get('/v1/profile/me');
    return Map<String, dynamic>.from(resp.data as Map);
  }

  @override
  Future<Map<String, dynamic>> performance() async {
    final resp = await dio.get('/v1/profile/performance');
    return Map<String, dynamic>.from(resp.data as Map);
  }
  @override
  Future<Map<String, dynamic>> personalInfo() async {
    final resp = await dio.get('/v1/profile/personal-info');
    return Map<String, dynamic>.from(resp.data as Map);
  }
  @override
  Future<Map<String, dynamic>> updatePersonalInfo(Map<String, dynamic> payload) async {
    final resp = await dio.put('/v1/profile/personal-info', data: payload);
    return Map<String, dynamic>.from(resp.data as Map);
  }
}


