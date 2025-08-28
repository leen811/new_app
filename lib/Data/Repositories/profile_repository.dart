import 'package:dio/dio.dart';

abstract class IProfileRepository {
  Future<Map<String, dynamic>> me();
  Future<Map<String, dynamic>> performance();
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
}


